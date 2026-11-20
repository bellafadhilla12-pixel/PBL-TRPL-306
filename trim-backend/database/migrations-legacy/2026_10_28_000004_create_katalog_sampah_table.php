<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('katalog_sampah', function (Blueprint $table) {
            $table->id();
            $table->foreignId('kategori_id')->constrained('kategori_sampah')->restrictOnDelete();
            $table->string('nama_sampah', 100);
            $table->decimal('harga_per_kg', 12, 2);
            $table->string('deskripsi')->nullable();
            $table->boolean('is_active')->default(true);
            $table->timestamps();

            $table->index(['kategori_id', 'is_active']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('katalog_sampah');
    }
};
