<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Pencairan;
use App\Models\TransaksiPenimbangan;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;

class RekapController extends Controller
{
    public function sampah(Request $request): JsonResponse
    {
        [$awal, $akhir] = $this->periode($request);

        return response()->json([
            'data' => $this->sampahData($awal, $akhir),
        ]);
    }

    public function kas(Request $request): JsonResponse
    {
        [$awal, $akhir] = $this->periode($request);

        return response()->json([
            'data' => $this->kasData($awal, $akhir),
        ]);
    }

    public function gabungan(Request $request): JsonResponse
    {
        [$awal, $akhir] = $this->periode($request);

        $sampah = $this->sampahData($awal, $akhir);
        $kas = $this->kasData($awal, $akhir);

        $topWarga = TransaksiPenimbangan::query()
            ->join('antrian as a', 'a.id_antrian', '=', 'transaksi_penimbangan.id_antrian')
            ->join('warga as w', 'w.id_warga', '=', 'a.id_warga')
            ->where('transaksi_penimbangan.status', 'sukses')
            ->whereBetween('transaksi_penimbangan.tanggal_transaksi', [$awal, $akhir])
            ->groupBy('w.id_warga', 'w.nama', 'w.no_hp')
            ->selectRaw('w.id_warga, w.nama, w.no_hp,
                SUM(transaksi_penimbangan.total_nilai) as total_nilai,
                SUM(transaksi_penimbangan.total_berat) as total_berat_kg')
            ->orderByDesc('total_nilai')
            ->limit(5)
            ->get()
            ->map(fn ($row) => [
                'warga' => [
                    'id' => (int) $row->id_warga,
                    'id_warga' => (int) $row->id_warga,
                    'nama' => $row->nama,
                    'whatsapp' => $row->no_hp,
                ],
                'total_nilai' => (float) $row->total_nilai,
                'total_berat_kg' => (float) $row->total_berat_kg,
            ]);

        return response()->json([
            'data' => [
                'periode' => $sampah['periode'],
                'sampah' => $sampah,
                'kas' => $kas,
                'top_warga' => $topWarga,
            ],
        ]);
    }

    private function sampahData(Carbon $awal, Carbon $akhir): array
    {
        $rows = TransaksiPenimbangan::query()
            ->join('detail_transaksi as d', 'd.id_transaksi', '=', 'transaksi_penimbangan.id_transaksi')
            ->join('kategori_sampah as k', 'k.id_kategori', '=', 'd.id_kategori')
            ->where('transaksi_penimbangan.status', 'sukses')
            ->whereBetween('transaksi_penimbangan.tanggal_transaksi', [$awal, $akhir])
            ->groupBy('k.id_kategori', 'k.nama_kategori')
            ->selectRaw('k.id_kategori as kategori_id, k.nama_kategori as kategori,
                SUM(d.berat) as total_berat_kg,
                SUM(d.subtotal) as total_nilai')
            ->orderByDesc('total_nilai')
            ->get();

        $totalNilai = (float) $rows->sum('total_nilai');

        $items = $rows->map(fn ($r) => [
            'kategori_id' => (int) $r->kategori_id,
            'kategori' => $r->kategori,
            'warna' => $this->warnaKategori((string) $r->kategori),
            'total_berat_kg' => (float) $r->total_berat_kg,
            'total_nilai' => (float) $r->total_nilai,
            'persentase' => $totalNilai > 0
                ? round((float) $r->total_nilai / $totalNilai * 100, 1)
                : 0,
        ]);

        return [
            'periode' => [
                'awal' => $awal->toDateString(),
                'akhir' => $akhir->toDateString(),
            ],
            'items' => $items,
            'total_berat_kg' => round((float) $rows->sum('total_berat_kg'), 2),
            'total_nilai' => round($totalNilai, 2),
        ];
    }

    private function kasData(Carbon $awal, Carbon $akhir): array
    {
        $pemasukan = (float) TransaksiPenimbangan::where('status', 'sukses')
            ->whereBetween('tanggal_transaksi', [$awal, $akhir])
            ->sum('total_nilai');

        $pengeluaran = (float) Pencairan::where('status', 'selesai')
            ->whereBetween('tanggal_pencairan', [$awal, $akhir])
            ->sum('jumlah');

        $menunggu = (float) Pencairan::whereIn('status', ['diajukan', 'disetujui'])
            ->whereBetween('tanggal_pengajuan', [$awal, $akhir])
            ->sum('jumlah');

        return [
            'periode' => [
                'awal' => $awal->toDateString(),
                'akhir' => $akhir->toDateString(),
            ],
            'pemasukan' => round($pemasukan, 2),
            'pengeluaran' => round($pengeluaran, 2),
            'saldo' => round($pemasukan - $pengeluaran, 2),
            'pencairan_menunggu' => round($menunggu, 2),
            'jumlah_transaksi' => TransaksiPenimbangan::where('status', 'sukses')
                ->whereBetween('tanggal_transaksi', [$awal, $akhir])
                ->count(),
        ];
    }

    /**
     * @return array{0: Carbon, 1: Carbon}
     */
    private function periode(Request $request): array
    {
        $request->validate([
            'periode_awal' => ['nullable', 'date'],
            'periode_akhir' => ['nullable', 'date', 'after_or_equal:periode_awal'],
            'awal' => ['nullable', 'date'],
            'akhir' => ['nullable', 'date', 'after_or_equal:awal'],
        ]);

        $awalInput = $request->query('periode_awal', $request->query('awal'));
        $akhirInput = $request->query('periode_akhir', $request->query('akhir'));

        $awal = $awalInput
            ? Carbon::parse($awalInput)->startOfDay()
            : now()->startOfMonth();

        $akhir = $akhirInput
            ? Carbon::parse($akhirInput)->endOfDay()
            : now()->endOfDay();

        return [$awal, $akhir];
    }

    private function warnaKategori(string $nama): string
    {
        return match (strtolower($nama)) {
            'plastik' => '#2E7D32',
            'logam' => '#1565C0',
            'kertas', 'kertas/kardus', 'kertas & kardus' => '#EF6C00',
            'limbah' => '#C62828',
            default => '#6D4C41',
        };
    }
}
