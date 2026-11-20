<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Pencairan extends Model
{
    protected $table = 'pencairan';

    protected $primaryKey = 'id_pencairan';

    public $timestamps = false;

    protected $fillable = [
        'id_warga',
        'id_jadwal_pencairan',
        'id_pengurus',
        'tanggal_pengajuan',
        'tanggal_pencairan',
        'jumlah',
        'catatan',
        'status',
    ];

    protected function casts(): array
    {
        return [
            'tanggal_pengajuan' => 'datetime',
            'tanggal_pencairan' => 'datetime',
            'jumlah' => 'decimal:2',
            // Catatan operasional dapat memuat info sensitif.
            'catatan' => 'encrypted',
        ];
    }

    public function warga(): BelongsTo
    {
        return $this->belongsTo(Warga::class, 'id_warga', 'id_warga');
    }

    public function jadwal(): BelongsTo
    {
        return $this->belongsTo(JadwalPencairan::class, 'id_jadwal_pencairan', 'id_jadwal_pencairan');
    }

    public function pengurus(): BelongsTo
    {
        return $this->belongsTo(Pengurus::class, 'id_pengurus', 'id_pengurus');
    }
}
