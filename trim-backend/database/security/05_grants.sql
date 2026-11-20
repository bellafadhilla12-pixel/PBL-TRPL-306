-- =====================================================================
-- 05_grants.sql
-- Least privilege untuk database trimset.
-- Jalankan sebagai root setelah 03_accounts.local.sql.
-- =====================================================================

-- Bersihkan grant langsung lama (USAGE tetap dipertahankan).
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'trim_admin'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'trim_app'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'trim_reader'@'localhost';

-- ---------------------------------------------------------------------
-- trim_admin: pengelola skema trimset
-- ---------------------------------------------------------------------
GRANT ALL PRIVILEGES ON trimset.* TO 'trim_admin'@'localhost';

-- ---------------------------------------------------------------------
-- trim_app: aplikasi Laravel
-- Hanya DML yang benar-benar dipakai. Tidak ada DDL, FILE, PROCESS,
-- SUPER, CREATE USER, atau akses ke database lain.
-- ---------------------------------------------------------------------
-- users: register (INSERT) + login/read (SELECT). Tidak ada update user.
GRANT SELECT, INSERT ON trimset.users TO 'trim_app'@'localhost';
GRANT SELECT, INSERT, UPDATE ON trimset.warga TO 'trim_app'@'localhost';
-- Profil pengurus/UBS hanya dibaca aplikasi; dibuat oleh admin/seeder.
GRANT SELECT ON trimset.pengurus TO 'trim_app'@'localhost';
GRANT SELECT ON trimset.ubs TO 'trim_app'@'localhost';
GRANT SELECT ON trimset.saldo TO 'trim_app'@'localhost';
GRANT SELECT, INSERT, UPDATE ON trimset.kategori_sampah TO 'trim_app'@'localhost';
GRANT SELECT, INSERT, UPDATE ON trimset.pengumuman TO 'trim_app'@'localhost';
GRANT SELECT, INSERT, UPDATE ON trimset.jadwal_penimbangan TO 'trim_app'@'localhost';
GRANT SELECT, INSERT, UPDATE ON trimset.jadwal_pencairan TO 'trim_app'@'localhost';
GRANT SELECT, INSERT, UPDATE ON trimset.antrian TO 'trim_app'@'localhost';
GRANT SELECT, INSERT, UPDATE ON trimset.transaksi_penimbangan TO 'trim_app'@'localhost';
GRANT SELECT, INSERT ON trimset.detail_transaksi TO 'trim_app'@'localhost';
GRANT SELECT, INSERT, UPDATE ON trimset.pencairan TO 'trim_app'@'localhost';

-- Token Sanctum: perlu INSERT (login), UPDATE (last_used_at), DELETE (logout).
GRANT SELECT, INSERT, UPDATE, DELETE ON trimset.personal_access_tokens TO 'trim_app'@'localhost';

-- Tidak ada grant ke migrations/password_reset_tokens: aplikasi tidak
-- memakainya. Migrasi/seed dijalankan sebagai trim_admin.

-- Audit trail: aplikasi hanya boleh menulis, tidak membaca/mengubah/menghapus.
GRANT INSERT ON trimset.audit_log TO 'trim_app'@'localhost';

-- ---------------------------------------------------------------------
-- trim_reader: hanya view laporan. Grant view dilakukan di
-- 09_view_grants.sql setelah view dibuat. Tidak ada grant ke tabel dasar.
-- ---------------------------------------------------------------------
