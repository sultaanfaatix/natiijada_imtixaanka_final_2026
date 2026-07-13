-- MySQL Migration Script for Exam Invigilator System
-- Run this script on your production MySQL database to add invigilator support
-- Execute: mysql -h <host> -u <user> -p <database> < migrations/mysql_migration.sql

-- Add invigilator_id column to incident_reports table
-- Use ALTER TABLE with IF NOT EXISTS pattern for safety
SET @column_exists = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
    AND table_name = 'incident_reports'
    AND column_name = 'invigilator_id'
);

SET @sql = IF(@column_exists = 0,
    'ALTER TABLE incident_reports ADD COLUMN invigilator_id INT NULL AFTER user_id',
    'SELECT "Column invigilator_id already exists" AS message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add index if it doesn't exist
SET @index_exists = (
    SELECT COUNT(*)
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
    AND table_name = 'incident_reports'
    AND index_name = 'idx_incident_reports_invigilator_id'
);

SET @sql = IF(@index_exists = 0,
    'ALTER TABLE incident_reports ADD INDEX idx_incident_reports_invigilator_id (invigilator_id)',
    'SELECT "Index idx_incident_reports_invigilator_id already exists" AS message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add foreign key constraint if it doesn't exist
SET @fk_exists = (
    SELECT COUNT(*)
    FROM information_schema.table_constraints
    WHERE table_schema = DATABASE()
    AND table_name = 'incident_reports'
    AND constraint_name = 'fk_incident_reports_invigilator_id'
);

SET @sql = IF(@fk_exists = 0,
    'ALTER TABLE incident_reports ADD CONSTRAINT fk_incident_reports_invigilator_id FOREIGN KEY (invigilator_id) REFERENCES exam_invigilators(id) ON DELETE SET NULL',
    'SELECT "Foreign key fk_incident_reports_invigilator_id already exists" AS message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Create exam_invigilators table
CREATE TABLE IF NOT EXISTS exam_invigilators (
    id INT AUTO_INCREMENT PRIMARY KEY,
    invigilator_id VARCHAR(50) UNIQUE NOT NULL,
    username VARCHAR(80) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(180) NOT NULL,
    photo_path VARCHAR(255),
    mobile_number VARCHAR(40),
    role ENUM('Invigilator', 'Supervisor', 'Chief Invigilator', 'Administrator') DEFAULT 'Invigilator' NOT NULL,
    school VARCHAR(180),
    notes TEXT,
    status ENUM('Active', 'Inactive', 'Locked') DEFAULT 'Active' NOT NULL,
    is_active TINYINT(1) DEFAULT 1 NOT NULL,
    force_password_change TINYINT(1) DEFAULT 0 NOT NULL,
    active_from DATE,
    active_until DATE,
    last_login_at DATETIME,
    last_logout_at DATETIME,
    failed_login_attempts INT DEFAULT 0,
    locked_until DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_exam_invigilators_invigilator_id (invigilator_id),
    INDEX idx_exam_invigilators_username (username),
    INDEX idx_exam_invigilators_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create invigilator_login_history table
CREATE TABLE IF NOT EXISTS invigilator_login_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    invigilator_id INT NOT NULL,
    login_time DATETIME NOT NULL,
    ip_address VARCHAR(45),
    user_agent VARCHAR(255),
    login_status ENUM('Success', 'Failed', 'Locked', 'Expired') DEFAULT 'Success' NOT NULL,
    failure_reason VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_invigilator_login_history_invigilator_id (invigilator_id),
    INDEX idx_invigilator_login_history_login_time (login_time),
    CONSTRAINT fk_invigilator_login_history_invigilator_id 
    FOREIGN KEY (invigilator_id) REFERENCES exam_invigilators(id) 
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create incident_report_settings table
CREATE TABLE IF NOT EXISTS incident_report_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT,
    setting_type ENUM('boolean', 'string', 'integer', 'json') DEFAULT 'string' NOT NULL,
    category VARCHAR(50) DEFAULT 'general',
    description VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_incident_report_settings_setting_key (setting_key),
    INDEX idx_incident_report_settings_category (category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Seed default incident report settings
INSERT IGNORE INTO incident_report_settings (setting_key, setting_value, setting_type, category, description) VALUES
-- Field visibility settings
('show_student_photo', 'true', 'boolean', 'fields', 'Show student photo in incident form'),
('show_student_info', 'true', 'boolean', 'fields', 'Show student information section'),
('show_exam_room', 'true', 'boolean', 'fields', 'Show exam room field'),
('show_exam', 'true', 'boolean', 'fields', 'Show exam selection'),
('show_subject', 'true', 'boolean', 'fields', 'Show subject selection'),
('show_teacher_info', 'true', 'boolean', 'fields', 'Show teacher information fields'),
('show_evidence_upload', 'true', 'boolean', 'fields', 'Show evidence upload section'),

-- Field requirement settings
('require_exam_room', 'false', 'boolean', 'requirements', 'Require exam room field'),
('require_exam', 'false', 'boolean', 'requirements', 'Require exam selection'),
('require_subject', 'false', 'boolean', 'requirements', 'Require subject selection'),
('require_teacher_name', 'false', 'boolean', 'requirements', 'Require teacher name'),
('require_teacher_id', 'false', 'boolean', 'requirements', 'Require teacher ID'),
('require_evidence', 'false', 'boolean', 'requirements', 'Require evidence upload'),

-- Custom labels
('label_exam_room', 'Exam Room', 'string', 'labels', 'Label for exam room field'),
('label_teacher_name', 'Invigilator Name', 'string', 'labels', 'Label for teacher name field'),
('label_teacher_id', 'Invigilator ID', 'string', 'labels', 'Label for teacher ID field'),
('label_description', 'Incident Description', 'string', 'labels', 'Label for description field'),
('label_actions_taken', 'Actions Taken', 'string', 'labels', 'Label for actions taken field'),

-- Styling settings
('template', 'premium', 'string', 'styling', 'Form template (classic, premium, modern, government, university)'),
('primary_color', '#3b82f6', 'string', 'styling', 'Primary color'),
('secondary_color', '#1e40af', 'string', 'styling', 'Secondary color'),
('background_color', '#f8fafc', 'string', 'styling', 'Background color'),
('card_background', '#ffffff', 'string', 'styling', 'Card background color'),
('font_family', 'Segoe UI', 'string', 'styling', 'Font family'),
('font_size', '16', 'integer', 'styling', 'Base font size in pixels'),

-- Header settings
('show_header', 'true', 'boolean', 'header', 'Show form header'),
('header_title', 'Incident Report', 'string', 'header', 'Header title'),
('header_subtitle', 'Submit examination incident report', 'string', 'header', 'Header subtitle'),

-- Footer settings
('show_footer', 'true', 'boolean', 'footer', 'Show form footer'),
('footer_text', '© 2024 Examination System', 'string', 'footer', 'Footer text');
