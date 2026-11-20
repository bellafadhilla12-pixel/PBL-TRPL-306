<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('transaksi_penimbangan', function (Blueprint $table) {
            $table->id();
            $table->string('kode_transaksi', 30)->unique();
            $table->foreignId('warga_id')->constrained('users')->restrictOnDelete();
            $table->foreignId('pengurus_id')->nullable()->constrained('users')->nullOnDelete();
            $table->date('tanggal');
            $table->decimal('total_berat_kg', 10, 2)->default(0);
            $table->decimal('total_nilai', 14, 2)->default(0);
            $table->string('catatan')->nullable();
            $table->timestamps();

            $table->index(['warga_id', 'tanggal']);
            $table->index('tanggal');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('transaksi_penimbangan');
    }
};
