-- =====================================================================
-- trimset_final.sql
-- Database final untuk 20 luaran keamanan database TRIM
-- (Flutter PBL-TRPL-306 + Laravel trim-backend + MySQL 8.4)
--
-- ISI FILE:
--   1. Akun database : trim_admin, trim_app, trim_reader
--   2. Skema + data + 18 trigger + 5 view database `trimset`
--   3. Grant least privilege + grant view reader
--
-- CARA IMPORT (WAJIB sebagai root):
--   PowerShell:
--     $mysql = 'C:\laragon\bin\mysql\mysql-8.4.3-winx64\bin\mysql.exe'
--     & $mysql -u root -e "source C:/laragon/www/trim-backend/trimset_final.sql"
--   Atau di prompt MySQL:
--     source C:/laragon/www/trim-backend/trimset_final.sql
--
-- PERINGATAN:
--   File ini menjalankan DROP DATABASE IF EXISTS `trimset`.
--   Gunakan untuk submission / restore, bukan server produksi.
--   Password akun di file ini adalah password lokal (development).
--   Ganti sebelum dipakai di server nyata.
--
-- SETELAH IMPORT (verifikasi cepat):
--   mysql -u root -e "SELECT COUNT(*) tabel FROM information_schema.tables WHERE table_schema='trimset' AND table_type='BASE TABLE';"
--   mysql -u root -e "SELECT COUNT(*) view FROM information_schema.views WHERE table_schema='trimset';"
--   mysql -u root -e "SELECT COUNT(*) trg FROM information_schema.triggers WHERE trigger_schema='trimset';"
--
-- BUKTI 20 LUARAN:
--   powershell -ExecutionPolicy Bypass -File .\scripts\collect-evidence.ps1
-- =====================================================================

-- =====================================================================
-- BAGIAN 1 — AKUN DATABASE
-- =====================================================================
-- =====================================================================
-- 03_accounts.local.sql  (JANGAN COMMIT)
-- Password lokal dibuat acak dan disimpan di
-- storage/security/credentials.local.json.
-- =====================================================================

CREATE USER IF NOT EXISTS 'trim_admin'@'localhost'
  IDENTIFIED BY 'mL9hUCbENE5gD59LiIPz5H3UjUeFAaV0UeB2DOFMNcw';
ALTER USER 'trim_admin'@'localhost'
  IDENTIFIED BY 'mL9hUCbENE5gD59LiIPz5H3UjUeFAaV0UeB2DOFMNcw';

CREATE USER IF NOT EXISTS 'trim_app'@'localhost'
  IDENTIFIED BY 'EHTKUpupD6OFSvC9VFnYa07ggCgDhWheAmToATiY9pA';
ALTER USER 'trim_app'@'localhost'
  IDENTIFIED BY 'EHTKUpupD6OFSvC9VFnYa07ggCgDhWheAmToATiY9pA';

CREATE USER IF NOT EXISTS 'trim_reader'@'localhost'
  IDENTIFIED BY 'CvCLTuYEX40B7xBS43B1ycfUbacvav8ry35hGcJElPw';
ALTER USER 'trim_reader'@'localhost'
  IDENTIFIED BY 'CvCLTuYEX40B7xBS43B1ycfUbacvav8ry35hGcJElPw';


-- =====================================================================
-- BAGIAN 2 - SKEMA + DATA + TRIGGER + VIEW
-- =====================================================================
-- MySQL dump 10.13  Distrib 8.4.3, for Win64 (x86_64)
--
-- Host: localhost    Database: trimset
-- ------------------------------------------------------
-- Server version	8.4.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `trimset`
--

