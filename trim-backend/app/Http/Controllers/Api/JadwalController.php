<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\JadwalPencairan;
use App\Models\JadwalPenimbangan;
use App\Support\DatabaseError;
use Illuminate\Database\QueryException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Collection;
use Illuminate\Validation\ValidationException;

class JadwalController extends Controller
{
    /**
     * GET /api/jadwal?jenis=timbangan|pencairan&upcoming=1
     * Satu jadwal = satu sesi. Tidak ada lagi slot 30 menit.
     */
    public function index(Request $request): JsonResponse
    {
        $jenis = $request->query('jenis');
        $upcoming = $request->boolean('upcoming');
        $status = $request->query('status');

        $items = collect();

        if (! $jenis || $jenis === 'timbangan') {
            $items = $items->concat($this->penimbanganItems($upcoming, $status));
        }

        if (! $jenis || $jenis === 'pencairan') {
            $items = $items->concat($this->pencairanItems($upcoming, $status));
        }

        $items = $items
            ->sortBy(fn (array $item) => $item['tanggal'].' '.($item['mulai'] ?? '00:00'))
            ->values();

        return response()->json(['data' => $items]);
    }

    /**
     * GET /api/jadwal/{id}/slot
     * Dipertahankan agar layar antrean Flutter tetap mendapat satu pilihan
     * slot yang mewakili seluruh sesi penimbangan.
     */
    public function slot(int $id): JsonResponse
    {
        $jadwal = JadwalPenimbangan::withCount([
            'antrian as terdaftar' => fn ($q) => $q->where('status', '!=', 'batal'),
        ])->findOrFail($id);

        $terdaftar = (int) $jadwal->terdaftar;
        $mulai = substr((string) $jadwal->waktu_mulai, 0, 5);
        $selesai = substr((string) $jadwal->waktu_selesai, 0, 5);

        return response()->json([
            'data' => [
                'pengumuman_id' => (int) $jadwal->id_jadwal,
                'jadwal_id' => (int) $jadwal->id_jadwal,
                'jenis' => 'timbangan',
                'tanggal' => $jadwal->tanggal_penimbangan?->toDateString(),
                'kuota' => (int) $jadwal->kuota,
                'kuota_per_slot' => (int) $jadwal->kuota,
                'slots' => [[
                    'mulai' => $mulai,
                    'selesai' => $selesai,
                    'terdaftar' => $terdaftar,
                    'kuota' => (int) $jadwal->kuota,
                    'tersedia' => $terdaftar < (int) $jadwal->kuota,
                ]],
            ],
        ]);
    }

    /**
     * POST /api/jadwal
     * Body memakai nama field lama (tanggal, jam_mulai, jam_selesai, kuota)
     * agar form Flutter tidak perlu berubah banyak.
     */
    public function store(Request $request): JsonResponse
    {
        $pengurus = $request->user()->pengurus;
        abort_if(! $pengurus, 403, 'Akun pengurus belum memiliki profil.');

        $data = $request->validate([
            'jenis' => ['required', 'in:timbangan,pencairan'],
            'judul' => ['nullable', 'string', 'max:255'],
            'tanggal' => ['required', 'date'],
            'jam_mulai' => ['nullable', 'date_format:H:i'],
            'jam_selesai' => ['nullable', 'date_format:H:i', 'after:jam_mulai'],
            'batas_pendaftaran' => ['nullable', 'date', 'before_or_equal:tanggal'],
            'kuota' => ['required', 'integer', 'min:1'],
        ]);

        try {
            if ($data['jenis'] === 'timbangan') {
                if (empty($data['jam_mulai']) || empty($data['jam_selesai'])) {
                    throw ValidationException::withMessages([
                        'jam_mulai' => ['Jam mulai dan selesai wajib diisi untuk penimbangan.'],
                    ]);
                }

                $jadwal = JadwalPenimbangan::create([
                    'id_pengurus' => $pengurus->id_pengurus,
                    'tanggal_penimbangan' => $data['tanggal'],
                    'waktu_mulai' => $data['jam_mulai'],
                    'waktu_selesai' => $data['jam_selesai'],
                    'kuota' => $data['kuota'],
                    'status' => 'aktif',
                ]);

                $payload = $this->penimbanganPayload($jadwal->loadCount([
                    'antrian as terdaftar' => fn ($q) => $q->where('status', '!=', 'batal'),
                ]));
            } else {
                $batas = $data['batas_pendaftaran'] ?? $data['tanggal'];

                $jadwal = JadwalPencairan::create([
                    'id_pengurus' => $pengurus->id_pengurus,
                    'tanggal_pencairan' => $data['tanggal'],
                    'batas_pendaftaran' => $batas,
                    'kuota' => $data['kuota'],
                    'status' => 'aktif',
                ]);

                $payload = $this->pencairanPayload($jadwal->loadCount([
                    'pencairan as terdaftar' => fn ($q) => $q->where('status', '!=', 'ditolak'),
                ]));
            }
        } catch (QueryException $e) {
            if ($message = DatabaseError::triggerMessage($e)) {
                return response()->json(['message' => $message], 422);
            }

            throw $e;
        }

        return response()->json([
            'message' => 'Jadwal berhasil diterbitkan.',
            'data' => $payload,
        ], 201);
    }

