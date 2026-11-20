<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Ubs extends Model
{
    protected $table = 'ubs';

    protected $primaryKey = 'id_ubs';

    public $timestamps = false;

    protected $fillable = [
        'id_user',
        'nama',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class, 'id_user', 'id_user');
    }
}
