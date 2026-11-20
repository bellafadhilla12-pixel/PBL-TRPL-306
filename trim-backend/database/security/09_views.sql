-- =====================================================================
-- 09_views.sql
-- View baca-saja untuk laporan dan pembatasan kolom sensitif.
-- Jalankan sebagai trim_admin agar DEFINER view = trim_admin, bukan root.
-- Grant ke trim_reader dijalankan terpisah oleh root: 09_view_grants.sql.
-- =====================================================================

USE trimset;

CREATE OR REPLACE VIEW v_warga_publik AS
SELECT
    w.id_warga,
    w.nama,
    CASE
        WHEN CHAR_LENGTH(w.no_hp) >= 6
            THEN CONCAT(LEFT(w.no_hp, 4), '****', RIGHT(w.no_hp, 2))
        ELSE '****'
    END AS no_hp_masked,
    w.status_verifikasi
FROM warga AS w;

CREATE OR REPLACE VIEW v_kategori_aktif AS
SELECT
    k.id_kategori,
    k.nama_kategori,
    k.harga_per_kg
FROM kategori_sampah AS k
WHERE k.status = 'aktif';

CREATE OR REPLACE VIEW v_transaksi_ringkas AS
SELECT
    t.id_transaksi,
    t.id_antrian,
    w.id_warga,
    w.nama AS nama_warga,
    t.tanggal_transaksi,
    t.total_berat,
    t.total_nilai,
    t.status,
    COUNT(d.id_detail) AS jumlah_item
FROM transaksi_penimbangan AS t
JOIN antrian AS a ON a.id_antrian = t.id_antrian
JOIN warga AS w ON w.id_warga = a.id_warga
LEFT JOIN detail_transaksi AS d ON d.id_transaksi = t.id_transaksi
GROUP BY
    t.id_transaksi, t.id_antrian, w.id_warga, w.nama,
    t.tanggal_transaksi, t.total_berat, t.total_nilai, t.status;

CREATE OR REPLACE VIEW v_pencairan_ringkas AS
SELECT
    p.id_pencairan,
    p.id_warga,
    w.nama AS nama_warga,
    p.tanggal_pengajuan,
    p.tanggal_pencairan,
    p.jumlah,
    p.status,
    jp.tanggal_pencairan AS tanggal_jadwal
FROM pencairan AS p
JOIN warga AS w ON w.id_warga = p.id_warga
LEFT JOIN jadwal_pencairan AS jp
    ON jp.id_jadwal_pencairan = p.id_jadwal_pencairan;

CREATE OR REPLACE VIEW v_rekap_kas AS
SELECT
    periode,
    SUM(jumlah_transaksi) AS jumlah_transaksi,
    SUM(pemasukan) AS total_pemasukan,
    SUM(pengeluaran) AS total_pengeluaran,
    SUM(pemasukan - pengeluaran) AS saldo_bersih
FROM (
    SELECT
        DATE_FORMAT(t.tanggal_transaksi, '%Y-%m') AS periode,
        COUNT(*) AS jumlah_transaksi,
        COALESCE(SUM(t.total_nilai), 0) AS pemasukan,
        0 AS pengeluaran
    FROM transaksi_penimbangan AS t
    WHERE t.status = 'sukses'
    GROUP BY DATE_FORMAT(t.tanggal_transaksi, '%Y-%m')

    UNION ALL

    SELECT
        DATE_FORMAT(p.tanggal_pengajuan, '%Y-%m') AS periode,
        COUNT(*) AS jumlah_transaksi,
        0 AS pemasukan,
        COALESCE(SUM(p.jumlah), 0) AS pengeluaran
    FROM pencairan AS p
    WHERE p.status = 'selesai'
    GROUP BY DATE_FORMAT(p.tanggal_pengajuan, '%Y-%m')
) AS rekap
GROUP BY periode;
