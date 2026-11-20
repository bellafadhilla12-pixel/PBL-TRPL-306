<?php

namespace App\Support;

use Illuminate\Database\QueryException;

class DatabaseError
{
    /**
     * MySQL SIGNAL SQLSTATE '45000' muncul sebagai errorInfo:
     * [0 => '45000', 1 => 1644, 2 => 'pesan trigger'].
     */
    public static function triggerMessage(QueryException $e): ?string
    {
        $sqlState = $e->errorInfo[0] ?? null;
        $driverCode = $e->errorInfo[1] ?? null;

        if ($sqlState !== '45000' && $driverCode !== 1644) {
            return null;
        }

        $message = trim((string) ($e->errorInfo[2] ?? $e->getMessage()));

        // Sebagian driver menambahkan kode numerik di depan pesan.
        return preg_replace('/^\d+\s+/', '', $message) ?: 'Operasi ditolak oleh aturan database.';
    }
}
