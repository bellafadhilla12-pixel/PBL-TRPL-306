<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Pengumuman extends Model
{
    protected $table = 'pengumuman';

    protected $primaryKey = 'id_pengumuman';

    public $timestamps = false;

    protected $fillable = [
        'id_pengurus',
        'judul',
        'deskripsi',
        'tanggal_pengumuman',
        'status',
    ];

    protected function casts(): array
    {
        return [
            'tanggal_pengumuman' => 'date',
        ];
    }

    public function pengurus(): BelongsTo
    {
        return $this->belongsTo(Pengurus::class, 'id_pengurus', 'id_pengurus');
    }
}