/*!40000 DROP DATABASE IF EXISTS `trimset`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `trimset` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `trimset`;

--
-- Table structure for table `antrian`
--

DROP TABLE IF EXISTS `antrian`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `antrian` (
  `id_antrian` int NOT NULL AUTO_INCREMENT,
  `id_warga` int NOT NULL,
  `id_jadwal` int NOT NULL,
  `no_antrian` int NOT NULL DEFAULT '0',
  `waktu_daftar` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('menunggu','selesai','batal') DEFAULT 'menunggu',
  PRIMARY KEY (`id_antrian`),
  UNIQUE KEY `uq_antrian_warga_jadwal` (`id_warga`,`id_jadwal`),
  UNIQUE KEY `uq_antrian_jadwal_no` (`id_jadwal`,`no_antrian`),
  CONSTRAINT `antrian_ibfk_1` FOREIGN KEY (`id_warga`) REFERENCES `warga` (`id_warga`) ON DELETE RESTRICT,
  CONSTRAINT `antrian_ibfk_2` FOREIGN KEY (`id_jadwal`) REFERENCES `jadwal_penimbangan` (`id_jadwal`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `antrian`
--

LOCK TABLES `antrian` WRITE;
/*!40000 ALTER TABLE `antrian` DISABLE KEYS */;
INSERT INTO `antrian` VALUES (1,1,1,1,'2026-10-28 04:56:48','selesai'),(2,1,2,1,'2026-10-28 04:56:48','selesai'),(3,1,3,1,'2026-10-28 04:56:48','menunggu');
/*!40000 ALTER TABLE `antrian` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_antrian_insert` BEFORE INSERT ON `antrian` FOR EACH ROW BEGIN
  DECLARE v_ver    VARCHAR(20);
  DECLARE v_kuota  INT;
  DECLARE v_status VARCHAR(20);
  DECLARE v_tgl    DATE;
  DECLARE v_terisi INT;

  SELECT `status_verifikasi` INTO v_ver FROM `warga` WHERE `id_warga` = NEW.`id_warga`;
  IF v_ver IS NULL OR v_ver <> 'terverifikasi' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Warga belum terverifikasi';
  END IF;

  SELECT `kuota`, `status`, `tanggal_penimbangan`
    INTO v_kuota, v_status, v_tgl
    FROM `jadwal_penimbangan` WHERE `id_jadwal` = NEW.`id_jadwal` FOR UPDATE;
  IF v_status IS NULL OR v_status <> 'aktif' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Jadwal penimbangan tidak aktif';
  END IF;
  IF v_tgl < CURDATE() THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Jadwal penimbangan sudah lewat';
  END IF;

  SELECT COUNT(*) INTO v_terisi FROM `antrian`
   WHERE `id_jadwal` = NEW.`id_jadwal` AND `status` <> 'batal';
  IF v_terisi >= v_kuota THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Kuota penimbangan sudah penuh';
  END IF;

  SET NEW.`no_antrian` = (SELECT COALESCE(MAX(`no_antrian`),0) + 1
                            FROM `antrian` WHERE `id_jadwal` = NEW.`id_jadwal`);
  SET NEW.`status` = 'menunggu';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `audit_log`
--

DROP TABLE IF EXISTS `audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_log` (
  `id_audit` bigint unsigned NOT NULL AUTO_INCREMENT,
  `actor_user_id` int DEFAULT NULL,
  `actor_role` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `action` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `object_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `object_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `old_values` json DEFAULT NULL,
  `new_values` json DEFAULT NULL,
  `result` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'success',
  `http_method` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `http_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `http_status` smallint DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_audit`),
  KEY `idx_audit_actor` (`actor_user_id`),
  KEY `idx_audit_object` (`object_type`,`object_id`),
  KEY `idx_audit_action` (`action`),
  KEY `idx_audit_created` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_log`
--

LOCK TABLES `audit_log` WRITE;
/*!40000 ALTER TABLE `audit_log` DISABLE KEYS */;
INSERT INTO `audit_log` VALUES (1,NULL,NULL,'post api/login','http_request','api/login',NULL,NULL,'failed','POST','api/login',422,'127.0.0.1','Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.19041.6456','2026-10-28 08:02:12'),(2,3,'warga','login','auth','3',NULL,'{\"role\": \"warga\"}','success','POST','api/login',200,'127.0.0.1','Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.19041.6456','2026-10-28 08:02:14'),(3,1,'pengurus','login','auth','1',NULL,'{\"role\": \"pengurus\"}','success','POST','api/login',200,'127.0.0.1','Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.19041.6456','2026-10-28 08:02:15'),(4,1,'pengurus','update','warga','2','{\"status_verifikasi\": \"menunggu\"}','{\"status_verifikasi\": \"terverifikasi\"}','success','PATCH','api/verifikasi/2',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.19041.6456','2026-10-28 08:02:16'),(5,1,'pengurus','update','warga','2','{\"status_verifikasi\": \"terverifikasi\"}','{\"status_verifikasi\": \"menunggu\"}','success','PATCH','api/verifikasi/2',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.19041.6456','2026-10-28 08:02:17'),(6,3,'warga','get api/verifikasi','http_request','api/verifikasi',NULL,NULL,'failed','GET','api/verifikasi',403,'127.0.0.1','Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.19041.6456','2026-10-28 08:02:18'),(7,4,'warga','login','auth','4',NULL,'{\"role\": \"warga\"}','success','POST','api/login',200,'127.0.0.1','Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.19041.6456','2026-10-28 08:02:19'),(8,4,'warga','post api/antrean','http_request','api/antrean',NULL,NULL,'failed','POST','api/antrean',422,'127.0.0.1','Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.19041.6456','2026-10-28 08:02:20'),(9,3,'warga','logout','auth','3',NULL,NULL,'success','POST','api/logout',200,'127.0.0.1','Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.19041.6456','2026-10-28 08:02:21');
/*!40000 ALTER TABLE `audit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detail_transaksi`
--

DROP TABLE IF EXISTS `detail_transaksi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detail_transaksi` (
  `id_detail` int NOT NULL AUTO_INCREMENT,
  `id_transaksi` int NOT NULL,
  `id_kategori` int NOT NULL,
  `berat` decimal(10,2) NOT NULL,
  `harga_per_kg` decimal(10,2) NOT NULL DEFAULT '0.00',
  `subtotal` decimal(12,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id_detail`),
  KEY `id_transaksi` (`id_transaksi`),
  KEY `id_kategori` (`id_kategori`),
  CONSTRAINT `detail_transaksi_ibfk_1` FOREIGN KEY (`id_transaksi`) REFERENCES `transaksi_penimbangan` (`id_transaksi`) ON DELETE CASCADE,
  CONSTRAINT `detail_transaksi_ibfk_2` FOREIGN KEY (`id_kategori`) REFERENCES `kategori_sampah` (`id_kategori`) ON DELETE RESTRICT,
  CONSTRAINT `chk_dt_berat` CHECK ((`berat` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detail_transaksi`
--

LOCK TABLES `detail_transaksi` WRITE;
/*!40000 ALTER TABLE `detail_transaksi` DISABLE KEYS */;
INSERT INTO `detail_transaksi` VALUES (1,1,3,2.50,3800.00,9500.00),(2,1,14,1.20,13000.00,15600.00),(3,2,17,3.00,1800.00,5400.00);
/*!40000 ALTER TABLE `detail_transaksi` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_detail_insert` BEFORE INSERT ON `detail_transaksi` FOR EACH ROW BEGIN
  DECLARE v_harga  DECIMAL(10,2);
  DECLARE v_status VARCHAR(20);

  SELECT `status` INTO v_status FROM `transaksi_penimbangan`
   WHERE `id_transaksi` = NEW.`id_transaksi` FOR UPDATE;
  IF v_status IS NULL OR v_status <> 'sukses' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi tidak aktif';
  END IF;

  SELECT `harga_per_kg` INTO v_harga FROM `kategori_sampah`
   WHERE `id_kategori` = NEW.`id_kategori` AND `status` = 'aktif';
  IF v_harga IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Kategori sampah tidak aktif';
  END IF;

  SET NEW.`harga_per_kg` = v_harga;
  SET NEW.`subtotal`     = ROUND(NEW.`berat` * v_harga, 2);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_detail_insert` AFTER INSERT ON `detail_transaksi` FOR EACH ROW BEGIN
  UPDATE `transaksi_penimbangan`
     SET `total_berat` = `total_berat` + NEW.`berat`,
         `total_nilai` = `total_nilai` + NEW.`subtotal`
   WHERE `id_transaksi` = NEW.`id_transaksi`;

  UPDATE `saldo` s
    JOIN `transaksi_penimbangan` t ON t.`id_transaksi` = NEW.`id_transaksi`
    JOIN `antrian` a ON a.`id_antrian` = t.`id_antrian`
     SET s.`saldo_terakhir` = s.`saldo_terakhir` + NEW.`subtotal`
   WHERE s.`id_warga` = a.`id_warga`;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_detail_update` BEFORE UPDATE ON `detail_transaksi` FOR EACH ROW BEGIN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Detail transaksi tidak dapat diubah; batalkan transaksi';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_detail_delete` BEFORE DELETE ON `detail_transaksi` FOR EACH ROW BEGIN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Detail transaksi tidak dapat dihapus; batalkan transaksi';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `jadwal_pencairan`
--

DROP TABLE IF EXISTS `jadwal_pencairan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jadwal_pencairan` (
  `id_jadwal_pencairan` int NOT NULL AUTO_INCREMENT,
  `id_pengurus` int NOT NULL,
  `tanggal_pencairan` date NOT NULL,
  `batas_pendaftaran` date NOT NULL,
  `kuota` int NOT NULL,
  `status` enum('aktif','selesai','batal') DEFAULT 'aktif',
  PRIMARY KEY (`id_jadwal_pencairan`),
  KEY `id_pengurus` (`id_pengurus`),
  CONSTRAINT `jadwal_pencairan_ibfk_1` FOREIGN KEY (`id_pengurus`) REFERENCES `pengurus` (`id_pengurus`) ON DELETE RESTRICT,
  CONSTRAINT `chk_jc_valid` CHECK (((`kuota` > 0) and (`batas_pendaftaran` <= `tanggal_pencairan`)))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jadwal_pencairan`
--

LOCK TABLES `jadwal_pencairan` WRITE;
/*!40000 ALTER TABLE `jadwal_pencairan` DISABLE KEYS */;
INSERT INTO `jadwal_pencairan` VALUES (1,1,'2026-11-02','2026-10-30',20,'aktif'),(2,1,'2026-11-07','2026-11-04',20,'aktif'),(3,1,'2026-11-12','2026-11-09',20,'aktif');
/*!40000 ALTER TABLE `jadwal_pencairan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jadwal_penimbangan`
--

DROP TABLE IF EXISTS `jadwal_penimbangan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jadwal_penimbangan` (
  `id_jadwal` int NOT NULL AUTO_INCREMENT,
  `id_pengurus` int NOT NULL,
  `tanggal_penimbangan` date NOT NULL,
  `waktu_mulai` time NOT NULL,
  `waktu_selesai` time NOT NULL,
  `kuota` int NOT NULL,
  `status` enum('aktif','selesai','batal') DEFAULT 'aktif',
  PRIMARY KEY (`id_jadwal`),
  KEY `id_pengurus` (`id_pengurus`),
  CONSTRAINT `jadwal_penimbangan_ibfk_1` FOREIGN KEY (`id_pengurus`) REFERENCES `pengurus` (`id_pengurus`) ON DELETE RESTRICT,
  CONSTRAINT `chk_jp_valid` CHECK (((`waktu_selesai` > `waktu_mulai`) and (`kuota` > 0)))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jadwal_penimbangan`
--

LOCK TABLES `jadwal_penimbangan` WRITE;
/*!40000 ALTER TABLE `jadwal_penimbangan` DISABLE KEYS */;
INSERT INTO `jadwal_penimbangan` VALUES (1,1,'2026-10-28','13:00:00','15:00:00',30,'selesai'),(2,1,'2026-10-28','16:00:00','18:00:00',30,'selesai'),(3,1,'2026-10-29','08:00:00','11:00:00',30,'aktif');
/*!40000 ALTER TABLE `jadwal_penimbangan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kategori_sampah`
--

DROP TABLE IF EXISTS `kategori_sampah`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kategori_sampah` (
  `id_kategori` int NOT NULL AUTO_INCREMENT,
  `nama_kategori` varchar(100) NOT NULL,
  `deskripsi` text,
  `harga_per_kg` decimal(10,2) NOT NULL,
  `status` enum('aktif','nonaktif') DEFAULT 'aktif',
  PRIMARY KEY (`id_kategori`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kategori_sampah`
--

LOCK TABLES `kategori_sampah` WRITE;
/*!40000 ALTER TABLE `kategori_sampah` DISABLE KEYS */;
INSERT INTO `kategori_sampah` VALUES
(1,'Gelas cup bening bersih','Label dan tutup dibuang',4500.00,'aktif'),
(2,'Gelas cup bening kotor','Label & tutup dibuang',2200.00,'aktif'),
(3,'Botol plastik bersih','Label & tutup dilepas',3800.00,'aktif'),
(4,'Botol plastik kotor','Nilai lebih rendah dari botol bersih',1600.00,'aktif'),
(5,'Ember','Barang plastik keras/tebal',2500.00,'aktif'),
(6,'Tutup galon','Dipisah tersendiri',3500.00,'aktif'),
(7,'Tutup botol','Dipisah tersendiri',3000.00,'aktif'),
(8,'Kresek/kantong asoy warna-warni','Kering dan bersih',800.00,'aktif'),
(9,'Ember hitam','Dipisah dari ember warna',1500.00,'aktif'),
(10,'Kaset CD','Plastik polikarbonat',3500.00,'aktif'),
(11,'HDPE','Plastik jenis tebal (galon, botol tebal, dll)',4000.00,'aktif'),
(12,'Gelas cup warna','Dipisah dari cup bening',2000.00,'aktif'),
(13,'Aki bekas','Sisa air aki wajib dibuang dahulu',12000.00,'aktif'),
(14,'Kaleng alka (aluminium)','Kaleng minuman',13000.00,'aktif'),
(15,'Besi kropos','Besi tua/berkarat',3200.00,'aktif'),
(16,'ALMA (aluminium)','Panci/wajan aluminium bekas',15000.00,'aktif'),
(17,'Karton/kardus','Dilipat, dipisah dari lakban plastik',1800.00,'aktif'),
(18,'Buku paket pelajaran','Sampul/cover harus dilepas dulu',1500.00,'aktif'),
(19,'HVS (kertas putih)','Kering dan tanpa klip/staples',2400.00,'aktif'),
(20,'Kertas padat','Kertas campuran/tebal',1200.00,'aktif'),
(21,'Koran bekas','Kering dan rapi',1600.00,'aktif'),
(22,'Minyak jelantah','Ditampung dalam jerigen/botol tertutup rapat',6500.00,'aktif');
/*!40000 ALTER TABLE `kategori_sampah` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'2026_10_27_194914_create_personal_access_tokens_table',1),(2,'2026_10_28_000001_encrypt_sensitive_columns',2);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `id_token` int NOT NULL AUTO_INCREMENT,
  `id_user` int NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_token`),
  KEY `id_user` (`id_user`),
  CONSTRAINT `password_reset_tokens_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pencairan`
--

DROP TABLE IF EXISTS `pencairan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pencairan` (
  `id_pencairan` int NOT NULL AUTO_INCREMENT,
  `id_warga` int NOT NULL,
  `id_jadwal_pencairan` int NOT NULL,
  `id_pengurus` int DEFAULT NULL,
  `tanggal_pengajuan` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `tanggal_pencairan` timestamp NULL DEFAULT NULL,
  `jumlah` decimal(12,2) NOT NULL,
  `catatan` text,
  `status` enum('diajukan','disetujui','selesai','ditolak') DEFAULT 'diajukan',
  PRIMARY KEY (`id_pencairan`),
  UNIQUE KEY `uq_pencairan_warga_jadwal` (`id_warga`,`id_jadwal_pencairan`),
  KEY `id_jadwal_pencairan` (`id_jadwal_pencairan`),
  KEY `id_pengurus` (`id_pengurus`),
  CONSTRAINT `pencairan_ibfk_1` FOREIGN KEY (`id_warga`) REFERENCES `warga` (`id_warga`) ON DELETE RESTRICT,
  CONSTRAINT `pencairan_ibfk_2` FOREIGN KEY (`id_jadwal_pencairan`) REFERENCES `jadwal_pencairan` (`id_jadwal_pencairan`) ON DELETE RESTRICT,
  CONSTRAINT `pencairan_ibfk_3` FOREIGN KEY (`id_pengurus`) REFERENCES `pengurus` (`id_pengurus`) ON DELETE SET NULL,
  CONSTRAINT `chk_pc_jumlah` CHECK ((`jumlah` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pencairan`
--

LOCK TABLES `pencairan` WRITE;
/*!40000 ALTER TABLE `pencairan` DISABLE KEYS */;
INSERT INTO `pencairan` VALUES (1,1,1,NULL,'2026-10-26 17:00:00',NULL,5000.00,'eyJpdiI6Ims4WEROTHYxdzZ1dzNvUWFsTDRGMEE9PSIsInZhbHVlIjoiblZIakpZT01TTUhXQVY4MnM1eDF5dlNSaGF5WXMwckk3dHBNakRoRWpyZz0iLCJtYWMiOiIzYjk3N2UxOTk0MTQwY2YwZWZmMWRlN2ExYmE2MWMzYzYwOTRhNWI1MTEzMTQ4OGQ1ODIyMmI2ZjY5OGMwOTU5IiwidGFnIjoiIn0=','diajukan'),(2,1,2,1,'2026-10-24 17:00:00','2026-10-28 04:56:48',10000.00,'eyJpdiI6IlhkVERNdG9XMERuUGtTelNCRFNPQ1E9PSIsInZhbHVlIjoiZkVlZm1yYkVPOGNCVkVrNCtEUjQ1UzZGaFozd2twcm9HL2ZhQnRHNG01az0iLCJtYWMiOiI5MjNmMTU5OWRjMDJjZDRkNjk2MzgzN2EyNDZjYzQyNjJmMjYxMDVkM2M0MzYxZDMwYzkyNGRlOTVkZjVkYjcyIiwidGFnIjoiIn0=','selesai');
/*!40000 ALTER TABLE `pencairan` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_pencairan_insert` BEFORE INSERT ON `pencairan` FOR EACH ROW BEGIN
  DECLARE v_ver     VARCHAR(20);
  DECLARE v_kuota   INT;
  DECLARE v_status  VARCHAR(20);
  DECLARE v_batas   DATE;
  DECLARE v_terisi  INT;
  DECLARE v_saldo   DECIMAL(12,2);
  DECLARE v_pending DECIMAL(12,2);

  SELECT `status_verifikasi` INTO v_ver FROM `warga` WHERE `id_warga` = NEW.`id_warga`;
  IF v_ver IS NULL OR v_ver <> 'terverifikasi' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Warga belum terverifikasi';
  END IF;

  SELECT `kuota`, `status`, `batas_pendaftaran` INTO v_kuota, v_status, v_batas
    FROM `jadwal_pencairan` WHERE `id_jadwal_pencairan` = NEW.`id_jadwal_pencairan` FOR UPDATE;
  IF v_status IS NULL OR v_status <> 'aktif' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Jadwal pencairan tidak aktif';
  END IF;
  IF CURDATE() > v_batas THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pendaftaran pencairan sudah ditutup';
  END IF;

  SELECT COUNT(*) INTO v_terisi FROM `pencairan`
   WHERE `id_jadwal_pencairan` = NEW.`id_jadwal_pencairan` AND `status` <> 'ditolak';
  IF v_terisi >= v_kuota THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Kuota pencairan sudah penuh';
  END IF;

  SELECT `saldo_terakhir` INTO v_saldo FROM `saldo` WHERE `id_warga` = NEW.`id_warga` FOR UPDATE;
  SELECT COALESCE(SUM(`jumlah`),0) INTO v_pending FROM `pencairan`
   WHERE `id_warga` = NEW.`id_warga` AND `status` IN ('diajukan','disetujui');
  IF v_saldo IS NULL OR NEW.`jumlah` > v_saldo - v_pending THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Saldo tidak mencukupi';
  END IF;

  SET NEW.`status` = 'diajukan';
  SET NEW.`tanggal_pencairan` = NULL;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_pencairan_update` BEFORE UPDATE ON `pencairan` FOR EACH ROW BEGIN
  IF NEW.`id_warga` <> OLD.`id_warga` OR NEW.`jumlah` <> OLD.`jumlah`
     OR NEW.`id_jadwal_pencairan` <> OLD.`id_jadwal_pencairan` THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Warga, jumlah, dan jadwal pencairan tidak dapat diubah';
  END IF;

  IF OLD.`status` IN ('selesai','ditolak') AND NEW.`status` <> OLD.`status` THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pencairan sudah final';
  END IF;

  IF NEW.`status` = 'diajukan' AND OLD.`status` <> 'diajukan' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Status tidak dapat dikembalikan ke diajukan';
  END IF;

  IF NEW.`status` IN ('disetujui','selesai','ditolak') AND NEW.`id_pengurus` IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pengurus pemroses wajib diisi';
  END IF;

  IF NEW.`status` = 'selesai' AND OLD.`status` <> 'selesai' THEN
    IF OLD.`status` <> 'disetujui' THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pencairan harus disetujui terlebih dahulu';
    END IF;
    UPDATE `saldo` SET `saldo_terakhir` = `saldo_terakhir` - NEW.`jumlah`
     WHERE `id_warga` = NEW.`id_warga` AND `saldo_terakhir` >= NEW.`jumlah`;
    IF ROW_COUNT() = 0 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Saldo tidak mencukupi';
    END IF;
    SET NEW.`tanggal_pencairan` = NOW();
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `pengumuman`
--

DROP TABLE IF EXISTS `pengumuman`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pengumuman` (
  `id_pengumuman` int NOT NULL AUTO_INCREMENT,
  `id_pengurus` int NOT NULL,
  `judul` varchar(255) NOT NULL,
  `deskripsi` text NOT NULL,
  `tanggal_pengumuman` date NOT NULL,
  `status` enum('aktif','nonaktif') DEFAULT 'aktif',
  PRIMARY KEY (`id_pengumuman`),
  KEY `id_pengurus` (`id_pengurus`),
  CONSTRAINT `pengumuman_ibfk_1` FOREIGN KEY (`id_pengurus`) REFERENCES `pengurus` (`id_pengurus`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pengumuman`
--

LOCK TABLES `pengumuman` WRITE;
/*!40000 ALTER TABLE `pengumuman` DISABLE KEYS */;
INSERT INTO `pengumuman` VALUES (1,1,'Pengingat Pilah Sampah','Pastikan sampah dipilah dari rumah sebelum dibawa ke posko. Sampah basah dan sampah bernilai dipisahkan.','2026-10-28','aktif'),(2,1,'Pencairan Dana Bulan Ini','Pengajuan pencairan dibuka sampai batas pendaftaran yang tertera pada jadwal pencairan. Siapkan buku tabungan atau rekening.','2026-10-27','aktif');
/*!40000 ALTER TABLE `pengumuman` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pengurus`
--

DROP TABLE IF EXISTS `pengurus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pengurus` (
  `id_pengurus` int NOT NULL AUTO_INCREMENT,
  `id_user` int NOT NULL,
  `nama` varchar(150) NOT NULL,
  PRIMARY KEY (`id_pengurus`),
  UNIQUE KEY `id_user` (`id_user`),
  CONSTRAINT `pengurus_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pengurus`
--

LOCK TABLES `pengurus` WRITE;
/*!40000 ALTER TABLE `pengurus` DISABLE KEYS */;
INSERT INTO `pengurus` VALUES (1,1,'Pengurus TRIM');
/*!40000 ALTER TABLE `pengurus` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_pengurus_insert_role` BEFORE INSERT ON `pengurus` FOR EACH ROW BEGIN
  IF NOT EXISTS (SELECT 1 FROM `users` WHERE `id_user` = NEW.`id_user` AND `role` = 'pengurus') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Buat akun users ber-role pengurus terlebih dahulu';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_pengurus_update_role` BEFORE UPDATE ON `pengurus` FOR EACH ROW BEGIN
  IF NOT EXISTS (SELECT 1 FROM `users` WHERE `id_user` = NEW.`id_user` AND `role` = 'pengurus') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Profil pengurus harus terhubung ke users dengan role pengurus';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  KEY `personal_access_tokens_expires_at_index` (`expires_at`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `saldo`
--

DROP TABLE IF EXISTS `saldo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `saldo` (
  `id_saldo` int NOT NULL AUTO_INCREMENT,
  `id_warga` int NOT NULL,
  `saldo_terakhir` decimal(12,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id_saldo`),
  UNIQUE KEY `id_warga` (`id_warga`),
  CONSTRAINT `saldo_ibfk_1` FOREIGN KEY (`id_warga`) REFERENCES `warga` (`id_warga`) ON DELETE RESTRICT,
  CONSTRAINT `chk_saldo_nonneg` CHECK ((`saldo_terakhir` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `saldo`
--

LOCK TABLES `saldo` WRITE;
/*!40000 ALTER TABLE `saldo` DISABLE KEYS */;
INSERT INTO `saldo` VALUES (1,1,22250.00),(2,2,0.00);
/*!40000 ALTER TABLE `saldo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaksi_penimbangan`
--

DROP TABLE IF EXISTS `transaksi_penimbangan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaksi_penimbangan` (
  `id_transaksi` int NOT NULL AUTO_INCREMENT,
  `id_antrian` int NOT NULL,
  `id_pengurus` int DEFAULT NULL,
  `tanggal_transaksi` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `total_berat` decimal(10,2) DEFAULT '0.00',
  `total_nilai` decimal(12,2) DEFAULT '0.00',
  `status` enum('sukses','batal') DEFAULT 'sukses',
  PRIMARY KEY (`id_transaksi`),
  UNIQUE KEY `id_antrian` (`id_antrian`),
  KEY `id_pengurus` (`id_pengurus`),
  CONSTRAINT `transaksi_penimbangan_ibfk_1` FOREIGN KEY (`id_antrian`) REFERENCES `antrian` (`id_antrian`) ON DELETE RESTRICT,
  CONSTRAINT `transaksi_penimbangan_ibfk_2` FOREIGN KEY (`id_pengurus`) REFERENCES `pengurus` (`id_pengurus`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaksi_penimbangan`
--

LOCK TABLES `transaksi_penimbangan` WRITE;
/*!40000 ALTER TABLE `transaksi_penimbangan` DISABLE KEYS */;
INSERT INTO `transaksi_penimbangan` VALUES (1,1,1,'2026-10-21 17:00:00',3.70,26850.00,'sukses'),(2,2,1,'2026-10-25 17:00:00',3.00,5400.00,'sukses');
/*!40000 ALTER TABLE `transaksi_penimbangan` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_transaksi_insert` BEFORE INSERT ON `transaksi_penimbangan` FOR EACH ROW BEGIN
  DECLARE v_status VARCHAR(20);
  SELECT `status` INTO v_status FROM `antrian` WHERE `id_antrian` = NEW.`id_antrian` FOR UPDATE;
  IF v_status IS NULL OR v_status <> 'menunggu' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Antrian tidak berstatus menunggu';
  END IF;
  SET NEW.`total_berat` = 0;
  SET NEW.`total_nilai` = 0;
  SET NEW.`status` = 'sukses';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_transaksi_insert` AFTER INSERT ON `transaksi_penimbangan` FOR EACH ROW BEGIN
  UPDATE `antrian` SET `status` = 'selesai' WHERE `id_antrian` = NEW.`id_antrian`;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_transaksi_update` AFTER UPDATE ON `transaksi_penimbangan` FOR EACH ROW BEGIN
  IF OLD.`status` = 'sukses' AND NEW.`status` = 'batal' THEN
    UPDATE `saldo` s JOIN `antrian` a ON a.`id_warga` = s.`id_warga`
       SET s.`saldo_terakhir` = s.`saldo_terakhir` - OLD.`total_nilai`
     WHERE a.`id_antrian` = OLD.`id_antrian`
       AND s.`saldo_terakhir` >= OLD.`total_nilai`;
    IF ROW_COUNT() = 0 AND OLD.`total_nilai` > 0 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Saldo tidak cukup untuk membatalkan transaksi';
    END IF;
    UPDATE `antrian` SET `status` = 'batal' WHERE `id_antrian` = OLD.`id_antrian`;
  ELSEIF OLD.`status` = 'batal' AND NEW.`status` <> 'batal' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi batal tidak dapat diaktifkan kembali';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `ubs`
--

DROP TABLE IF EXISTS `ubs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ubs` (
  `id_ubs` int NOT NULL AUTO_INCREMENT,
  `id_user` int NOT NULL,
  `nama` varchar(150) NOT NULL,
  PRIMARY KEY (`id_ubs`),
  UNIQUE KEY `id_user` (`id_user`),
  CONSTRAINT `ubs_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ubs`
--

LOCK TABLES `ubs` WRITE;
/*!40000 ALTER TABLE `ubs` DISABLE KEYS */;
INSERT INTO `ubs` VALUES (1,2,'UBS Bersih Sejahtera');
/*!40000 ALTER TABLE `ubs` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_ubs_insert_role` BEFORE INSERT ON `ubs` FOR EACH ROW BEGIN
  IF NOT EXISTS (SELECT 1 FROM `users` WHERE `id_user` = NEW.`id_user` AND `role` = 'ubs') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Buat akun users ber-role ubs terlebih dahulu';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_ubs_update_role` BEFORE UPDATE ON `ubs` FOR EACH ROW BEGIN
  IF NOT EXISTS (SELECT 1 FROM `users` WHERE `id_user` = NEW.`id_user` AND `role` = 'ubs') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Profil UBS harus terhubung ke users dengan role ubs';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id_user` int NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('warga','pengurus','ubs') NOT NULL,
  `status` enum('aktif','nonaktif') DEFAULT 'aktif',
  PRIMARY KEY (`id_user`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'081111111111','$2y$12$2C7R5l7TXuf80Akx.EuOXeoU647TK/kLAtDojSApWc0siHWfo4l5W','pengurus','aktif'),(2,'082222222222','$2y$12$ukerd9wZrAGlh0N9fe4d7uqHIh/aXbhJNNyzFfponwh5l7AELELgO','ubs','aktif'),(3,'081234567890','$2y$12$BQT6Kpzs3GzVwgapUckewebFgY6Tf1gQviSgtWLVkDCNsKkbS678m','warga','aktif'),(4,'081234567891','$2y$12$A/OtZZXaCTmAQ5djb4q0guKkNesLS2I0RKxgvypIN4axAQ6LNMRiC','warga','aktif');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_users_update_role` BEFORE UPDATE ON `users` FOR EACH ROW BEGIN
  IF NEW.`role` <> OLD.`role` AND (
       EXISTS (SELECT 1 FROM `warga`    WHERE `id_user` = OLD.`id_user`)
    OR EXISTS (SELECT 1 FROM `pengurus` WHERE `id_user` = OLD.`id_user`)
    OR EXISTS (SELECT 1 FROM `ubs`      WHERE `id_user` = OLD.`id_user`)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Role tidak dapat diubah karena profil sudah terhubung';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `v_kategori_aktif`
--

DROP TABLE IF EXISTS `v_kategori_aktif`;
/*!50001 DROP VIEW IF EXISTS `v_kategori_aktif`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_kategori_aktif` AS SELECT 
 1 AS `id_kategori`,
 1 AS `nama_kategori`,
 1 AS `harga_per_kg`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_pencairan_ringkas`
--

DROP TABLE IF EXISTS `v_pencairan_ringkas`;
/*!50001 DROP VIEW IF EXISTS `v_pencairan_ringkas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_pencairan_ringkas` AS SELECT 
 1 AS `id_pencairan`,
 1 AS `id_warga`,
 1 AS `nama_warga`,
 1 AS `tanggal_pengajuan`,
 1 AS `tanggal_pencairan`,
 1 AS `jumlah`,
 1 AS `status`,
 1 AS `tanggal_jadwal`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_rekap_kas`
--

DROP TABLE IF EXISTS `v_rekap_kas`;
/*!50001 DROP VIEW IF EXISTS `v_rekap_kas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_rekap_kas` AS SELECT 
 1 AS `periode`,
 1 AS `jumlah_transaksi`,
 1 AS `total_pemasukan`,
 1 AS `total_pengeluaran`,
 1 AS `saldo_bersih`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_transaksi_ringkas`
--

DROP TABLE IF EXISTS `v_transaksi_ringkas`;
/*!50001 DROP VIEW IF EXISTS `v_transaksi_ringkas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_transaksi_ringkas` AS SELECT 
 1 AS `id_transaksi`,
 1 AS `id_antrian`,
 1 AS `id_warga`,
 1 AS `nama_warga`,
 1 AS `tanggal_transaksi`,
 1 AS `total_berat`,
 1 AS `total_nilai`,
 1 AS `status`,
 1 AS `jumlah_item`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_warga_publik`
--

DROP TABLE IF EXISTS `v_warga_publik`;
/*!50001 DROP VIEW IF EXISTS `v_warga_publik`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_warga_publik` AS SELECT 
 1 AS `id_warga`,
 1 AS `nama`,
 1 AS `no_hp_masked`,
 1 AS `status_verifikasi`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `warga`
--

DROP TABLE IF EXISTS `warga`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `warga` (
  `id_warga` int NOT NULL AUTO_INCREMENT,
  `id_user` int NOT NULL,
  `nama` varchar(150) NOT NULL,
  `no_hp` varchar(20) NOT NULL,
  `alamat` text NOT NULL,
  `status_verifikasi` enum('menunggu','terverifikasi','ditolak') DEFAULT 'menunggu',
  PRIMARY KEY (`id_warga`),
  UNIQUE KEY `id_user` (`id_user`),
  UNIQUE KEY `no_hp` (`no_hp`),
  CONSTRAINT `warga_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `warga`
--

LOCK TABLES `warga` WRITE;
/*!40000 ALTER TABLE `warga` DISABLE KEYS */;
INSERT INTO `warga` VALUES (1,3,'Warga Uji','081234567890','eyJpdiI6IlYwYnhzbnZtMlAxTjVZbGpxb05lamc9PSIsInZhbHVlIjoiZkw1ajhDWDJkcjZzNi9ZWTlSMzBUS2FmNE5VdHdqZjRFem5ibDhrS3hyVT0iLCJtYWMiOiI3YjE2Yjk5ODM3MmNjNGUwNDdkNWNjYjU4OWZmYTFiNTdmZTg1NTdmYWYxNTEzMGQwYzI2M2UzNjUxMGJjMmYwIiwidGFnIjoiIn0=','terverifikasi'),(2,4,'Siti Rahma','081234567891','eyJpdiI6IjBDcXRNb1VVOERCRVlnVGVEeE53NXc9PSIsInZhbHVlIjoic2pxSEtFYWpodDRvZElQLzE3alZSTHR4OUxzaUgzR1greFgydVJKd1JhZz0iLCJtYWMiOiI0NjYyYWQyM2FhYjk5NTBlZTlhMTBkYjgzOTYwNzZlMzRlNTg4ZDk4YmRjMGQwYjA2MDhkMzY4M2JlOTQ5MmRhIiwidGFnIjoiIn0=','menunggu');
/*!40000 ALTER TABLE `warga` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_warga_insert_role` BEFORE INSERT ON `warga` FOR EACH ROW BEGIN
  IF NOT EXISTS (SELECT 1 FROM `users` WHERE `id_user` = NEW.`id_user` AND `role` = 'warga') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Akun users ber-role warga harus dibuat terlebih dahulu';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_warga_insert_saldo` AFTER INSERT ON `warga` FOR EACH ROW BEGIN
  INSERT INTO `saldo` (`id_warga`, `saldo_terakhir`) VALUES (NEW.`id_warga`, 0);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_warga_update_role` BEFORE UPDATE ON `warga` FOR EACH ROW BEGIN
  IF NOT EXISTS (SELECT 1 FROM `users` WHERE `id_user` = NEW.`id_user` AND `role` = 'warga') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Profil warga harus terhubung ke users dengan role warga';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'trimset'
--

--
-- Dumping routines for database 'trimset'
--

--
-- Current Database: `trimset`
--

USE `trimset`;

--
-- Final view structure for view `v_kategori_aktif`
--

/*!50001 DROP VIEW IF EXISTS `v_kategori_aktif`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`trim_admin`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_kategori_aktif` AS select `k`.`id_kategori` AS `id_kategori`,`k`.`nama_kategori` AS `nama_kategori`,`k`.`harga_per_kg` AS `harga_per_kg` from `kategori_sampah` `k` where (`k`.`status` = 'aktif') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_pencairan_ringkas`
--

/*!50001 DROP VIEW IF EXISTS `v_pencairan_ringkas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`trim_admin`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_pencairan_ringkas` AS select `p`.`id_pencairan` AS `id_pencairan`,`p`.`id_warga` AS `id_warga`,`w`.`nama` AS `nama_warga`,`p`.`tanggal_pengajuan` AS `tanggal_pengajuan`,`p`.`tanggal_pencairan` AS `tanggal_pencairan`,`p`.`jumlah` AS `jumlah`,`p`.`status` AS `status`,`jp`.`tanggal_pencairan` AS `tanggal_jadwal` from ((`pencairan` `p` join `warga` `w` on((`w`.`id_warga` = `p`.`id_warga`))) left join `jadwal_pencairan` `jp` on((`jp`.`id_jadwal_pencairan` = `p`.`id_jadwal_pencairan`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_rekap_kas`
--

/*!50001 DROP VIEW IF EXISTS `v_rekap_kas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`trim_admin`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_rekap_kas` AS select `rekap`.`periode` AS `periode`,sum(`rekap`.`jumlah_transaksi`) AS `jumlah_transaksi`,sum(`rekap`.`pemasukan`) AS `total_pemasukan`,sum(`rekap`.`pengeluaran`) AS `total_pengeluaran`,sum((`rekap`.`pemasukan` - `rekap`.`pengeluaran`)) AS `saldo_bersih` from (select date_format(`t`.`tanggal_transaksi`,'%Y-%m') AS `periode`,count(0) AS `jumlah_transaksi`,coalesce(sum(`t`.`total_nilai`),0) AS `pemasukan`,0 AS `pengeluaran` from `transaksi_penimbangan` `t` where (`t`.`status` = 'sukses') group by date_format(`t`.`tanggal_transaksi`,'%Y-%m') union all select date_format(`p`.`tanggal_pengajuan`,'%Y-%m') AS `periode`,count(0) AS `jumlah_transaksi`,0 AS `pemasukan`,coalesce(sum(`p`.`jumlah`),0) AS `pengeluaran` from `pencairan` `p` where (`p`.`status` = 'selesai') group by date_format(`p`.`tanggal_pengajuan`,'%Y-%m')) `rekap` group by `rekap`.`periode` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_transaksi_ringkas`
--

/*!50001 DROP VIEW IF EXISTS `v_transaksi_ringkas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`trim_admin`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_transaksi_ringkas` AS select `t`.`id_transaksi` AS `id_transaksi`,`t`.`id_antrian` AS `id_antrian`,`w`.`id_warga` AS `id_warga`,`w`.`nama` AS `nama_warga`,`t`.`tanggal_transaksi` AS `tanggal_transaksi`,`t`.`total_berat` AS `total_berat`,`t`.`total_nilai` AS `total_nilai`,`t`.`status` AS `status`,count(`d`.`id_detail`) AS `jumlah_item` from (((`transaksi_penimbangan` `t` join `antrian` `a` on((`a`.`id_antrian` = `t`.`id_antrian`))) join `warga` `w` on((`w`.`id_warga` = `a`.`id_warga`))) left join `detail_transaksi` `d` on((`d`.`id_transaksi` = `t`.`id_transaksi`))) group by `t`.`id_transaksi`,`t`.`id_antrian`,`w`.`id_warga`,`w`.`nama`,`t`.`tanggal_transaksi`,`t`.`total_berat`,`t`.`total_nilai`,`t`.`status` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_warga_publik`
--

/*!50001 DROP VIEW IF EXISTS `v_warga_publik`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`trim_admin`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_warga_publik` AS select `w`.`id_warga` AS `id_warga`,`w`.`nama` AS `nama`,(case when (char_length(`w`.`no_hp`) >= 6) then concat(left(`w`.`no_hp`,4),'****',right(`w`.`no_hp`,2)) else '****' end) AS `no_hp_masked`,`w`.`status_verifikasi` AS `status_verifikasi` from `warga` `w` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-31 20:47:32


-- =====================================================================
-- BAGIAN 3 - GRANT LEAST PRIVILEGE + VIEW READER
-- =====================================================================
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

FLUSH PRIVILEGES;
