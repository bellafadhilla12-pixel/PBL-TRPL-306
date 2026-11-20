<?php

namespace App\Services;

use App\Models\Pencairan;
use App\Models\Saldo;
use App\Models\TransaksiPenimbangan;
use App\Models\Warga;

/**
 * Saldo pada skema trimset adalah saldo_terakhir yang dijaga trigger.
 * Service ini hanya membaca nilai tersebut dan menghitung dana yang
 * sedang ditahan oleh pengajuan pencairan.
 */
class SaldoService
{
    public function forWarga(Warga $warga): array
    {
        $saldo = (float) (Saldo::where('id_warga', $warga->id_warga)->value('saldo_terakhir') ?? 0);

        $pending = (float) Pencairan::where('id_warga', $warga->id_warga)
            ->whereIn('status', ['diajukan', 'disetujui'])
            ->sum('jumlah');

        $pendapatan = (float) TransaksiPenimbangan::query()
            ->join('antrian as a', 'a.id_antrian', '=', 'transaksi_penimbangan.id_antrian')
            ->where('a.id_warga', $warga->id_warga)
            ->where('transaksi_penimbangan.status', 'sukses')
            ->sum('transaksi_penimbangan.total_nilai');

        $dicairkan = (float) Pencairan::where('id_warga', $warga->id_warga)
            ->where('status', 'selesai')
            ->sum('jumlah');

        return [
            'saldo' => round($saldo, 2),
            'saldo_tersedia' => round(max(0, $saldo - $pending), 2),
            'total_pendapatan' => round($pendapatan, 2),
            'total_dicairkan' => round($dicairkan, 2),
            'menunggu_pencairan' => round($pending, 2),
        ];
    }

    public function saldo(Warga $warga): float
    {
        return $this->forWarga($warga)['saldo'];
    }

    public function saldoTersedia(Warga $warga): float
    {
        return $this->forWarga($warga)['saldo_tersedia'];
    }
}
