<?php

namespace App\Providers;

use App\Models\Antrian;
use App\Models\DetailTransaksi;
use App\Models\JadwalPencairan;
use App\Models\JadwalPenimbangan;
use App\Models\KategoriSampah;
use App\Models\Pencairan;
use App\Models\Pengumuman;
use App\Models\Pengurus;
use App\Models\Saldo;
use App\Models\TransaksiPenimbangan;
use App\Models\Ubs;
use App\Models\User;
use App\Models\Warga;
use App\Observers\AuditObserver;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        // Audit trail level aplikasi. Saldo yang diubah trigger database
        // tidak memicu event Eloquent; perubahan saldo tetap dapat
        // ditelusuri dari transaksi/pencairan yang memicunya.
        $auditedModels = [
            User::class,
            Warga::class,
            Pengurus::class,
            Ubs::class,
            Saldo::class,
            KategoriSampah::class,
            Pengumuman::class,
            JadwalPenimbangan::class,
            JadwalPencairan::class,
            Antrian::class,
            TransaksiPenimbangan::class,
            DetailTransaksi::class,
            Pencairan::class,
        ];

        foreach ($auditedModels as $model) {
            $model::observe(AuditObserver::class);
        }
    }
}
