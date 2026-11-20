# TRIM API (Laravel 13) — Database `trimset`

Backend REST API untuk aplikasi Flutter **TRIM** (Tempat Rekapitulasi dan Informasi Manajemen Sampah). Folder ini terpisah dari aplikasi Flutter dan hanya melayani JSON API.

- **Framework:** Laravel 13 / PHP 8.3
- **Database final:** MySQL 8, skema `trimset`
- **Autentikasi:** Laravel Sanctum (Bearer Token)
- **Port dev:** `3000`
- **Sumber skema:** `C:\laragon\www\trimset.sql` (14 tabel, 18 trigger, tanpa data)

---

## 1. Kebutuhan

| Perangkat | Versi |
|---|---|
| PHP | >= 8.2 (diuji 8.3.30) |
| Composer | 2.x |
| MySQL | 8.x (Laragon, diuji 8.4.3) |
| Ekstensi PHP | `pdo_mysql`, `mbstring`, `openssl`, `tokenizer`, `xml`, `ctype`, `json`, `bcmath` |

---

## 2. Instalasi Cepat

```bash
cd C:\laragon\www\trim-backend
composer install
copy .env.example .env
php artisan key:generate
```

### 2.1 Import skema final `trimset`

Skema **wajib** memakai file `C:\laragon\www\trimset.sql` apa adanya. Jangan membuat ulang tabel domain lewat migrasi Laravel.

Lewat phpMyAdmin: pilih **Import** → `trimset.sql`.

Atau lewat CLI MySQL:

```bat
cmd /c "\"C:\laragon\bin\mysql\mysql-8.4.6-winx64\bin\mysql.exe\" -u root < \"C:\laragon\www\trimset.sql\""
```

Hasil import yang benar:

- 14 tabel: `users`, `warga`, `pengurus`, `ubs`, `password_reset_tokens`, `saldo`,
  `kategori_sampah`, `pengumuman`, `jadwal_penimbangan`, `jadwal_pencairan`,
  `antrian`, `transaksi_penimbangan`, `detail_transaksi`, `pencairan`
- 18 trigger
- 0 baris `INSERT` (skema saja)

### 2.2 Konfigurasi `.env`

```env
APP_URL=http://localhost:3000
APP_TIMEZONE=Asia/Jakarta

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=trimset
DB_USERNAME=root
DB_PASSWORD=

SESSION_DRIVER=file
CACHE_STORE=file
QUEUE_CONNECTION=sync
```

Laravel hanya membutuhkan satu tabel tambahan di luar `trimset`, yaitu
`personal_access_tokens` untuk Sanctum. Tabel itu dibuat oleh migrasi yang masih aktif.

### 2.3 Migrasi dan data demo

```bash
php artisan migrate --force
php artisan db:seed --force
php artisan serve --host=0.0.0.0 --port=3000
```

Cek server:

```bash
curl http://127.0.0.1:3000/api/health
```

> **PENTING:** jangan menjalankan `php artisan migrate:fresh`.
> Perintah itu akan **menghapus seluruh tabel `trimset`** dan hanya menyisakan
> `personal_access_tokens`. Reset data demo yang benar cukup:
>
> ```bash
> php artisan db:seed --force
> ```
>
> Seeder memakai `TRUNCATE` pada tabel data (bukan `DROP`), sehingga skema dan
> 18 trigger tetap utuh.

---

## 3. Akun Demo

| Role | Nomor WhatsApp / Username | Password | Keterangan |
|---|---|---|---|
| Warga | `081234567890` | `rahasia123` | Terverifikasi, punya saldo, riwayat, antrean aktif |
| Warga | `081234567891` | `rahasia123` | Menunggu verifikasi pengurus |
| Pengurus | `081111111111` | `123456` | Verifikasi, jadwal, katalog, transaksi, pencairan, rekap |
| UBS | `082222222222` | `123456` | Melihat transaksi dan rekap |

Login dapat memakai **nomor WhatsApp** atau `username`. Pada registrasi warga,
`username` otomatis diisi nomor WhatsApp jika tidak dikirim.

---

## 4. Peran dan Hak Akses

