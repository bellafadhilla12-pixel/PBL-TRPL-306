-- =====================================================================
-- 09_view_grants.sql
-- Grant baca-saja ke view. Jalankan sebagai root setelah 09_views.sql.
-- trim_reader tidak mendapat akses ke tabel dasar.
-- =====================================================================

GRANT SELECT ON trimset.v_warga_publik TO 'trim_reader'@'localhost';
GRANT SELECT ON trimset.v_kategori_aktif TO 'trim_reader'@'localhost';
GRANT SELECT ON trimset.v_transaksi_ringkas TO 'trim_reader'@'localhost';
GRANT SELECT ON trimset.v_pencairan_ringkas TO 'trim_reader'@'localhost';
GRANT SELECT ON trimset.v_rekap_kas TO 'trim_reader'@'localhost';
