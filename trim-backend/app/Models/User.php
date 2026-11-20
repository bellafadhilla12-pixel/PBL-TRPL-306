<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, Notifiable;

    protected $table = 'users';

    protected $primaryKey = 'id_user';

    public $incrementing = true;

    protected $keyType = 'int';

    public $timestamps = false;

    protected $fillable = [
        'username',
        'password',
        'role',
        'status',
    ];

    protected $hidden = [
        'password',
    ];

    protected function casts(): array
    {
        return [
            'password' => 'hashed',
        ];
    }

    public function isRole(string ...$roles): bool
    {
        return in_array($this->role, $roles, true);
    }

    public function isActive(): bool
    {
        return $this->status === 'aktif';
    }

    public function warga(): HasOne
    {
        return $this->hasOne(Warga::class, 'id_user', 'id_user');
    }

    public function pengurus(): HasOne
    {
        return $this->hasOne(Pengurus::class, 'id_user', 'id_user');
    }

    public function ubs(): HasOne
    {
        return $this->hasOne(Ubs::class, 'id_user', 'id_user');
    }
}
