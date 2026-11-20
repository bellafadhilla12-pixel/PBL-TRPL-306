<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class AuditLog extends Model
{
    protected $table = 'audit_log';

    protected $primaryKey = 'id_audit';

    public $timestamps = false;

    protected $fillable = [
        'actor_user_id',
        'actor_role',
        'action',
        'object_type',
        'object_id',
        'old_values',
        'new_values',
        'result',
        'http_method',
        'http_path',
        'http_status',
        'ip_address',
        'user_agent',
    ];

    protected function casts(): array
    {
        return [
            'old_values' => 'array',
            'new_values' => 'array',
            'http_status' => 'integer',
            'created_at' => 'datetime',
        ];
    }

    /**
     * Catat satu aktivitas penting. Nilai sensitif tidak boleh masuk
     * old_values/new_values; pemanggil wajib meredaksinya.
     */
    public static function record(
        string $action,
        string $objectType,
        ?string $objectId = null,
        array $oldValues = [],
        array $newValues = [],
        string $result = 'success',
        ?int $httpStatus = null,
        ?int $actorUserId = null,
        ?string $actorRole = null,
    ): self {
        $user = Auth::user();
        $request = request();

        return self::create([
            'actor_user_id' => $actorUserId ?? $user?->id_user,
            'actor_role' => $actorRole ?? $user?->role,
            'action' => $action,
            'object_type' => $objectType,
            'object_id' => $objectId,
            'old_values' => $oldValues ?: null,
            'new_values' => $newValues ?: null,
            'result' => $result,
            'http_method' => $request?->method(),
            'http_path' => $request?->path(),
            'http_status' => $httpStatus,
            'ip_address' => $request?->ip(),
            'user_agent' => $request?->userAgent()
                ? substr((string) $request->userAgent(), 0, 255)
                : null,
        ]);
    }
}
