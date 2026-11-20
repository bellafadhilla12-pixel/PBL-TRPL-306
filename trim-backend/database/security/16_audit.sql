-- =====================================================================
-- 16_audit.sql
-- Tabel audit trail aplikasi.
-- Jalankan sebagai trim_admin (atau root) sebelum mengaktifkan observer.
-- =====================================================================

USE trimset;

CREATE TABLE IF NOT EXISTS audit_log (
    id_audit BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    actor_user_id INT NULL,
    actor_role VARCHAR(20) NULL,
    action VARCHAR(100) NOT NULL,
    object_type VARCHAR(100) NOT NULL,
    object_id VARCHAR(100) NULL,
    old_values JSON NULL,
    new_values JSON NULL,
    result VARCHAR(20) NOT NULL DEFAULT 'success',
    http_method VARCHAR(10) NULL,
    http_path VARCHAR(255) NULL,
    http_status SMALLINT NULL,
    ip_address VARCHAR(45) NULL,
    user_agent VARCHAR(255) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_audit),
    KEY idx_audit_actor (actor_user_id),
    KEY idx_audit_object (object_type, object_id),
    KEY idx_audit_action (action),
    KEY idx_audit_created (created_at)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- Aplikasi hanya boleh menulis audit; admin yang boleh membacanya.
GRANT INSERT ON trimset.audit_log TO 'trim_app'@'localhost';
