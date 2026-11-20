<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('detail_transaksi', function (Blueprint $table) {
            $table->id();
            $table->foreignId('transaksi_id')->constrained('transaksi_penimbangan')->cascadeOnDelete();
            $table->foreignId('katalog_id')->constrained('katalog_sampah')->restrictOnDelete();
            $table->decimal('berat_kg', 10, 2);
            $table->decimal('harga_per_kg', 12, 2);
            $table->decimal('subtotal', 14, 2);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('detail_transaksi');
    }
};