| Fitur | Warga | Pengurus | UBS |
|---|:---:|:---:|:---:|
| Registrasi & login | ✓ | ✓ | ✓ |
| Lihat jadwal, pengumuman, katalog | ✓ | ✓ | ✓ |
| Ambil / batalkan antrean | ✓ | – | – |
| Dompet & ajukan pencairan | ✓ | – | – |
| Lihat transaksi | milik sendiri | semua | semua |
| Verifikasi warga | – | ✓ | – |
| Buat/ubah jadwal & pengumuman | – | ✓ | – |
| Kelola antrean | – | ✓ | – |
| Kelola kategori harga | – | ✓ | – |
| Input transaksi penimbangan | – | ✓ | – |
| Setujui / selesaikan / tolak pencairan | – | ✓ | – |
| Rekap sampah / kas / gabungan | – | ✓ | ✓ |

Middleware: `role:pengurus` dan `role:pengurus,ubs`.

---

## 5. Alur Data Sesuai Trigger `trimset`

Urutan operasi harus mengikuti aturan database:

1. **Registrasi** → buat `users` (role `warga`) → buat `warga`.
   Trigger `after_warga_insert_saldo` otomatis membuat baris `saldo`.
2. **Verifikasi pengurus** → ubah `warga.status_verifikasi` menjadi
   `terverifikasi` (atau `ditolak`).
3. **Ambil antrean** → `POST /antrean` dengan `id_jadwal`.
   Trigger memvalidasi warga terverifikasi, jadwal aktif, tanggal belum lewat,
   dan kuota; lalu mengisi `no_antrian` dan `status = menunggu`.
4. **Penimbangan** → `POST /transaksi` dengan `id_antrian` dan daftar item.
   Trigger membuat header, menghitung `harga_per_kg`, `subtotal`, total header,
   menandai antrean `selesai`, dan menambah `saldo.saldo_terakhir`.
5. **Pencairan** → `POST /pencairan` dengan `nominal`.
   Trigger memvalidasi warga terverifikasi, jadwal pencairan aktif, pendaftaran
   masih dibuka, kuota, dan `saldo - pending` cukup.
   Pengurus menyetujui lewat `PATCH /pencairan/{id}/setujui`; backend menjalankan
   `diajukan → disetujui → selesai` sehingga saldo langsung berkurang.

Status yang dipakai:

| Tabel | Status |
|---|---|
| `users` | `aktif`, `nonaktif` |
| `warga` | `menunggu`, `terverifikasi`, `ditolak` |
| `antrian` | `menunggu`, `selesai`, `batal` |
| `transaksi_penimbangan` | `sukses`, `batal` |
| `pencairan` | `diajukan`, `disetujui`, `selesai`, `ditolak` |
| `jadwal_penimbangan`, `jadwal_pencairan` | `aktif`, `selesai`, `batal` |
| `pengumuman` (teks) | `aktif`, `nonaktif` |

Jika trigger menolak operasi, MySQL mengirim `SQLSTATE 45000` / kode `1644`.
`App\Support\DatabaseError` menangkapnya dan mengembalikan **HTTP 422** dengan
pesan trigger apa adanya, sehingga Flutter dapat menampilkannya ke pengguna.

---

## 6. Daftar Endpoint

Semua endpoint berawalan `/api`.

### Publik

| Method | Endpoint | Fungsi |
|---|---|---|
| GET | `/health` | Cek status server |
| POST | `/register`, `/warga/register` | Registrasi warga |
| POST | `/login` | Login semua role |
| GET | `/jadwal` | Jadwal penimbangan & pencairan |
| GET | `/jadwal?jenis=timbangan&upcoming=1` | Jadwal terdekat per jenis |
| GET | `/jadwal/{id}/slot` | Satu sesi penimbangan (kompatibilitas UI) |
| GET | `/pengumuman` | Pengumuman teks |
| GET | `/katalog` | Kategori sampah + harga/kg |
| GET | `/kategori` | Daftar kategori aktif |

### Butuh token (semua role)

