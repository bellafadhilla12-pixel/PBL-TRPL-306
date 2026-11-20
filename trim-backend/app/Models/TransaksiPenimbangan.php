<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class TransaksiPenimbangan extends Model
{
    protected $table = 'transaksi_penimbangan';

    protected $primaryKey = 'id_transaksi';

    public $timestamps = false;

    protected $fillable = [
        'id_antrian',
        'id_pengurus',
        'tanggal_transaksi',
        'total_berat',
        'total_nilai',
        'status',
    ];

    protected function casts(): array
    {
        return [
            'tanggal_transaksi' => 'datetime',
            'total_berat' => 'decimal:2',
            'total_nilai' => 'decimal:2',
        ];
    }

    public function antrian(): BelongsTo
    {
        return $this->belongsTo(Antrian::class, 'id_antrian', 'id_antrian');
    }

    public function pengurus(): BelongsTo
    {
        return $this->belongsTo(Pengurus::class, 'id_pengurus', 'id_pengurus');
    }

    public function detail(): HasMany
    {
        return $this->hasMany(DetailTransaksi::class, 'id_transaksi', 'id_transaksi');
    }

    public function getKodeTransaksiAttribute(): string
    {
        $tanggal = $this->tanggal_transaksi?->format('Ymd') ?? now()->format('Ymd');

        return 'TRX-'.$tanggal.'-'.str_pad((string) $this->id_transaksi, 4, '0', STR_PAD_LEFT);
    }
}
