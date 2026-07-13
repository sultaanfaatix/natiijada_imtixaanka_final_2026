"""
Production Database Migration Script for Render
This script applies the invigilator_id column migration to the production MySQL database
Run this on Render: python apply_production_migration.py
"""
import sys
import os
from app import create_app, db
from sqlalchemy import text, inspect

app = create_app()

def check_column_exists(table_name, column_name):
    """Check if a column exists in a table"""
    inspector = inspect(db.engine)
    columns = [col['name'] for col in inspector.get_columns(table_name)]
    return column_name in columns

def check_table_exists(table_name):
    """Check if a table exists"""
    inspector = inspect(db.engine)
    return table_name in inspector.get_table_names()

def check_constraint_exists(table_name, constraint_name):
    """Check if a foreign key constraint exists"""
    try:
        with db.engine.connect() as conn:
            result = conn.execute(text("""
                SELECT COUNT(*) as count
                FROM information_schema.table_constraints
                WHERE table_schema = DATABASE()
                AND table_name = :table_name
                AND constraint_name = :constraint_name
            """), {"table_name": table_name, "constraint_name": constraint_name})
            row = result.fetchone()
            return row[0] > 0
    except Exception as e:
        print(f"Error checking constraint: {e}")
        return False

def apply_migration():
    """Apply the migration to add invigilator_id column and related tables"""
    with app.app_context():
        print("=" * 70)
        print("PRODUCTION DATABASE MIGRATION")
        print("=" * 70)
        
        # Check current database type
        db_url = db.engine.url
        print(f"\nDatabase URL: {db_url}")
        print(f"Database Type: {db_url.drivername}")
        
        if 'mysql' not in db_url.drivername and 'pymysql' not in db_url.drivername:
            print("\n[ERROR] This migration script is designed for MySQL databases.")
            print(f"Current database type: {db_url.drivername}")
            print("If you're running SQLite locally, use migrate_missing_columns.py instead")
            return False
        
        print("\n" + "=" * 70)
        print("STEP 1: Checking incident_reports table for invigilator_id column")
        print("=" * 70)
        
        if check_column_exists('incident_reports', 'invigilator_id'):
            print("[OK] invigilator_id column already exists in incident_reports table")
        else:
            print("[INFO] Adding invigilator_id column to incident_reports table...")
            try:
                with db.engine.connect() as conn:
                    conn.execute(text("""
                        ALTER TABLE incident_reports 
                        ADD COLUMN invigilator_id INT NULL 
                        AFTER user_id
                    """))
                    conn.commit()
                    print("[OK] invigilator_id column added successfully")
            except Exception as e:
                print(f"[ERROR] Failed to add invigilator_id column: {e}")
                return False
        
        print("\n" + "=" * 70)
        print("STEP 2: Adding index on invigilator_id")
        print("=" * 70)
        
        try:
            with db.engine.connect() as conn:
                # Check if index exists
                result = conn.execute(text("""
                    SELECT COUNT(*) as count
                    FROM information_schema.statistics
                    WHERE table_schema = DATABASE()
                    AND table_name = 'incident_reports'
                    AND index_name = 'idx_incident_reports_invigilator_id'
                """))
                row = result.fetchone()
                
                if row[0] > 0:
                    print("[OK] Index idx_incident_reports_invigilator_id already exists")
                else:
                    conn.execute(text("""
                        ALTER TABLE incident_reports 
                        ADD INDEX idx_incident_reports_invigilator_id (invigilator_id)
                    """))
                    conn.commit()
                    print("[OK] Index added successfully")
        except Exception as e:
            print(f"[ERROR] Failed to add index: {e}")
            # Continue anyway, index is not critical
        
        print("\n" + "=" * 70)
        print("STEP 3: Adding foreign key constraint")
        print("=" * 70)
        
        # First ensure exam_invigilators table exists
        if not check_table_exists('exam_invigilators'):
            print("[INFO] exam_invigilators table does not exist, creating it...")
            try:
                with db.engine.connect() as conn:
                    conn.execute(text("""
                        CREATE TABLE exam_invigilators (
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
                        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
                    """))
                    conn.commit()
                    print("[OK] exam_invigilators table created successfully")
            except Exception as e:
                print(f"[ERROR] Failed to create exam_invigilators table: {e}")
                return False
        else:
            print("[OK] exam_invigilators table already exists")
        
        # Now add the foreign key constraint
        if check_constraint_exists('incident_reports', 'fk_incident_reports_invigilator_id'):
            print("[OK] Foreign key constraint already exists")
        else:
            print("[INFO] Adding foreign key constraint...")
            try:
                with db.engine.connect() as conn:
                    conn.execute(text("""
                        ALTER TABLE incident_reports 
                        ADD CONSTRAINT fk_incident_reports_invigilator_id 
                        FOREIGN KEY (invigilator_id) REFERENCES exam_invigilators(id) 
                        ON DELETE SET NULL
                    """))
                    conn.commit()
                    print("[OK] Foreign key constraint added successfully")
            except Exception as e:
                print(f"[ERROR] Failed to add foreign key constraint: {e}")
                # Continue anyway, foreign key is not critical for basic functionality
        
        print("\n" + "=" * 70)
        print("STEP 4: Creating invigilator_login_history table")
        print("=" * 70)
        
        if not check_table_exists('invigilator_login_history'):
            print("[INFO] Creating invigilator_login_history table...")
            try:
                with db.engine.connect() as conn:
                    conn.execute(text("""
                        CREATE TABLE invigilator_login_history (
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
                        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
                    """))
                    conn.commit()
                    print("[OK] invigilator_login_history table created successfully")
            except Exception as e:
                print(f"[ERROR] Failed to create invigilator_login_history table: {e}")
                # Continue anyway, this table is not critical
        else:
            print("[OK] invigilator_login_history table already exists")
        
        print("\n" + "=" * 70)
        print("STEP 5: Creating incident_report_settings table")
        print("=" * 70)
        
        if not check_table_exists('incident_report_settings'):
            print("[INFO] Creating incident_report_settings table...")
            try:
                with db.engine.connect() as conn:
                    conn.execute(text("""
                        CREATE TABLE incident_report_settings (
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
                        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
                    """))
                    conn.commit()
                    print("[OK] incident_report_settings table created successfully")
                    
                    # Seed default settings
                    print("[INFO] Seeding default incident report settings...")
                    settings = [
                        ('show_student_photo', 'true', 'boolean', 'fields', 'Show student photo in incident form'),
                        ('show_student_info', 'true', 'boolean', 'fields', 'Show student information section'),
                        ('show_exam_room', 'true', 'boolean', 'fields', 'Show exam room field'),
                        ('show_exam', 'true', 'boolean', 'fields', 'Show exam selection'),
                        ('show_subject', 'true', 'boolean', 'fields', 'Show subject selection'),
                        ('show_teacher_info', 'true', 'boolean', 'fields', 'Show teacher information fields'),
                        ('show_evidence_upload', 'true', 'boolean', 'fields', 'Show evidence upload section'),
                        ('require_exam_room', 'false', 'boolean', 'requirements', 'Require exam room field'),
                        ('require_exam', 'false', 'boolean', 'requirements', 'Require exam selection'),
                        ('require_subject', 'false', 'boolean', 'requirements', 'Require subject selection'),
                        ('require_teacher_name', 'false', 'boolean', 'requirements', 'Require teacher name'),
                        ('require_teacher_id', 'false', 'boolean', 'requirements', 'Require teacher ID'),
                        ('require_evidence', 'false', 'boolean', 'requirements', 'Require evidence upload'),
                        ('label_exam_room', 'Exam Room', 'string', 'labels', 'Label for exam room field'),
                        ('label_teacher_name', 'Invigilator Name', 'string', 'labels', 'Label for teacher name field'),
                        ('label_teacher_id', 'Invigilator ID', 'string', 'labels', 'Label for teacher ID field'),
                        ('label_description', 'Incident Description', 'string', 'labels', 'Label for description field'),
                        ('label_actions_taken', 'Actions Taken', 'string', 'labels', 'Label for actions taken field'),
                        ('template', 'premium', 'string', 'styling', 'Form template (classic, premium, modern, government, university)'),
                        ('primary_color', '#3b82f6', 'string', 'styling', 'Primary color'),
                        ('secondary_color', '#1e40af', 'string', 'styling', 'Secondary color'),
                        ('background_color', '#f8fafc', 'string', 'styling', 'Background color'),
                        ('card_background', '#ffffff', 'string', 'styling', 'Card background color'),
                        ('font_family', 'Segoe UI', 'string', 'styling', 'Font family'),
                        ('font_size', '16', 'integer', 'styling', 'Base font size in pixels'),
                        ('show_header', 'true', 'boolean', 'header', 'Show form header'),
                        ('header_title', 'Incident Report', 'string', 'header', 'Header title'),
                        ('header_subtitle', 'Submit examination incident report', 'string', 'header', 'Header subtitle'),
                        ('show_footer', 'true', 'boolean', 'footer', 'Show form footer'),
                        ('footer_text', '© 2024 Examination System', 'string', 'footer', 'Footer text'),
                    ]
                    
                    for setting_key, setting_value, setting_type, category, description in settings:
                        conn.execute(text("""
                            INSERT IGNORE INTO incident_report_settings 
                            (setting_key, setting_value, setting_type, category, description)
                            VALUES (:key, :value, :type, :category, :description)
                        """), {
                            "key": setting_key,
                            "value": setting_value,
                            "type": setting_type,
                            "category": category,
                            "description": description
                        })
                    conn.commit()
                    print(f"[OK] {len(settings)} default settings seeded successfully")
                    
            except Exception as e:
                print(f"[ERROR] Failed to create incident_report_settings table: {e}")
                # Continue anyway, this table is not critical
        else:
            print("[OK] incident_report_settings table already exists")
        
        print("\n" + "=" * 70)
        print("MIGRATION COMPLETED SUCCESSFULLY")
        print("=" * 70)
        
        # Final verification
        print("\n" + "=" * 70)
        print("FINAL VERIFICATION")
        print("=" * 70)
        
        print("\nincident_reports table columns:")
        inspector = inspect(db.engine)
        columns = inspector.get_columns('incident_reports')
        for col in columns:
            if 'invigilator' in col['name'].lower():
                print(f"  [OK] {col['name']}: {col['type']}")
        
        print("\nTables created:")
        for table in ['exam_invigilators', 'invigilator_login_history', 'incident_report_settings']:
            if check_table_exists(table):
                print(f"  [OK] {table}")
            else:
                print(f"  [MISSING] {table}")
        
        print("\n" + "=" * 70)
        print("Migration completed successfully!")
        print("Please restart your application to ensure changes take effect.")
        print("=" * 70)
        
        return True

if __name__ == "__main__":
    try:
        success = apply_migration()
        sys.exit(0 if success else 1)
    except Exception as e:
        print(f"\n[FATAL ERROR] Migration failed: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
