"""Migration to add missing columns to exams table"""
import sqlite3
import os

db_path = os.path.join(os.path.dirname(__file__), '..', 'instance', 'visual_review.db')

conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# Check current schema
cursor.execute("PRAGMA table_info(exams)")
columns = [col[1] for col in cursor.fetchall()]

# Add missing columns
migrations = [
    ("short_code", "VARCHAR(20)"),
    ("weight_percentage", "FLOAT DEFAULT 0.0"),
    ("sort_order", "INTEGER DEFAULT 0"),
    ("is_active", "BOOLEAN DEFAULT 1"),
]

for col_name, col_type in migrations:
    if col_name not in columns:
        print(f"Adding column: {col_name}")
        cursor.execute(f"ALTER TABLE exams ADD COLUMN {col_name} {col_type}")
    else:
        print(f"Column already exists: {col_name}")

conn.commit()
conn.close()

print("Migration completed successfully!")
