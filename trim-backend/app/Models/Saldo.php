<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Saldo extends Model
{
    protected $table = 'saldo';

    protected $primaryKey = 'id_saldo';

    public $timestamps = false;

    protected $fillable = [
        'id_warga',
        'saldo_terakhir',
    ];

    protected function casts(): array
    {
        return [
            'saldo_terakhir' => 'decimal:2',
        ];
    }

    public function warga(): BelongsTo
    {
        return $this->belongsTo(Warga::class, 'id_warga', 'id_warga');
    }
}
