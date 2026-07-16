"""Script to check database schema and compare with models"""
import sqlite3
import os

db_path = os.path.join(os.path.dirname(__file__), 'instance', 'visual_review.db')

conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# Get the schema of exams table
cursor.execute("PRAGMA table_info(exams)")
columns = cursor.fetchall()

print("Current exams table schema:")
print("-" * 60)
for col in columns:
    print(f"  {col[1]}: {col[2]} {'(PK)' if col[5] else ''}")

print("\n" + "=" * 60)
print("Expected columns from model:")
print("-" * 60)
expected_columns = [
    "id", "name", "short_code", "academic_year_id",
    "weight_percentage", "sort_order", "is_active",
    "academic_level_id", "academic_class_id", "academic_section_id",
    "is_published", "created_at", "updated_at"
]
for col in expected_columns:
    print(f"  {col}")

print("\n" + "=" * 60)
print("Missing columns:")
print("-" * 60)
current_cols = [col[1] for col in columns]
missing = [col for col in expected_columns if col not in current_cols]
if missing:
    for col in missing:
        print(f"  {col}")
else:
    print("  None")

conn.close()
