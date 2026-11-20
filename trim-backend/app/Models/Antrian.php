<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasOne;

class Antrian extends Model
{
    protected $table = 'antrian';

    protected $primaryKey = 'id_antrian';

    public $timestamps = false;

    protected $fillable = [
        'id_warga',
        'id_jadwal',
        'no_antrian',
        'waktu_daftar',
        'status',
    ];

    protected function casts(): array
    {
        return [
            'no_antrian' => 'integer',
            'waktu_daftar' => 'datetime',
        ];
    }

    public function warga(): BelongsTo
    {
        return $this->belongsTo(Warga::class, 'id_warga', 'id_warga');
    }

    public function jadwal(): BelongsTo
    {
        return $this->belongsTo(JadwalPenimbangan::class, 'id_jadwal', 'id_jadwal');
    }

    public function transaksi(): HasOne
    {
        return $this->hasOne(TransaksiPenimbangan::class, 'id_antrian', 'id_antrian');
    }

    public function getKodeAttribute(): string
    {
        return 'A-'.str_pad((string) $this->no_antrian, 2, '0', STR_PAD_LEFT);
    }
}
