<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Enkripsi at-rest untuk PII yang paling sensitif:
     * - warga.alamat
     * - pencairan.catatan
     *
     * Kolom alamat dilebarkan ke TEXT karena ciphertext Laravel
     * (base64 JSON + IV + MAC) lebih panjang dari plaintext.
     */
    public function up(): void
    {
        Schema::table('warga', function (Blueprint $table) {
            $table->text('alamat')->nullable(false)->change();
        });

        $this->encryptColumn('warga', 'id_warga', 'alamat');
        $this->encryptColumn('pencairan', 'id_pencairan', 'catatan');
    }

    public function down(): void
    {
        $this->decryptColumn('warga', 'id_warga', 'alamat');
        $this->decryptColumn('pencairan', 'id_pencairan', 'catatan');

        Schema::table('warga', function (Blueprint $table) {
            $table->string('alamat', 255)->nullable(false)->change();
        });
    }

    private function encryptColumn(string $table, string $key, string $column): void
    {
        DB::table($table)
            ->select($key, $column)
            ->orderBy($key)
            ->each(function (object $row) use ($table, $key, $column): void {
                $value = $row->{$column};

                if ($value === null || $this->isEncrypted($value)) {
                    return;
                }

                DB::table($table)
                    ->where($key, $row->{$key})
                    ->update([$column => Crypt::encryptString($value)]);
            });
    }

    private function decryptColumn(string $table, string $key, string $column): void
    {
        DB::table($table)
            ->select($key, $column)
            ->orderBy($key)
            ->each(function (object $row) use ($table, $key, $column): void {
                $value = $row->{$column};

                if ($value === null || $value === '' || ! $this->isEncrypted($value)) {
                    return;
                }

                DB::table($table)
                    ->where($key, $row->{$key})
                    ->update([$column => Crypt::decryptString($value)]);
            });
    }

    private function isEncrypted(string $value): bool
    {
        try {
            Crypt::decryptString($value);

            return true;
        } catch (\Throwable) {
            return false;
        }
    }
};
