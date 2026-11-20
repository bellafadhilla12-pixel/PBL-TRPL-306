<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\JadwalPencairan;
use App\Models\Pencairan;
use App\Models\TransaksiPenimbangan;
use App\Models\Warga;
use App\Services\SaldoService;
use App\Support\DatabaseError;
use Illuminate\Database\QueryException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class DompetController extends Controller
{
    public function __construct(private SaldoService $saldo) {}

    /**
     * GET /api/dompet (warga)
     */
    public function show(Request $request): JsonResponse
    {
        $warga = $request->user()->warga;
        abort_if(! $warga, 403, 'Dompet hanya untuk warga.');

        $ringkasan = $this->saldo->forWarga($warga);

        $masuk = TransaksiPenimbangan::with('detail.kategori')
            ->whereHas('antrian', fn ($q) => $q->where('id_warga', $warga->id_warga))
            ->where('status', 'sukses')
            ->orderByDesc('tanggal_transaksi')
            ->limit(50)
            ->get()
            ->map(fn (TransaksiPenimbangan $t) => [
                'jenis' => 'masuk',
                'judul' => 'Setoran '.($t->detail->first()?->kategori?->nama_kategori ?? 'sampah'),
                'keterangan' => $t->kode_transaksi,
                'tanggal' => $t->tanggal_transaksi?->toDateString(),
                'nominal' => (float) $t->total_nilai,
                'status' => $t->status,
            ]);

        $keluar = Pencairan::where('id_warga', $warga->id_warga)
            ->orderByDesc('tanggal_pengajuan')
            ->limit(50)
            ->get()
            ->map(fn (Pencairan $p) => [
                'jenis' => 'keluar',
                'judul' => 'Pencairan dana',
                'keterangan' => ucfirst($p->status),
                'tanggal' => ($p->tanggal_pencairan ?? $p->tanggal_pengajuan)?->toDateString(),
                'nominal' => (float) $p->jumlah,
                'status' => $p->status,
            ]);

        return response()->json([
            'data' => array_merge($ringkasan, [
                'riwayat' => $masuk->concat($keluar)
                    ->sortByDesc('tanggal')
                    ->values(),
            ]),
        ]);
    }

    /**
     * GET /api/pencairan
     * Warga melihat miliknya, pengurus/UBS melihat semua.
     */
    public function pencairanIndex(Request $request): JsonResponse
    {
        $user = $request->user();
        $status = $request->query('status');

        // Kompatibilitas istilah lama: menunggu = diajukan.
        if ($status === 'menunggu') {
            $status = 'diajukan';
        }

        $items = Pencairan::with(['warga.user', 'jadwal', 'pengurus'])
            ->when($user->isRole('warga'), function ($q) use ($user) {
                $q->where('id_warga', $user->warga?->id_warga ?? 0);
            })
            ->when($status, fn ($q, $status) => $q->where('status', $status))
            ->orderByDesc('tanggal_pengajuan')
            ->get()
            ->map(fn (Pencairan $p) => $this->payload($p));

        return response()->json(['data' => $items]);
    }

    /**
     * POST /api/pencairan (warga)
     * Backend memilih jadwal pencairan aktif terdekat bila tidak dikirim.
     */
    public function storePencairan(Request $request): JsonResponse
    {
        $data = $request->validate([
            'nominal' => ['nullable', 'numeric', 'min:1'],
            'jumlah' => ['nullable', 'numeric', 'min:1'],
            'id_jadwal_pencairan' => ['nullable', 'integer', 'exists:jadwal_pencairan,id_jadwal_pencairan'],
            'catatan' => ['nullable', 'string'],
        ]);

        $jumlah = (float) ($data['nominal'] ?? $data['jumlah'] ?? 0);
        if ($jumlah <= 0) {
            throw ValidationException::withMessages([
                'nominal' => ['Nominal pencairan wajib diisi.'],
            ]);
        }

        $warga = $request->user()->warga;
        abort_if(! $warga, 403, 'Pencairan hanya untuk warga.');

        if ($warga->status_verifikasi !== Warga::STATUS_TERVERIFIKASI) {
            return response()->json(['message' => 'Warga belum terverifikasi pengurus.'], 422);
        }

        $jadwal = isset($data['id_jadwal_pencairan'])
            ? JadwalPencairan::find($data['id_jadwal_pencairan'])
            : JadwalPencairan::where('status', 'aktif')
                ->whereDate('batas_pendaftaran', '>=', today())
                ->whereDate('tanggal_pencairan', '>=', today())
                ->whereDoesntHave('pencairan', fn ($q) => $q->where('id_warga', $warga->id_warga))
                ->orderBy('tanggal_pencairan')
                ->first();

        if (! $jadwal) {
            return response()->json([
                'message' => 'Belum ada jadwal pencairan aktif yang belum kamu ikuti. Hubungi pengurus.',
            ], 422);
        }

        $sudahAda = Pencairan::where('id_warga', $warga->id_warga)
            ->where('id_jadwal_pencairan', $jadwal->id_jadwal_pencairan)
            ->exists();

        if ($sudahAda) {
            return response()->json([
                'message' => 'Kamu sudah memiliki pengajuan pada jadwal pencairan ini.',
            ], 422);
        }

        if ($jadwal->status !== 'aktif') {
            return response()->json(['message' => 'Jadwal pencairan tidak aktif.'], 422);
        }

        if ($jadwal->batas_pendaftaran?->isBefore(today())) {
            return response()->json(['message' => 'Pendaftaran pencairan sudah ditutup.'], 422);
        }

        $terisi = Pencairan::where('id_jadwal_pencairan', $jadwal->id_jadwal_pencairan)
            ->where('status', '!=', 'ditolak')
            ->count();

        if ($terisi >= $jadwal->kuota) {
            return response()->json(['message' => 'Kuota pencairan sudah penuh.'], 422);
        }

        $tersedia = $this->saldo->saldoTersedia($warga);
        if ($jumlah > $tersedia) {
            return response()->json([
                'message' => 'Saldo tersedia hanya Rp '.number_format($tersedia, 0, ',', '.').'.',
            ], 422);
        }

        try {
            $pencairan = Pencairan::create([
                'id_warga' => $warga->id_warga,
                'id_jadwal_pencairan' => $jadwal->id_jadwal_pencairan,
                'jumlah' => $jumlah,
                'catatan' => $data['catatan'] ?? null,
            ]);
        } catch (QueryException $e) {
            if ($message = DatabaseError::triggerMessage($e)) {
                return response()->json(['message' => $message], 422);
            }

            throw $e;
        }

        return response()->json([
            'message' => 'Pengajuan pencairan dikirim, menunggu persetujuan pengurus.',
            'data' => $this->payload($pencairan->fresh()->load(['warga.user', 'jadwal', 'pengurus'])),
        ], 201);
    }

    /**
     * PATCH /api/pencairan/{pencairan}/setujui (pengurus)
     * Menyetujui lalu langsung menyelesaikan pembayaran agar saldo
     * langsung berkurang sesuai perilaku UI lama.
     */
    public function setujui(Request $request, Pencairan $pencairan): JsonResponse
    {
        $pengurus = $request->user()->pengurus;
        abort_if(! $pengurus, 403, 'Akun pengurus belum memiliki profil.');

        try {
            DB::transaction(function () use ($pencairan, $pengurus) {
                $p = Pencairan::whereKey($pencairan->id_pencairan)->lockForUpdate()->firstOrFail();

                if (in_array($p->status, ['selesai', 'ditolak'], true)) {
                    throw ValidationException::withMessages([
                        'status' => ['Pencairan ini sudah final.'],
                    ]);
                }

                if ($p->status === 'diajukan') {
                    $p->update([
                        'status' => 'disetujui',
                        'id_pengurus' => $pengurus->id_pengurus,
                    ]);
                    $p->refresh();
                }

                if ($p->status === 'disetujui') {
                    $p->update([
                        'status' => 'selesai',
                        'id_pengurus' => $pengurus->id_pengurus,
                    ]);
                }
            });
        } catch (QueryException $e) {
            if ($message = DatabaseError::triggerMessage($e)) {
                return response()->json(['message' => $message], 422);
            }

            throw $e;
        }

        return response()->json([
            'message' => 'Pencairan disetujui dan dana telah dibayarkan.',
            'data' => $this->payload($pencairan->fresh()->load(['warga.user', 'jadwal', 'pengurus'])),
        ]);
    }

    /**
     * PATCH /api/pencairan/{pencairan}/selesai (pengurus)
     */
    public function selesai(Request $request, Pencairan $pencairan): JsonResponse
    {
        $pengurus = $request->user()->pengurus;
        abort_if(! $pengurus, 403, 'Akun pengurus belum memiliki profil.');

        if ($pencairan->status !== 'disetujui') {
            return response()->json(['message' => 'Pencairan harus berstatus disetujui.'], 422);
        }

        try {
            $pencairan->update([
                'status' => 'selesai',
                'id_pengurus' => $pengurus->id_pengurus,
            ]);
        } catch (QueryException $e) {
            if ($message = DatabaseError::triggerMessage($e)) {
                return response()->json(['message' => $message], 422);
            }

            throw $e;
        }

        return response()->json([
            'message' => 'Pencairan diselesaikan.',
            'data' => $this->payload($pencairan->fresh()->load(['warga.user', 'jadwal', 'pengurus'])),
        ]);
    }

    /**
     * PATCH /api/pencairan/{pencairan}/tolak (pengurus)
     */
    public function tolak(Request $request, Pencairan $pencairan): JsonResponse
    {
        $pengurus = $request->user()->pengurus;
        abort_if(! $pengurus, 403, 'Akun pengurus belum memiliki profil.');

        $data = $request->validate([
            'catatan' => ['nullable', 'string'],
        ]);

        if (in_array($pencairan->status, ['selesai', 'ditolak'], true)) {
            return response()->json(['message' => 'Pencairan ini sudah final.'], 422);
        }

        try {
            $pencairan->update([
                'status' => 'ditolak',
                'id_pengurus' => $pengurus->id_pengurus,
                'catatan' => $data['catatan'] ?? $pencairan->catatan,
            ]);
        } catch (QueryException $e) {
            if ($message = DatabaseError::triggerMessage($e)) {
                return response()->json(['message' => $message], 422);
            }

            throw $e;
        }

        return response()->json([
            'message' => 'Pencairan ditolak.',
            'data' => $this->payload($pencairan->fresh()->load(['warga.user', 'jadwal', 'pengurus'])),
        ]);
    }

    private function payload(Pencairan $p): array
    {
        $warga = $p->warga;

        return [
            'id' => (int) $p->id_pencairan,
            'id_pencairan' => (int) $p->id_pencairan,
            'warga' => $warga ? [
                'id' => (int) $warga->id_warga,
                'id_warga' => (int) $warga->id_warga,
                'id_user' => (int) $warga->id_user,
                'nama' => $warga->nama,
                'whatsapp' => $warga->no_hp,
                'no_hp' => $warga->no_hp,
                'alamat' => $warga->alamat,
            ] : null,
            'jadwal' => $p->jadwal ? [
                'id_jadwal_pencairan' => (int) $p->jadwal->id_jadwal_pencairan,
                'tanggal_pencairan' => $p->jadwal->tanggal_pencairan?->toDateString(),
                'batas_pendaftaran' => $p->jadwal->batas_pendaftaran?->toDateString(),
            ] : null,
            'nominal' => (float) $p->jumlah,
            'jumlah' => (float) $p->jumlah,
            'status' => $p->status,
            'catatan' => $p->catatan,
            'diproses_oleh' => $p->pengurus?->only(['id_pengurus', 'nama']),
            'diproses_pada' => $p->tanggal_pencairan?->toIso8601String(),
            'diajukan_pada' => $p->tanggal_pengajuan?->toIso8601String(),
            'tanggal_pengajuan' => $p->tanggal_pengajuan?->toIso8601String(),
            'tanggal_pencairan' => $p->tanggal_pencairan?->toIso8601String(),
        ];
    }
}
