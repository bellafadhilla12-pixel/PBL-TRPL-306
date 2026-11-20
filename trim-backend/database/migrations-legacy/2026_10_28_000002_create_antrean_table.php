<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('antrean', function (Blueprint $table) {
            $table->id();
            $table->foreignId('pengumuman_id')->constrained('pengumuman')->cascadeOnDelete();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->unsignedInteger('nomor_antrian');
            $table->time('slot_mulai');
            $table->time('slot_selesai');
            $table->json('jenis_sampah')->nullable();
            $table->enum('status', ['menunggu', 'dipanggil', 'selesai', 'batal'])
                ->default('menunggu');
            $table->timestamps();

            $table->unique(['pengumuman_id', 'user_id']);
            $table->unique(['pengumuman_id', 'nomor_antrian']);
            $table->index(['pengumuman_id', 'slot_mulai']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('antrean');
    }
};
