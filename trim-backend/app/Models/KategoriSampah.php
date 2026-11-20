<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class KategoriSampah extends Model
{
    protected $table = 'kategori_sampah';

    protected $primaryKey = 'id_kategori';

    public $timestamps = false;

    protected $fillable = [
        'nama_kategori',
        'deskripsi',
        'harga_per_kg',
        'status',
    ];

    protected function casts(): array
    {
        return [
            'harga_per_kg' => 'decimal:2',
        ];
    }

    public function detail(): HasMany
    {
        return $this->hasMany(DetailTransaksi::class, 'id_kategori', 'id_kategori');
    }
}
