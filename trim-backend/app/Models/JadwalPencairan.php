<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class JadwalPencairan extends Model
{
    protected $table = 'jadwal_pencairan';

    protected $primaryKey = 'id_jadwal_pencairan';

    public $timestamps = false;

    protected $fillable = [
        'id_pengurus',
        'tanggal_pencairan',
        'batas_pendaftaran',
        'kuota',
        'status',
    ];

    protected function casts(): array
    {
        return [
            'tanggal_pencairan' => 'date',
            'batas_pendaftaran' => 'date',
            'kuota' => 'integer',
        ];
    }

    public function pengurus(): BelongsTo
    {
        return $this->belongsTo(Pengurus::class, 'id_pengurus', 'id_pengurus');
    }

    public function pencairan(): HasMany
    {
        return $this->hasMany(Pencairan::class, 'id_jadwal_pencairan', 'id_jadwal_pencairan');
    }
}
