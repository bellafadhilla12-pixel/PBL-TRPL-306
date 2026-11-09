# TRIM — Trash Recycling Information and Management

Aplikasi pengelolaan bank sampah untuk warga, pengurus, dan UBS (pengepul mitra).
Project terdiri dari dua bagian yang terpisah:

| Folder | Teknologi | Fungsi |
|---|---|---|
| `C:\laragon\www\PBL-TRPL-306` | Flutter | Aplikasi warga, pengurus, dan UBS |
| `C:\laragon\www\trim-backend` | Laravel 13 + MySQL 8 | REST API, autentikasi, aturan bisnis |

Database final: **`trimset`** dari `C:\laragon\www\trimset.sql`.

---

## Fitur Utama

1. **Autentikasi & registrasi warga** — login 3 role, registrasi warga baru, verifikasi pengurus.
2. **Pengumuman & jadwal** — pengumuman teks, jadwal penimbangan, jadwal pencairan.
3. **Antrean timbang** — satu antrean per jadwal penimbangan, nomor antrean otomatis, kuota.
4. **Katalog harga** — harga per kategori sampah (Plastik, Logam, Kertas/Kardus, Limbah, Lainnya).
5. **Transaksi penimbangan** — input berat, harga & subtotal dihitung trigger database, saldo otomatis.
6. **Dompet & pencairan** — saldo, saldo tersedia, riwayat, pengajuan dan persetujuan pencairan.
7. **Rekap** — rekap sampah per kategori, rekap kas, dan rekap gabungan + top warga.

Role yang didukung: **warga**, **pengurus**, **ubs**.

---

## Menjalankan Backend

```bash
cd C:\laragon\www\trim-backend
composer install
copy .env.example .env
php artisan key:generate
```

Import skema final (sekali saja):

```bat
cmd /c "\"C:\laragon\bin\mysql\mysql-8.4.6-winx64\bin\mysql.exe\" -u root < \"C:\laragon\www\trimset.sql\""
```

Lalu:

```bash
php artisan migrate --force
php artisan db:seed --force
php artisan serve --host=0.0.0.0 --port=3000
```

> **Jangan memakai `php artisan migrate:fresh`.** Perintah itu menghapus seluruh
> tabel domain `trimset`. Untuk reset data demo gunakan `php artisan db:seed --force`.

Detail konfigurasi, endpoint, trigger, dan rumus saldo ada di
`C:\laragon\www\trim-backend\README.md`.

---

## Menjalankan Flutter

```bash
cd C:\laragon\www\PBL-TRPL-306
flutter pub get
flutter run -d chrome
```

Base URL API otomatis:

| Target | URL |
|---|---|
| Web / Windows / iOS | `http://127.0.0.1:3000/api` |
| Emulator Android | `http://10.0.2.2:3000/api` |
| HP fisik | ubah `ApiClient.overrideBaseUrl` ke IP LAN komputer |

Server harus berjalan di port `3000`.

---

## Akun Demo

| Role | Nomor WhatsApp | Password | Keterangan |
|---|---|---|---|
| Warga | `081234567890` | `rahasia123` | Terverifikasi, punya saldo & riwayat |
| Warga | `081234567891` | `rahasia123` | Menunggu verifikasi pengurus |
| Pengurus | `081111111111` | `123456` | Verifikasi, jadwal, katalog, transaksi, rekap |
| UBS | `082222222222` | `123456` | Melihat transaksi dan rekap |

---

## Pemeriksaan Kualitas

Backend:

```bash
cd C:\laragon\www\trim-backend
php artisan test
php artisan route:list --path=api
```

Flutter:

```bash
cd C:\laragon\www\PBL-TRPL-306
flutter analyze lib
flutter test
flutter build web --release
```

---

## Struktur Singkat

```text
PBL-TRPL-306/
├── lib/
│   ├── screens/warga/       # beranda, antrean, dompet, katalog, profil
│   ├── screens/pengurus/    # verifikasi, kelola jadwal, katalog, rekap
│   ├── screens/ubs/         # profil & rekap UBS
│   └── services/            # ApiClient & AnnouncementStore
├── android/ ios/ web/ ...
└── test/

trim-backend/
├── app/Http/Controllers/Api/
├── app/Models/
├── app/Services/SaldoService.php
├── database/migrations/     # hanya personal_access_tokens
├── database/migrations-legacy/
└── database/seeders/
```

---

## Anggota

1. Maisha Adila Zahra — 4342501045
2. Marsya Zainur Aminarti — 4342501042
3. Bintang Dwi Imam Dermawan — 4342501052
4. Muhammad Zadeq — 4342501046
5. Bella Fadhilla Khairunnisyah Effendi — 4342501053
6. Syera Mardhatillah Deaz — 4342501041
