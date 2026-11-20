<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Pengurus extends Model
{
    protected $table = 'pengurus';

    protected $primaryKey = 'id_pengurus';

    public $timestamps = false;

    protected $fillable = [
        'id_user',
        'nama',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class, 'id_user', 'id_user');
    }

    public function pengumuman(): HasMany
    {
        return $this->hasMany(Pengumuman::class, 'id_pengurus', 'id_pengurus');
    }

    public function jadwalPenimbangan(): HasMany
    {
        return $this->hasMany(JadwalPenimbangan::class, 'id_pengurus', 'id_pengurus');
    }

    public function jadwalPencairan(): HasMany
    {
        return $this->hasMany(JadwalPencairan::class, 'id_pengurus', 'id_pengurus');
    }

    public function transaksi(): HasMany
    {
        return $this->hasMany(TransaksiPenimbangan::class, 'id_pengurus', 'id_pengurus');
    }

    public function pencairan(): HasMany
    {
        return $this->hasMany(Pencairan::class, 'id_pengurus', 'id_pengurus');
    }
}
