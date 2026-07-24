"""Migration script to add missing columns to existing database"""
import sqlite3
import os

db_path = os.path.join(os.path.dirname(__file__), 'instance', 'visual_review.db')

conn = sqlite3.connect(db_path)
cursor = conn.cursor()

print("Starting database migration...")
print("=" * 60)

# Check if invigilator_id column exists in incident_reports
cursor.execute("PRAGMA table_info(incident_reports)")
columns = cursor.fetchall()
column_names = [col[1] for col in columns]

if 'invigilator_id' not in column_names:
    print("Adding invigilator_id column to incident_reports...")
    cursor.execute("""
        ALTER TABLE incident_reports 
        ADD COLUMN invigilator_id INTEGER 
        REFERENCES exam_invigilators(id) ON DELETE SET NULL
    """)
    print("[OK] invigilator_id column added")
else:
    print("[OK] invigilator_id column already exists")

if 'category_description' not in column_names:
    print("Adding category_description column to incident_reports...")
    cursor.execute("ALTER TABLE incident_reports ADD COLUMN category_description VARCHAR(500)")
    print("[OK] category_description column added")
else:
    print("[OK] category_description column already exists")

if 'action_description' not in column_names:
    print("Adding action_description column to incident_reports...")
    cursor.execute("ALTER TABLE incident_reports ADD COLUMN action_description VARCHAR(500)")
    print("[OK] action_description column added")
else:
    print("[OK] action_description column already exists")

# Check if exam_invigilators table exists
cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='exam_invigilators'")
if not cursor.fetchone():
    print("Creating exam_invigilators table...")
    cursor.execute("""
        CREATE TABLE exam_invigilators (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            invigilator_id VARCHAR(50) UNIQUE NOT NULL,
            username VARCHAR(80) UNIQUE NOT NULL,
            password_hash VARCHAR(255) NOT NULL,
            full_name VARCHAR(180) NOT NULL,
            photo_path VARCHAR(255),
            mobile_number VARCHAR(40),
            role VARCHAR(50) DEFAULT 'Invigilator' NOT NULL,
            school VARCHAR(180),
            notes TEXT,
            status VARCHAR(50) DEFAULT 'Active' NOT NULL,
            is_active BOOLEAN DEFAULT 1 NOT NULL,
            force_password_change BOOLEAN DEFAULT 0 NOT NULL,
            active_from DATE,
            active_until DATE,
            last_login_at DATETIME,
            last_logout_at DATETIME,
            failed_login_attempts INTEGER DEFAULT 0,
            locked_until DATETIME,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )
    """)
    print("[OK] exam_invigilators table created")
else:
    print("[OK] exam_invigilators table already exists")

# Check if invigilator_login_history table exists
cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='invigilator_login_history'")
if not cursor.fetchone():
    print("Creating invigilator_login_history table...")
    cursor.execute("""
        CREATE TABLE invigilator_login_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            invigilator_id INTEGER NOT NULL,
            login_time DATETIME NOT NULL,
            ip_address VARCHAR(45),
            user_agent VARCHAR(255),
            login_status VARCHAR(50) DEFAULT 'Success' NOT NULL,
            failure_reason VARCHAR(255),
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (invigilator_id) REFERENCES exam_invigilators(id) ON DELETE CASCADE
        )
    """)
    print("[OK] invigilator_login_history table created")
else:
    print("[OK] invigilator_login_history table already exists")

# Check if incident_report_settings table exists
cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='incident_report_settings'")
if not cursor.fetchone():
    print("Creating incident_report_settings table...")
    cursor.execute("""
        CREATE TABLE incident_report_settings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            setting_key VARCHAR(100) UNIQUE NOT NULL,
            setting_value TEXT,
            setting_type VARCHAR(50) DEFAULT 'string' NOT NULL,
            category VARCHAR(50) DEFAULT 'general',
            description VARCHAR(255),
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )
    """)
    print("[OK] incident_report_settings table created")
else:
    print("[OK] incident_report_settings table already exists")

# Create indexes for better performance
print("\nCreating indexes...")
try:
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_incident_reports_invigilator_id ON incident_reports(invigilator_id)")
    print("[OK] Index on incident_reports.invigilator_id created")
except Exception as e:
    print(f"  Index creation warning: {e}")

try:
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_exam_invigilators_status ON exam_invigilators(status)")
    print("[OK] Index on exam_invigilators.status created")
except Exception as e:
    print(f"  Index creation warning: {e}")

try:
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_invigilator_login_history_invigilator_id ON invigilator_login_history(invigilator_id)")
    print("[OK] Index on invigilator_login_history.invigilator_id created")
except Exception as e:
    print(f"  Index creation warning: {e}")

try:
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_incident_report_settings_category ON incident_report_settings(category)")
    print("[OK] Index on incident_report_settings.category created")
except Exception as e:
    print(f"  Index creation warning: {e}")

conn.commit()
conn.close()

print("\n" + "=" * 60)
print("Migration completed successfully!")
print("=" * 60)