| Method | Endpoint | Fungsi |
|---|---|---|
| GET | `/me` | Profil + saldo (warga) |
| POST | `/logout` | Hapus token aktif |
| GET | `/antrean/saya` | Antrean milik warga |
| POST | `/antrean` | Ambil antrean (`id_jadwal`) |
| DELETE | `/antrean/{id_antrian}` | Batalkan antrean |
| GET | `/dompet` | Saldo, saldo tersedia, riwayat |
| GET | `/pencairan` | Riwayat pencairan (warga: milik sendiri) |
| POST | `/pencairan` | Ajukan pencairan (`nominal`) |
| GET | `/transaksi` | Riwayat penimbangan |
| GET | `/transaksi/{id_transaksi}` | Detail transaksi |

### Khusus pengurus

| Method | Endpoint | Fungsi |
|---|---|---|
| GET | `/verifikasi?status=menunggu` | Daftar calon warga |
| PATCH | `/verifikasi/{id_warga}` | `terverifikasi` / `ditolak` |
| POST | `/pengumuman` | Terbitkan pengumuman teks |
| PATCH | `/pengumuman/{id_pengumuman}` | Ubah pengumuman |
| DELETE | `/pengumuman/{id_pengumuman}` | Nonaktifkan pengumuman |
| POST | `/jadwal` | Terbitkan jadwal (`jenis=timbangan\|pencairan`) |
| PATCH | `/jadwal/{jenis}/{id}` | Ubah jadwal |
| DELETE | `/jadwal/{jenis}/{id}` | Batalkan jadwal |
| GET | `/antrean` | Semua antrean |
| PATCH | `/antrean/{id_antrian}/status` | `menunggu` / `selesai` / `batal` |
| POST | `/katalog` | Tambah kategori harga |
| PATCH | `/katalog/{id_kategori}` | Ubah kategori harga |
| DELETE | `/katalog/{id_kategori}` | Nonaktifkan kategori |
| POST | `/transaksi` | Input hasil timbang (`id_antrian`, `items[]`) |
| PATCH | `/transaksi/{id_transaksi}/batal` | Batalkan transaksi + sesuaikan saldo |
| PATCH | `/pencairan/{id_pencairan}/setujui` | Setujui + selesaikan pembayaran |
| PATCH | `/pencairan/{id_pencairan}/selesai` | Selesaikan pencairan yang sudah disetujui |
| PATCH | `/pencairan/{id_pencairan}/tolak` | Tolak pencairan |

### Pengurus & UBS

| Method | Endpoint | Fungsi |
|---|---|---|
| GET | `/rekap/sampah` | Rekap berat & nilai per kategori |
| GET | `/rekap/kas` | Pemasukan, pengeluaran, saldo, pending |
| GET | `/rekap/gabungan` | Gabungan + top 5 warga |

Semua rekap menerima query opsional:

```text
?periode_awal=YYYY-MM-DD&periode_akhir=YYYY-MM-DD
```

Contoh payload penting:

```json
POST /api/antrean
{ "id_jadwal": 4 }
```

```json
POST /api/transaksi
{
  "id_antrian": 4,
  "items": [
    { "id_kategori": 1, "berat": 1.5 },
    { "id_kategori": 2, "berat": 0.8 }
  ]
}
```

```json
POST /api/pencairan
{ "nominal": 5000, "catatan": "Biaya sekolah" }
```

Jika `id_jadwal_pencairan` tidak dikirim, backend memilih jadwal aktif terdekat
yang **belum pernah diajukan** oleh warga tersebut.

---

## 7. Rumus Saldo

Saldo tidak dihitung ulang dari nol di aplikasi. Nilai utama disimpan pada
`saldo.saldo_terakhir` dan dijaga oleh trigger transaksi/pencairan.

```
saldo             = saldo.saldo_terakhir
pending           = Σ pencairan berstatus diajukan + disetujui
saldo tersedia    = saldo - pending
total pendapatan  = Σ transaksi sukses
total dicairkan   = Σ pencairan selesai
```

Perhitungan ini dipusatkan di `app/Services/SaldoService.php`.

---

## 8. Struktur Proyek

