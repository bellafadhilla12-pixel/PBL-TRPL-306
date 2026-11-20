-- =====================================================================
-- 03_accounts.example.sql
-- Template pemisahan akun database TRIM.
--
-- JANGAN commit password asli. Salin file ini menjadi
-- 03_accounts.local.sql, ganti placeholder, lalu jalankan sebagai root.
--
-- Akun:
--   trim_admin@localhost  : DBA/operasional skema trimset (DDL + DML)
--   trim_app@localhost    : aplikasi Laravel (DML terbatas)
--   trim_reader@localhost : pembaca laporan/view (SELECT view saja)
-- =====================================================================

CREATE USER IF NOT EXISTS 'trim_admin'@'localhost'
  IDENTIFIED BY '__ADMIN_PASSWORD__';
ALTER USER 'trim_admin'@'localhost'
  IDENTIFIED BY '__ADMIN_PASSWORD__';

CREATE USER IF NOT EXISTS 'trim_app'@'localhost'
  IDENTIFIED BY '__APP_PASSWORD__';
ALTER USER 'trim_app'@'localhost'
  IDENTIFIED BY '__APP_PASSWORD__';

CREATE USER IF NOT EXISTS 'trim_reader'@'localhost'
  IDENTIFIED BY '__READER_PASSWORD__';
ALTER USER 'trim_reader'@'localhost'
  IDENTIFIED BY '__READER_PASSWORD__';

-- Pastikan hanya host loopback yang boleh masuk.
-- Jika Laravel memakai TCP 127.0.0.1 dan MySQL tidak me-resolve ke
-- localhost, buat akun tambahan @'127.0.0.1' dengan password yang sama
-- (lihat 07_host_restriction.md).