    public function update(Request $request, string $jenis, int $id): JsonResponse
    {
        $data = $request->validate([
            'tanggal' => ['sometimes', 'date'],
            'jam_mulai' => ['sometimes', 'date_format:H:i'],
            'jam_selesai' => ['sometimes', 'date_format:H:i'],
            'batas_pendaftaran' => ['sometimes', 'date'],
            'kuota' => ['sometimes', 'integer', 'min:1'],
            'status' => ['sometimes', 'in:aktif,selesai,batal'],
        ]);

        if ($jenis === 'timbangan') {
            $jadwal = JadwalPenimbangan::findOrFail($id);
            $jadwal->update(array_filter([
                'tanggal_penimbangan' => $data['tanggal'] ?? null,
                'waktu_mulai' => $data['jam_mulai'] ?? null,
                'waktu_selesai' => $data['jam_selesai'] ?? null,
                'kuota' => $data['kuota'] ?? null,
                'status' => $data['status'] ?? null,
            ], fn ($v) => $v !== null));

            $payload = $this->penimbanganPayload($jadwal->fresh()->loadCount([
                'antrian as terdaftar' => fn ($q) => $q->where('status', '!=', 'batal'),
            ]));
        } elseif ($jenis === 'pencairan') {
            $jadwal = JadwalPencairan::findOrFail($id);
            $jadwal->update(array_filter([
                'tanggal_pencairan' => $data['tanggal'] ?? null,
                'batas_pendaftaran' => $data['batas_pendaftaran'] ?? null,
                'kuota' => $data['kuota'] ?? null,
                'status' => $data['status'] ?? null,
            ], fn ($v) => $v !== null));

            $payload = $this->pencairanPayload($jadwal->fresh()->loadCount([
                'pencairan as terdaftar' => fn ($q) => $q->where('status', '!=', 'ditolak'),
            ]));
        } else {
            abort(404);
        }

        return response()->json([
            'message' => 'Jadwal diperbarui.',
            'data' => $payload,
        ]);
    }

    public function destroy(string $jenis, int $id): JsonResponse
    {
        if ($jenis === 'timbangan') {
            JadwalPenimbangan::findOrFail($id)->update(['status' => 'batal']);
        } elseif ($jenis === 'pencairan') {
            JadwalPencairan::findOrFail($id)->update(['status' => 'batal']);
        } else {
            abort(404);
        }

        return response()->json(['message' => 'Jadwal dibatalkan.']);
    }

    private function penimbanganItems(bool $upcoming, ?string $status): Collection
    {
        return JadwalPenimbangan::withCount([
            'antrian as terdaftar' => fn ($q) => $q->where('status', '!=', 'batal'),
        ])
            ->when($upcoming, fn ($q) => $q->where('status', 'aktif')->whereDate('tanggal_penimbangan', '>=', today()))
            ->when($status, fn ($q, $status) => $q->where('status', $status))
            ->orderBy('tanggal_penimbangan')
            ->orderBy('waktu_mulai')
            ->get()
            ->map(fn (JadwalPenimbangan $j) => $this->penimbanganPayload($j));
    }

    private function pencairanItems(bool $upcoming, ?string $status): Collection
    {
        return JadwalPencairan::withCount([
            'pencairan as terdaftar' => fn ($q) => $q->where('status', '!=', 'ditolak'),
        ])
            ->when($upcoming, fn ($q) => $q->where('status', 'aktif')->whereDate('batas_pendaftaran', '>=', today()))
            ->when($status, fn ($q, $status) => $q->where('status', $status))
            ->orderBy('tanggal_pencairan')
            ->get()
            ->map(fn (JadwalPencairan $j) => $this->pencairanPayload($j));
    }

    private function penimbanganPayload(JadwalPenimbangan $j): array
    {
        $terdaftar = (int) ($j->terdaftar ?? $j->antrian()->where('status', '!=', 'batal')->count());
        $mulai = substr((string) $j->waktu_mulai, 0, 5);
        $selesai = substr((string) $j->waktu_selesai, 0, 5);

        return [
            'id' => (int) $j->id_jadwal,
            'id_jadwal' => (int) $j->id_jadwal,
            'jenis' => 'timbangan',
            'judul' => 'Jadwal Penimbangan Sampah',
            'tanggal' => $j->tanggal_penimbangan?->toDateString(),
            'mulai' => $mulai,
            'selesai' => $selesai,
            'jam_mulai' => $mulai,
            'jam_selesai' => $selesai,
            'kuota' => (int) $j->kuota,
            'terdaftar' => $terdaftar,
            'tersedia' => $terdaftar < (int) $j->kuota,
            'status' => $j->status,
            'batas_pendaftaran' => null,
            'diterbitkanPada' => ($j->tanggal_penimbangan?->toDateString() ?? '').'T00:00:00+07:00',
            'pengurus' => $j->pengurus?->only(['id_pengurus', 'nama']),
        ];
    }

    private function pencairanPayload(JadwalPencairan $j): array
    {
        $terdaftar = (int) ($j->terdaftar ?? $j->pencairan()->where('status', '!=', 'ditolak')->count());

        return [
            'id' => (int) $j->id_jadwal_pencairan,
            'id_jadwal_pencairan' => (int) $j->id_jadwal_pencairan,
            'jenis' => 'pencairan',
            'judul' => 'Pencairan Dana Cash Bank Sampah',
            'tanggal' => $j->tanggal_pencairan?->toDateString(),
            'mulai' => null,
            'selesai' => null,
            'jam_mulai' => null,
            'jam_selesai' => null,
            'kuota' => (int) $j->kuota,
            'terdaftar' => $terdaftar,
            'tersedia' => $terdaftar < (int) $j->kuota,
            'status' => $j->status,
            'batas_pendaftaran' => $j->batas_pendaftaran?->toDateString(),
            'diterbitkanPada' => ($j->tanggal_pencairan?->toDateString() ?? '').'T00:00:00+07:00',
            'pengurus' => $j->pengurus?->only(['id_pengurus', 'nama']),
        ];
    }
}
