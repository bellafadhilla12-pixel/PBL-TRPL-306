<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Antrian;
use App\Models\KategoriSampah;
use App\Models\TransaksiPenimbangan;
use App\Support\DatabaseError;
use Illuminate\Database\QueryException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class TransaksiController extends Controller
{
    /**
     * POST /api/transaksi (pengurus)
     * Harga selalu diambil trigger dari kategori_sampah, bukan request.
     */
    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'id_antrian' => ['nullable', 'integer', 'exists:antrian,id_antrian'],
            'warga_id' => ['nullable', 'integer', 'exists:warga,id_warga'],
            'items' => ['required', 'array', 'min:1'],
            'items.*.id_kategori' => ['nullable', 'integer', 'exists:kategori_sampah,id_kategori'],
            'items.*.katalog_id' => ['nullable', 'integer', 'exists:kategori_sampah,id_kategori'],
            'items.*.berat' => ['nullable', 'numeric', 'gt:0'],
            'items.*.berat_kg' => ['nullable', 'numeric', 'gt:0'],
            'catatan' => ['nullable', 'string'],
        ]);

        $pengurus = $request->user()->pengurus;
        abort_if(! $pengurus, 403, 'Akun pengurus belum memiliki profil.');

        $antrian = null;

        if (! empty($data['id_antrian'])) {
            $antrian = Antrian::find($data['id_antrian']);
        } elseif (! empty($data['warga_id'])) {
            $antrian = Antrian::where('id_warga', $data['warga_id'])
                ->where('status', 'menunggu')
                ->orderByDesc('id_antrian')
                ->first();
        }

        if (! $antrian) {
            throw ValidationException::withMessages([
                'id_antrian' => ['Antrean menunggu untuk warga ini tidak ditemukan.'],
            ]);
        }

        $items = collect($data['items'])->map(function (array $item) {
            $idKategori = $item['id_kategori'] ?? $item['katalog_id'] ?? null;
            $berat = $item['berat'] ?? $item['berat_kg'] ?? null;

            if (! $idKategori || ! $berat) {
                throw ValidationException::withMessages([
                    'items' => ['Setiap item wajib berisi kategori dan berat.'],
                ]);
            }

            return [
                'id_kategori' => (int) $idKategori,
                'berat' => round((float) $berat, 2),
            ];
        });

        try {
            $transaksi = DB::transaction(function () use ($antrian, $pengurus, $items) {
                $antrian = Antrian::whereKey($antrian->id_antrian)
                    ->lockForUpdate()
                    ->firstOrFail();

                if ($antrian->status !== 'menunggu') {
                    throw ValidationException::withMessages([
                        'id_antrian' => ['Antrean tidak berstatus menunggu.'],
                    ]);
                }

                $transaksi = TransaksiPenimbangan::create([
                    'id_antrian' => $antrian->id_antrian,
                    'id_pengurus' => $pengurus->id_pengurus,
                ]);

                foreach ($items as $item) {
                    $kategori = KategoriSampah::find($item['id_kategori']);

                    if (! $kategori || $kategori->status !== 'aktif') {
                        throw ValidationException::withMessages([
                            'items' => ['Ada kategori sampah yang tidak aktif.'],
                        ]);
                    }

                    $transaksi->detail()->create([
                        'id_kategori' => $kategori->id_kategori,
                        'berat' => $item['berat'],
                    ]);
                }

                return $transaksi->fresh();
            });
        } catch (QueryException $e) {
            if ($message = DatabaseError::triggerMessage($e)) {
                return response()->json(['message' => $message], 422);
            }

            throw $e;
        }

        return response()->json([
            'message' => 'Transaksi penimbangan tersimpan.',
            'data' => $this->payload($transaksi->load($this->relations())),
        ], 201);
    }

    /**
     * GET /api/transaksi
     * Warga hanya melihat miliknya, pengurus/UBS melihat semua.
     */
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();

        $items = TransaksiPenimbangan::with($this->relations())
            ->when($user->isRole('warga'), function ($q) use ($user) {
                $warga = $user->warga;
                $q->whereHas('antrian', fn ($a) => $a->where('id_warga', $warga?->id_warga ?? 0));
            })
            ->when($request->query('warga_id'), fn ($q, $id) => $q->whereHas(
                'antrian',
                fn ($a) => $a->where('id_warga', $id)
            ))
            ->when($request->query('dari'), fn ($q, $dari) => $q->whereDate('tanggal_transaksi', '>=', $dari))
            ->when($request->query('sampai'), fn ($q, $sampai) => $q->whereDate('tanggal_transaksi', '<=', $sampai))
            ->orderByDesc('tanggal_transaksi')
            ->orderByDesc('id_transaksi')
            ->limit(200)
            ->get()
            ->map(fn (TransaksiPenimbangan $t) => $this->payload($t));

        return response()->json(['data' => $items]);
    }

    public function show(Request $request, TransaksiPenimbangan $transaksi): JsonResponse
    {
        $user = $request->user();

        if ($user->isRole('warga')) {
            $warga = $user->warga;
            abort_if(
                ! $warga || $transaksi->antrian?->id_warga !== $warga->id_warga,
                403,
                'Ini bukan transaksimu.'
            );
        }

        return response()->json([
            'data' => $this->payload($transaksi->load($this->relations())),
        ]);
    }

    /**
     * PATCH /api/transaksi/{transaksi}/batal (pengurus)
     */
    public function batal(TransaksiPenimbangan $transaksi): JsonResponse
    {
        if ($transaksi->status !== 'sukses') {
            return response()->json(['message' => 'Transaksi ini sudah dibatalkan.'], 422);
        }

        try {
            $transaksi->update(['status' => 'batal']);
        } catch (QueryException $e) {
            if ($message = DatabaseError::triggerMessage($e)) {
                return response()->json(['message' => $message], 422);
            }

            throw $e;
        }

        return response()->json([
            'message' => 'Transaksi dibatalkan dan saldo warga disesuaikan.',
            'data' => $this->payload($transaksi->fresh()->load($this->relations())),
        ]);
    }

    private function relations(): array
    {
        return [
            'antrian.warga',
            'pengurus',
            'detail.kategori',
        ];
    }

    private function payload(TransaksiPenimbangan $t): array
    {
        $warga = $t->antrian?->warga;
        $antrian = $t->antrian;

        return [
            'id' => (int) $t->id_transaksi,
            'id_transaksi' => (int) $t->id_transaksi,
            'kode_transaksi' => $t->kode_transaksi,
            'tanggal' => $t->tanggal_transaksi?->toDateString(),
            'tanggal_transaksi' => $t->tanggal_transaksi?->toIso8601String(),
            'warga' => $warga ? [
                'id' => (int) $warga->id_warga,
                'id_warga' => (int) $warga->id_warga,
                'id_user' => (int) $warga->id_user,
                'nama' => $warga->nama,
                'whatsapp' => $warga->no_hp,
                'no_hp' => $warga->no_hp,
                'alamat' => $warga->alamat,
            ] : null,
            'pengurus' => $t->pengurus?->only(['id_pengurus', 'nama']),
            'total_berat_kg' => (float) $t->total_berat,
            'total_berat' => (float) $t->total_berat,
            'total_nilai' => (float) $t->total_nilai,
            'status' => $t->status,
            'catatan' => null,
            'antrian' => $antrian ? [
                'id' => (int) $antrian->id_antrian,
                'id_antrian' => (int) $antrian->id_antrian,
                'id_jadwal' => (int) $antrian->id_jadwal,
                'kode' => 'A-'.str_pad((string) $antrian->no_antrian, 2, '0', STR_PAD_LEFT),
                'status' => $antrian->status,
            ] : null,
            'items' => $t->detail->map(fn ($d) => [
                'id' => (int) $d->id_detail,
                'id_detail' => (int) $d->id_detail,
                'kategori_id' => (int) $d->id_kategori,
                'katalog_id' => (int) $d->id_kategori,
                'id_kategori' => (int) $d->id_kategori,
                'kategori' => $d->kategori?->nama_kategori,
                'nama_sampah' => $d->kategori?->nama_kategori,
                'berat_kg' => (float) $d->berat,
                'berat' => (float) $d->berat,
                'harga_per_kg' => (float) $d->harga_per_kg,
                'subtotal' => (float) $d->subtotal,
            ]),
        ];
    }
}
