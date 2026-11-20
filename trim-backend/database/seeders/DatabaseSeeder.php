<?php

namespace Database\Seeders;

use App\Models\Antrian;
use App\Models\DetailTransaksi;
use App\Models\JadwalPencairan;
use App\Models\JadwalPenimbangan;
use App\Models\KategoriSampah;
use App\Models\Pencairan;
use App\Models\Pengumuman;
use App\Models\Pengurus;
use App\Models\TransaksiPenimbangan;
use App\Models\Ubs;
use App\Models\User;
use App\Models\Warga;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $this->kosongkanTabel();

        // -----------------------------------------------------------------
        // Akun demo: 1 warga terverifikasi, 1 warga menunggu, 1 pengurus, 1 UBS
        // -----------------------------------------------------------------
        $pengurusUser = User::create([
            'username' => '081111111111',
            'password' => '123456',
            'role' => 'pengurus',
            'status' => 'aktif',
        ]);

        $ubsUser = User::create([
            'username' => '082222222222',
            'password' => '123456',
            'role' => 'ubs',
            'status' => 'aktif',
        ]);

        $wargaUser = User::create([
            'username' => '081234567890',
            'password' => 'rahasia123',
            'role' => 'warga',
            'status' => 'aktif',
        ]);

        $pendingUser = User::create([
            'username' => '081234567891',
            'password' => 'rahasia123',
            'role' => 'warga',
            'status' => 'aktif',
        ]);

        $pengurus = Pengurus::create([
            'id_user' => $pengurusUser->id_user,
            'nama' => 'Pengurus TRIM',
        ]);

        Ubs::create([
            'id_user' => $ubsUser->id_user,
            'nama' => 'UBS Bersih Sejahtera',
        ]);

        $warga = Warga::create([
            'id_user' => $wargaUser->id_user,
            'nama' => 'Warga Uji',
            'no_hp' => '081234567890',
            'alamat' => 'Blok A No. 12, RT 001, RW 002',
            'status_verifikasi' => Warga::STATUS_TERVERIFIKASI,
        ]);

        Warga::create([
            'id_user' => $pendingUser->id_user,
            'nama' => 'Siti Rahma',
            'no_hp' => '081234567891',
            'alamat' => 'Blok B No. 7, RT 001, RW 002',
            'status_verifikasi' => Warga::STATUS_MENUNGGU,
        ]);

        // Trigger after_warga_insert_saldo sudah membuat baris saldo 0.

        // -----------------------------------------------------------------
        // Kategori sampah (harga per kg) — 22 item sesuai katalog awal
        // -----------------------------------------------------------------
        $kategori = collect([
            // PLASTIK
            ['nama_kategori' => 'Gelas cup bening bersih',      'harga_per_kg' => 4500,  'deskripsi' => 'Label dan tutup dibuang'],
            ['nama_kategori' => 'Gelas cup bening kotor',       'harga_per_kg' => 2200,  'deskripsi' => 'Label & tutup dibuang'],
            ['nama_kategori' => 'Botol plastik bersih',         'harga_per_kg' => 3800,  'deskripsi' => 'Label & tutup dilepas'],
            ['nama_kategori' => 'Botol plastik kotor',          'harga_per_kg' => 1600,  'deskripsi' => 'Nilai lebih rendah dari botol bersih'],
            ['nama_kategori' => 'Ember',                        'harga_per_kg' => 2500,  'deskripsi' => 'Barang plastik keras/tebal'],
            ['nama_kategori' => 'Tutup galon',                  'harga_per_kg' => 3500,  'deskripsi' => 'Dipisah tersendiri'],
            ['nama_kategori' => 'Tutup botol',                  'harga_per_kg' => 3000,  'deskripsi' => 'Dipisah tersendiri'],
            ['nama_kategori' => 'Kresek/kantong asoy warna-warni', 'harga_per_kg' => 800, 'deskripsi' => 'Kering dan bersih'],
            ['nama_kategori' => 'Ember hitam',                  'harga_per_kg' => 1500,  'deskripsi' => 'Dipisah dari ember warna'],
            ['nama_kategori' => 'Kaset CD',                     'harga_per_kg' => 3500,  'deskripsi' => 'Plastik polikarbonat'],
            ['nama_kategori' => 'HDPE',                         'harga_per_kg' => 4000,  'deskripsi' => 'Plastik jenis tebal (galon, botol tebal, dll)'],
            ['nama_kategori' => 'Gelas cup warna',              'harga_per_kg' => 2000,  'deskripsi' => 'Dipisah dari cup bening'],
            // LIMBAH
            ['nama_kategori' => 'Aki bekas',                    'harga_per_kg' => 12000, 'deskripsi' => 'Sisa air aki wajib dibuang dahulu'],
            // LOGAM
            ['nama_kategori' => 'Kaleng alka (aluminium)',      'harga_per_kg' => 13000, 'deskripsi' => 'Kaleng minuman'],
            ['nama_kategori' => 'Besi kropos',                  'harga_per_kg' => 3200,  'deskripsi' => 'Besi tua/berkarat'],
            ['nama_kategori' => 'ALMA (aluminium)',             'harga_per_kg' => 15000, 'deskripsi' => 'Panci/wajan aluminium bekas'],
            // KERTAS/KARDUS
            ['nama_kategori' => 'Karton/kardus',                'harga_per_kg' => 1800,  'deskripsi' => 'Dilipat, dipisah dari lakban plastik'],
            ['nama_kategori' => 'Buku paket pelajaran',         'harga_per_kg' => 1500,  'deskripsi' => 'Sampul/cover harus dilepas dulu'],
            ['nama_kategori' => 'HVS (kertas putih)',           'harga_per_kg' => 2400,  'deskripsi' => 'Kering dan tanpa klip/staples'],
            ['nama_kategori' => 'Kertas padat',                 'harga_per_kg' => 1200,  'deskripsi' => 'Kertas campuran/tebal'],
            ['nama_kategori' => 'Koran bekas',                  'harga_per_kg' => 1600,  'deskripsi' => 'Kering dan rapi'],
            // LAINNYA
            ['nama_kategori' => 'Minyak jelantah',              'harga_per_kg' => 6500,  'deskripsi' => 'Ditampung dalam jerigen/botol tertutup rapat'],
        ])->mapWithKeys(fn (array $row) => [
            $row['nama_kategori'] => KategoriSampah::create($row + ['status' => 'aktif']),
        ]);

        // -----------------------------------------------------------------
        // Pengumuman teks
        // -----------------------------------------------------------------
        Pengumuman::create([
            'id_pengurus' => $pengurus->id_pengurus,
            'judul' => 'Pengingat Pilah Sampah',
            'deskripsi' => 'Pastikan sampah dipilah dari rumah sebelum dibawa ke posko. '
                .'Sampah basah dan sampah bernilai dipisahkan.',
            'tanggal_pengumuman' => today(),
            'status' => 'aktif',
        ]);

        Pengumuman::create([
            'id_pengurus' => $pengurus->id_pengurus,
            'judul' => 'Pencairan Dana Bulan Ini',
            'deskripsi' => 'Pengajuan pencairan dibuka sampai batas pendaftaran yang tertera '
                .'pada jadwal pencairan. Siapkan buku tabungan atau rekening.',
            'tanggal_pengumuman' => today()->subDay(),
            'status' => 'aktif',
        ]);

        // -----------------------------------------------------------------
        // Jadwal penimbangan
        // -----------------------------------------------------------------
        $jadwalHariIni = JadwalPenimbangan::create([
            'id_pengurus' => $pengurus->id_pengurus,
            'tanggal_penimbangan' => today(),
            'waktu_mulai' => '13:00',
            'waktu_selesai' => '15:00',
            'kuota' => 30,
            'status' => 'aktif',
        ]);

        $jadwalHariIni2 = JadwalPenimbangan::create([
            'id_pengurus' => $pengurus->id_pengurus,
            'tanggal_penimbangan' => today(),
            'waktu_mulai' => '16:00',
            'waktu_selesai' => '18:00',
            'kuota' => 30,
            'status' => 'aktif',
        ]);

        $jadwalBesok = JadwalPenimbangan::create([
            'id_pengurus' => $pengurus->id_pengurus,
            'tanggal_penimbangan' => today()->addDay(),
            'waktu_mulai' => '08:00',
            'waktu_selesai' => '11:00',
            'kuota' => 30,
            'status' => 'aktif',
        ]);

        // Antrean untuk transaksi hari ini.
        $antrian1 = Antrian::create([
            'id_warga' => $warga->id_warga,
            'id_jadwal' => $jadwalHariIni->id_jadwal,
        ]);

        $antrian2 = Antrian::create([
            'id_warga' => $warga->id_warga,
            'id_jadwal' => $jadwalHariIni2->id_jadwal,
        ]);

        // Antrean aktif untuk banner/beranda warga.
        Antrian::create([
            'id_warga' => $warga->id_warga,
            'id_jadwal' => $jadwalBesok->id_jadwal,
        ]);

        // -----------------------------------------------------------------
        // Transaksi contoh; harga & subtotal dihitung trigger.
        // -----------------------------------------------------------------
        $this->buatTransaksi(
            $antrian1,
            $pengurus,
            [['Botol plastik bersih', 2.5], ['Kaleng alka (aluminium)', 1.2]],
            today()->subDays(6),
        );

        $this->buatTransaksi(
            $antrian2,
            $pengurus,
            [['Karton/kardus', 3.0]],
            today()->subDays(2),
        );

        // Sesi hari ini sudah selesai dipakai demo, sehingga banner warga
        // mengarah ke jadwal besok yang masih benar-benar bisa diambil.
        $jadwalHariIni->update(['status' => 'selesai']);
        $jadwalHariIni2->update(['status' => 'selesai']);

        // -----------------------------------------------------------------
        // Jadwal pencairan & pencairan contoh
        // -----------------------------------------------------------------
        $jadwalCairPending = JadwalPencairan::create([
            'id_pengurus' => $pengurus->id_pengurus,
            'tanggal_pencairan' => today()->addDays(5),
            'batas_pendaftaran' => today()->addDays(2),
            'kuota' => 20,
            'status' => 'aktif',
        ]);

        $jadwalCairSelesai = JadwalPencairan::create([
            'id_pengurus' => $pengurus->id_pengurus,
            'tanggal_pencairan' => today()->addDays(10),
            'batas_pendaftaran' => today()->addDays(7),
            'kuota' => 20,
            'status' => 'aktif',
        ]);

        // Jadwal tambahan yang belum dipakai warga demo, agar tombol
        // "Ajukan Pencairan" tetap bisa didemokan.
        JadwalPencairan::create([
            'id_pengurus' => $pengurus->id_pengurus,
            'tanggal_pencairan' => today()->addDays(15),
            'batas_pendaftaran' => today()->addDays(12),
            'kuota' => 20,
            'status' => 'aktif',
        ]);

        Pencairan::create([
            'id_warga' => $warga->id_warga,
            'id_jadwal_pencairan' => $jadwalCairPending->id_jadwal_pencairan,
            'jumlah' => 5000,
            'catatan' => 'Pengajuan contoh',
            'tanggal_pengajuan' => today()->subDay(),
        ]);

        $selesai = Pencairan::create([
            'id_warga' => $warga->id_warga,
            'id_jadwal_pencairan' => $jadwalCairSelesai->id_jadwal_pencairan,
            'jumlah' => 10000,
            'catatan' => 'Pencairan contoh',
            'tanggal_pengajuan' => today()->subDays(3),
        ]);

        $selesai->update([
            'status' => 'disetujui',
            'id_pengurus' => $pengurus->id_pengurus,
        ]);
        $selesai->refresh();
        $selesai->update([
            'status' => 'selesai',
            'id_pengurus' => $pengurus->id_pengurus,
        ]);

        $this->command?->info('Seeder trimset selesai.');
        $this->command?->info('Warga    : 081234567890 / rahasia123 (terverifikasi)');
        $this->command?->info('Warga 2  : 081234567891 / rahasia123 (menunggu verifikasi)');
        $this->command?->info('Pengurus : 081111111111 / 123456');
        $this->command?->info('UBS      : 082222222222 / 123456');
    }

    private function buatTransaksi(
        Antrian $antrian,
        Pengurus $pengurus,
        array $items,
        $tanggal,
    ): TransaksiPenimbangan {
        $transaksi = TransaksiPenimbangan::create([
            'id_antrian' => $antrian->id_antrian,
            'id_pengurus' => $pengurus->id_pengurus,
            'tanggal_transaksi' => $tanggal,
        ]);

        foreach ($items as [$namaKategori, $berat]) {
            $kategori = KategoriSampah::where('nama_kategori', $namaKategori)->firstOrFail();

            DetailTransaksi::create([
                'id_transaksi' => $transaksi->id_transaksi,
                'id_kategori' => $kategori->id_kategori,
                'berat' => $berat,
            ]);
        }

        return $transaksi->fresh();
    }

    private function kosongkanTabel(): void
    {
        $tables = [
            'detail_transaksi',
            'transaksi_penimbangan',
            'pencairan',
            'antrian',
            'jadwal_pencairan',
            'jadwal_penimbangan',
            'pengumuman',
            'kategori_sampah',
            'saldo',
            'warga',
            'pengurus',
            'ubs',
            'users',
            'password_reset_tokens',
        ];

        if (Schema::hasTable('personal_access_tokens')) {
            $tables[] = 'personal_access_tokens';
        }

        DB::statement('SET FOREIGN_KEY_CHECKS=0');

        try {
            foreach ($tables as $table) {
                if (Schema::hasTable($table)) {
                    DB::table($table)->truncate();
                }
            }
        } finally {
            DB::statement('SET FOREIGN_KEY_CHECKS=1');
        }
    }
}
