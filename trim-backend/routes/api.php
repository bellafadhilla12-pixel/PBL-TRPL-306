<?php

use App\Http\Controllers\Api\AntreanController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\DompetController;
use App\Http\Controllers\Api\JadwalController;
use App\Http\Controllers\Api\KatalogController;
use App\Http\Controllers\Api\PengumumanController;
use App\Http\Controllers\Api\RekapController;
use App\Http\Controllers\Api\TransaksiController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| TRIM API (database: trimset)
|--------------------------------------------------------------------------
| Semua endpoint di file ini otomatis berawalan /api.
*/

Route::get('/health', fn () => response()->json([
    'status' => 'ok',
    'service' => 'TRIM API',
    'database' => 'trimset',
    'time' => now()->toIso8601String(),
]));

// ---------------------------------------------------------------------
// Publik
// ---------------------------------------------------------------------
Route::post('/register', [AuthController::class, 'register']);
Route::post('/warga/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::get('/jadwal', [JadwalController::class, 'index']);
Route::get('/jadwal/{id}/slot', [JadwalController::class, 'slot']);
Route::get('/pengumuman', [PengumumanController::class, 'index']);
Route::get('/katalog', [KatalogController::class, 'index']);
Route::get('/kategori', [KatalogController::class, 'kategori']);

// ---------------------------------------------------------------------
// Semua role yang sudah login
// ---------------------------------------------------------------------
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/me', [AuthController::class, 'me']);
    Route::post('/logout', [AuthController::class, 'logout']);

    // Warga
    Route::get('/antrean/saya', [AntreanController::class, 'mine']);
    Route::post('/antrean', [AntreanController::class, 'store']);
    Route::delete('/antrean/{antrian}', [AntreanController::class, 'cancel']);

    Route::get('/dompet', [DompetController::class, 'show']);
    Route::get('/pencairan', [DompetController::class, 'pencairanIndex']);
    Route::post('/pencairan', [DompetController::class, 'storePencairan']);

    // Warga melihat miliknya, pengurus/UBS melihat semua
    Route::get('/transaksi', [TransaksiController::class, 'index']);
    Route::get('/transaksi/{transaksi}', [TransaksiController::class, 'show']);

    // -----------------------------------------------------------------
    // Khusus pengurus
    // -----------------------------------------------------------------
    Route::middleware('role:pengurus')->group(function () {
        Route::get('/verifikasi', [AuthController::class, 'verifikasiIndex']);
        Route::patch('/verifikasi/{warga}', [AuthController::class, 'verifikasiUpdate']);

        Route::post('/pengumuman', [PengumumanController::class, 'store']);
        Route::patch('/pengumuman/{pengumuman}', [PengumumanController::class, 'update']);
        Route::delete('/pengumuman/{pengumuman}', [PengumumanController::class, 'destroy']);

        Route::post('/jadwal', [JadwalController::class, 'store']);
        Route::patch('/jadwal/{jenis}/{id}', [JadwalController::class, 'update']);
        Route::delete('/jadwal/{jenis}/{id}', [JadwalController::class, 'destroy']);

        Route::get('/antrean', [AntreanController::class, 'index']);
        Route::patch('/antrean/{antrian}/status', [AntreanController::class, 'updateStatus']);

        Route::post('/katalog', [KatalogController::class, 'store']);
        Route::patch('/katalog/{katalog}', [KatalogController::class, 'update']);
        Route::delete('/katalog/{katalog}', [KatalogController::class, 'destroy']);

        Route::post('/transaksi', [TransaksiController::class, 'store']);
        Route::patch('/transaksi/{transaksi}/batal', [TransaksiController::class, 'batal']);

        Route::patch('/pencairan/{pencairan}/setujui', [DompetController::class, 'setujui']);
        Route::patch('/pencairan/{pencairan}/selesai', [DompetController::class, 'selesai']);
        Route::patch('/pencairan/{pencairan}/tolak', [DompetController::class, 'tolak']);
    });

    // -----------------------------------------------------------------
    // Pengurus & UBS
    // -----------------------------------------------------------------
    Route::middleware('role:pengurus,ubs')->group(function () {
        Route::get('/rekap/sampah', [RekapController::class, 'sampah']);
        Route::get('/rekap/kas', [RekapController::class, 'kas']);
        Route::get('/rekap/gabungan', [RekapController::class, 'gabungan']);
    });
});
