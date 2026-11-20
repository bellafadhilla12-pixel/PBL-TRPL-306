<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

class Warga extends Model
{
    public const STATUS_MENUNGGU = 'menunggu';

    public const STATUS_TERVERIFIKASI = 'terverifikasi';

    public const STATUS_DITOLAK = 'ditolak';

    protected $table = 'warga';

    protected $primaryKey = 'id_warga';

    public $timestamps = false;

    protected $fillable = [
        'id_user',
        'nama',
        'no_hp',
        'alamat',
        'status_verifikasi',
    ];

    protected function casts(): array
    {
        return [
            // PII at-rest; ciphertext disimpan di kolom TEXT.
            'alamat' => 'encrypted',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class, 'id_user', 'id_user');
    }

    public function saldo(): HasOne
    {
        return $this->hasOne(Saldo::class, 'id_warga', 'id_warga');
    }

    public function antrian(): HasMany
    {
        return $this->hasMany(Antrian::class, 'id_warga', 'id_warga');
    }

    public function pencairan(): HasMany
    {
        return $this->hasMany(Pencairan::class, 'id_warga', 'id_warga');
    }

    public function transaksi(): HasMany
    {
        return $this->hasManyThrough(
            TransaksiPenimbangan::class,
            Antrian::class,
            'id_warga',
            'id_antrian',
            'id_warga',
            'id_antrian',
        );
    }

    public function terverifikasi(): bool
    {
        return $this->status_verifikasi === self::STATUS_TERVERIFIKASI;
    }
}
