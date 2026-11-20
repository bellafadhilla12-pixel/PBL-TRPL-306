<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Satu tabel users untuk tiga role: warga, pengurus, ubs.
     * Field profil warga dibuat nullable karena pengurus/UBS tidak memakainya.
     */
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('nama', 100);
            $table->string('whatsapp', 20)->unique();
            $table->string('email')->nullable()->unique();
            $table->timestamp('email_verified_at')->nullable();
            $table->string('password');

            $table->enum('role', ['warga', 'pengurus', 'ubs'])->default('warga');

            // Profil khusus warga
            $table->string('blok', 10)->nullable();
            $table->string('nomor_rumah', 10)->nullable();
            $table->string('rt', 5)->nullable();
            $table->string('rw', 5)->nullable();
            $table->enum('status_tempat_tinggal', [
                'Rumah Pribadi',
                'Rumah Kontrakan',
                'Lainnya',
            ])->nullable();
            $table->string('keterangan_tempat_tinggal')->nullable();
            $table->string('detail_tempat_tinggal')->nullable();

            $table->enum('status_verifikasi', [
                'menunggu',
                'disetujui',
                'ditolak',
            ])->default('menunggu');
            $table->string('catatan_verifikasi')->nullable();

            $table->boolean('is_active')->default(true);
            $table->timestamp('last_login_at')->nullable();
            $table->rememberToken();
            $table->timestamps();

            $table->index(['role', 'status_verifikasi']);
        });

        Schema::create('password_reset_tokens', function (Blueprint $table) {
            $table->string('email')->primary();
            $table->string('token');
            $table->timestamp('created_at')->nullable();
        });

        Schema::create('sessions', function (Blueprint $table) {
            $table->string('id')->primary();
            $table->foreignId('user_id')->nullable()->index();
            $table->string('ip_address', 45)->nullable();
            $table->text('user_agent')->nullable();
            $table->longText('payload');
            $table->integer('last_activity')->index();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('sessions');
        Schema::dropIfExists('password_reset_tokens');
        Schema::dropIfExists('users');
    }
};
