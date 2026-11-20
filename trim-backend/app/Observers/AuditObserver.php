<?php

namespace App\Observers;

use App\Models\AuditLog;
use Illuminate\Database\Eloquent\Model;

class AuditObserver
{
    /**
     * Kolom yang tidak boleh disimpan mentah di audit trail.
     * PII tetap dapat ditelusuri lewat object_type/object_id, tetapi
     * nilainya tidak disalin ke log.
     */
    private const REDACTED = [
        'password',
        'remember_token',
        'token',
        'abilities',
        'no_hp',
        'alamat',
        'catatan',
    ];

    public function created(Model $model): void
    {
        $this->write($model, 'create', [], $model->getAttributes());
    }

    public function updated(Model $model): void
    {
        $changes = $model->getChanges();
        $old = [];

        foreach (array_keys($changes) as $key) {
            $old[$key] = $model->getRawOriginal($key);
        }

        $this->write($model, 'update', $old, $changes);
    }

    public function deleted(Model $model): void
    {
        $this->write($model, 'delete', $model->getAttributes(), []);
    }

    private function write(Model $model, string $action, array $old, array $new): void
    {
        AuditLog::record(
            action: $action,
            objectType: $model->getTable(),
            objectId: (string) $model->getKey(),
            oldValues: $this->redact($old),
            newValues: $this->redact($new),
            result: 'success',
        );
    }

    private function redact(array $values): array
    {
        foreach (self::REDACTED as $key) {
            if (array_key_exists($key, $values)) {
                $values[$key] = '***';
            }
        }

        return $values;
    }
}
