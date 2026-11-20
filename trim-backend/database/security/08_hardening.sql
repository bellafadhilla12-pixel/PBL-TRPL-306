-- =====================================================================
-- 08_hardening.sql  (OPSIONAL / MANUAL)
-- Jalankan hanya setelah backup dan dengan persetujuan DBA.
-- Beberapa perubahan bersifat environment-wide dan dapat memengaruhi
-- aplikasi lain di Laragon.
-- =====================================================================

-- 1) Password root yang kuat.
--    Peringatan: ini dapat memutus phpMyAdmin/Laragon/script lain yang
--    masih memakai root tanpa password. Perbarui konfigurasi terkait.
-- ALTER USER 'root'@'localhost' IDENTIFIED BY '<GANTI_PASSWORD_KUAT>';

-- 2) Kebijakan password (opsional).
-- INSTALL COMPONENT 'file://component_validate_password';
-- SET GLOBAL validate_password.policy = 'MEDIUM';
-- SET GLOBAL validate_password.length = 12;

-- 3) Batasi plugin autentikasi (opsional; sesuaikan dengan client lama).
-- SET GLOBAL authentication_policy = 'caching_sha2_password';

-- 4) Wajib TLS (hanya untuk produksi yang semua koneksinya TLS).
-- SET GLOBAL require_secure_transport = ON;

-- Catatan: bind-address, skip-name-resolve, secure-file-priv, dan
-- require_secure_transport memerlukan restart MySQL. Lihat
-- 08_my.ini.example.
