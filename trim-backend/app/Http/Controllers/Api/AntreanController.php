<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Antrian;
use App\Models\JadwalPenimbangan;
use App\Models\Warga;
use App\Support\DatabaseError;
use Illuminate\Database\QueryException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class AntreanController extends Controller
{
    /**
     * POST /api/antrean
     * Satu antrean berlaku untuk satu jadwal penimbangan.
     */
    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'id_jadwal' => ['nullable', 'integer', 'exists:jadwal_penimbangan,id_jadwal'],
            'pengumuman_id' => ['nullable', 'integer', 'exists:jadwal_penimbangan,id_jadwal'],
        ]);

        $idJadwal = $data['id_jadwal'] ?? $data['pengumuman_id'] ?? null;
        if (! $idJadwal) {
            throw ValidationException::withMessages([
                'id_jadwal' => ['Jadwal penimbangan wajib dipilih.'],
            ]);
        }

        $warga = $request->user()->warga;
        abort_if(! $warga, 403, 'Akun ini tidak memiliki profil warga.');

        if ($warga->status_verifikasi !== Warga::STATUS_TERVERIFIKASI) {
            return response()->json([
                'message' => 'Warga belum terverifikasi pengurus.',
            ], 422);
        }

        $jadwal = JadwalPenimbangan::findOrFail($idJadwal);

        if ($jadwal->status !== 'aktif') {
            return response()->json(['message' => 'Jadwal penimbangan tidak aktif.'], 422);
        }

        if ($jadwal->tanggal_penimbangan?->isBefore(today())) {
            return response()->json(['message' => 'Jadwal penimbangan sudah lewat.'], 422);
        }

        $terisi = Antrian::where('id_jadwal', $jadwal->id_jadwal)
            ->where('status', '!=', 'batal')
            ->count();

        if ($terisi >= $jadwal->kuota) {
            return response()->json(['message' => 'Kuota penimbangan sudah penuh.'], 422);
        }

        $existing = Antrian::where('id_warga', $warga->id_warga)
            ->where('id_jadwal', $jadwal->id_jadwal)
            ->first();

        if ($existing && $existing->status !== 'batal') {
            return response()->json([
                'message' => 'Kamu sudah mengambil antrean pada jadwal ini.',
            ], 422);
        }

        if ($existing && $existing->transaksi()->exists()) {
            return response()->json([
                'message' => 'Antrean ini sudah memiliki transaksi dan tidak bisa dipakai ulang.',
            ], 422);
        }

        try {
            if ($existing) {
                // Unique (id_warga, id_jadwal) membuat baris batal harus
                // dipakai ulang, bukan dibuat baris baru.
                $next = (int) Antrian::where('id_jadwal', $jadwal->id_jadwal)
                    ->max('no_antrian') + 1;

                $existing->update([
                    'no_antrian' => $next,
                    'waktu_daftar' => now(),
                    'status' => 'menunggu',
                ]);
                $antrian = $existing;
            } else {
                $antrian = Antrian::create([
                    'id_warga' => $warga->id_warga,
                    'id_jadwal' => $jadwal->id_jadwal,
                ]);
            }
        } catch (QueryException $e) {
            if ($message = DatabaseError::triggerMessage($e)) {
                return response()->json(['message' => $message], 422);
            }

            throw $e;
        }

        return response()->json([
            'message' => 'Antrean timbang berhasil dibuat.',
            'data' => $this->payload($antrian->fresh()->load(['jadwal', 'warga.user'])),
        ], 201);
    }

    /**
     * GET /api/antrean/saya (warga)
     */
    public function mine(Request $request): JsonResponse
    {
        $warga = $request->user()->warga;
        abort_if(! $warga, 403, 'Akun ini tidak memiliki profil warga.');

        $items = Antrian::with('jadwal')
            ->where('id_warga', $warga->id_warga)
            ->orderByDesc('id_antrian')
            ->get()
            ->map(fn (Antrian $a) => $this->payload($a));

        return response()->json(['data' => $items]);
    }

    /**
     * GET /api/antrean (pengurus/UBS)
     */
    public function index(Request $request): JsonResponse
    {
        $items = Antrian::with(['warga.user', 'jadwal'])
            ->when($request->query('id_jadwal'), fn ($q, $id) => $q->where('id_jadwal', $id))
            ->when($request->query('status'), fn ($q, $status) => $q->where('status', $status))
            ->orderBy('id_jadwal')
            ->orderBy('no_antrian')
            ->get()
            ->map(fn (Antrian $a) => $this->payload($a));

        return response()->json(['data' => $items]);
    }

    /**
     * PATCH /api/antrean/{antrian}/status (pengurus)
     */
    public function updateStatus(Request $request, Antrian $antrian): JsonResponse
    {
        $data = $request->validate([
            'status' => ['required', 'in:menunggu,selesai,batal'],
        ]);

        if ($antrian->status === 'selesai' && $data['status'] !== 'selesai') {
            return response()->json([
                'message' => 'Antrean yang sudah selesai tidak dapat diubah.',
            ], 422);
        }

        $antrian->update(['status' => $data['status']]);

        return response()->json([
            'message' => 'Status antrean diperbarui.',
            'data' => $this->payload($antrian->fresh()->load(['jadwal', 'warga.user'])),
        ]);
    }

    /**
     * DELETE /api/antrean/{antrian} (warga membatalkan antreannya)
     */
    public function cancel(Request $request, Antrian $antrian): JsonResponse
    {
        $warga = $request->user()->warga;
        abort_if(! $warga || $antrian->id_warga !== $warga->id_warga, 403, 'Ini bukan antreanmu.');

        if ($antrian->status !== 'menunggu') {
            return response()->json([
                'message' => 'Hanya antrean berstatus menunggu yang bisa dibatalkan.',
            ], 422);
        }

        $antrian->update(['status' => 'batal']);

        return response()->json(['message' => 'Antrean dibatalkan.']);
    }

    private function payload(Antrian $a): array
    {
        $jadwal = $a->jadwal;
        $mulai = $jadwal ? substr((string) $jadwal->waktu_mulai, 0, 5) : null;
        $selesai = $jadwal ? substr((string) $jadwal->waktu_selesai, 0, 5) : null;
        $warga = $a->warga;

        return [
            'id' => (int) $a->id_antrian,
            'id_antrian' => (int) $a->id_antrian,
            'pengumuman_id' => (int) $a->id_jadwal,
            'id_jadwal' => (int) $a->id_jadwal,
            'nomor_antrian' => (int) $a->no_antrian,
            'kode' => 'A-'.str_pad((string) $a->no_antrian, 2, '0', STR_PAD_LEFT),
            'slot_mulai' => $mulai,
            'slot_selesai' => $selesai,
            'jenis_sampah' => [],
            'status' => $a->status,
            'tanggal' => $jadwal?->tanggal_penimbangan?->toDateString(),
            'judul' => 'Jadwal Penimbangan Sampah',
            'waktu_daftar' => $a->waktu_daftar?->toIso8601String(),
            'warga' => $warga ? [
                'id' => (int) $warga->id_warga,
                'id_warga' => (int) $warga->id_warga,
                'id_user' => (int) $warga->id_user,
                'user_id' => (int) $warga->id_user,
                'nama' => $warga->nama,
                'whatsapp' => $warga->no_hp,
                'no_hp' => $warga->no_hp,
                'alamat' => $warga->alamat,
                'status_verifikasi' => $warga->status_verifikasi,
            ] : null,
            'jadwal' => $jadwal ? [
                'id_jadwal' => (int) $jadwal->id_jadwal,
                'tanggal' => $jadwal->tanggal_penimbangan?->toDateString(),
                'mulai' => $mulai,
                'selesai' => $selesai,
                'kuota' => (int) $jadwal->kuota,
                'status' => $jadwal->status,
            ] : null,
        ];
    }
}
