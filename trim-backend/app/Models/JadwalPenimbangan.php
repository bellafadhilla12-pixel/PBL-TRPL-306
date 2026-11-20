<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class JadwalPenimbangan extends Model
{
    protected $table = 'jadwal_penimbangan';

    protected $primaryKey = 'id_jadwal';

    public $timestamps = false;

    protected $fillable = [
        'id_pengurus',
        'tanggal_penimbangan',
        'waktu_mulai',
        'waktu_selesai',
        'kuota',
        'status',
    ];

    protected function casts(): array
    {
        return [
            'tanggal_penimbangan' => 'date',
            'kuota' => 'integer',
        ];
    }

    public function pengurus(): BelongsTo
    {
        return $this->belongsTo(Pengurus::class, 'id_pengurus', 'id_pengurus');
    }

    public function antrian(): HasMany
    {
        return $this->hasMany(Antrian::class, 'id_jadwal', 'id_jadwal');
    }

    public function transaksi(): HasMany
    {
        return $this->hasManyThrough(
            TransaksiPenimbangan::class,
            Antrian::class,
            'id_jadwal',
            'id_antrian',
            'id_jadwal',
            'id_antrian',
        );
    }
}