```text
app/
├── Http/
│   ├── Controllers/Api/
│   │   ├── AuthController.php          # registrasi, login, verifikasi warga
│   │   ├── JadwalController.php        # jadwal penimbangan/pencairan
│   │   ├── PengumumanController.php    # pengumuman teks
│   │   ├── AntreanController.php       # antrean per jadwal
│   │   ├── KatalogController.php       # kategori_sampah + harga/kg
│   │   ├── TransaksiController.php     # penimbangan + detail
│   │   ├── DompetController.php        # saldo & pencairan
│   │   └── RekapController.php         # laporan
│   └── Middleware/RoleMiddleware.php
├── Models/                             # User, Warga, Pengurus, Ubs, Saldo,
│                                       # KategoriSampah, JadwalPenimbangan,
│                                       # JadwalPencairan, Antrian,
│                                       # TransaksiPenimbangan, DetailTransaksi,
│                                       # Pencairan, Pengumuman
├── Services/SaldoService.php
└── Support/DatabaseError.php           # pemetaan SQLSTATE 45000 → 422
database/
├── migrations/                         # hanya personal_access_tokens
├── migrations-legacy/                  # migrasi skema lama (arsip, tidak dijalankan)
└── seeders/DatabaseSeeder.php          # data demo mengikuti urutan trigger
routes/api.php
```

Catatan migrasi:

- Tabel domain **tidak** dibuat oleh Laravel; sumbernya `trimset.sql`.
- Migrasi lama dipindahkan ke `database/migrations-legacy` agar tidak bentrok.
- Satu-satunya migrasi aktif adalah pembuat `personal_access_tokens`.

### Relasi utama

```text
users 1─1 warga 1─1 saldo
users 1─1 pengurus
users 1─1 ubs

pengurus 1─N jadwal_penimbangan 1─N antrian 1─1 transaksi_penimbangan
transaksi_penimbangan 1─N detail_transaksi N─1 kategori_sampah

pengurus 1─N jadwal_pencairan 1─N pencairan N─1 warga
pengurus 1─N pengumuman
```

---

## 9. Menghubungkan Flutter

Konfigurasi ada di `lib/services/api_client.dart`:

| Target | Base URL |
|---|---|
| Emulator Android | `http://10.0.2.2:3000/api` (otomatis) |
| Windows / Web / iOS | `http://127.0.0.1:3000/api` (otomatis) |
| HP fisik (satu WiFi) | `ApiClient.overrideBaseUrl = 'http://IP-LAN:3000/api'` |

Jalankan server dengan host `0.0.0.0` agar bisa diakses HP fisik:

```bash
php artisan serve --host=0.0.0.0 --port=3000
```

Catatan:

- `php artisan serve` bersifat single-thread; untuk demo ramai gunakan Apache/Nginx Laragon.
- Android sudah diberi izin `INTERNET` dan `usesCleartextTraffic` (debug) untuk HTTP lokal.
- Token Flutter disimpan di memori; restart aplikasi berarti login ulang.

---

## 10. Pengujian dan Reset Data Demo

```bash
php artisan test
php artisan route:list --path=api
```

Reset data demo **tanpa** menghapus skema/trigger:

```bash
php artisan db:seed --force
```

Uji manual login:

```bash
curl -X POST http://127.0.0.1:3000/api/login \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -d "{\"whatsapp\":\"081234567890\",\"password\":\"rahasia123\"}"
```

Gunakan token dari respons:

```bash
curl http://127.0.0.1:3000/api/dompet \
  -H "Accept: application/json" \
  -H "Authorization: Bearer TOKEN"
```

---

## 11. Catatan Migrasi dari Skema Lama

Perbedaan utama dari backend lama:

| Lama (`trim_api`) | Baru (`trimset`) |
|---|---|
| Profil warga di tabel `users` | Profil di `warga`, `pengurus`, `ubs` |
| Login pakai `whatsapp` | Login pakai `username` (nomor HP) |
| `katalog_sampah` per item | `kategori_sampah` per kategori + harga/kg |
| Slot 30 menit | Satu antrean per `jadwal_penimbangan` |
| Saldo dihitung ulang | `saldo.saldo_terakhir` dijaga trigger |
| Pencairan tanpa jadwal | Wajib `jadwal_pencairan` aktif |
| Status `disetujui` pada warga | `terverifikasi` |
| Status pencairan `menunggu` | `diajukan` |
| `migrate:fresh` aman | **Jangan** `migrate:fresh`; impor SQL + `db:seed` |

Semua perubahan ini sudah diterapkan pada controller, model, seeder, dan
kontrak API yang dipakai aplikasi Flutter.
