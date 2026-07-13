# Render Production Database Migration Guide

## Overview

This guide provides step-by-step instructions for applying the MySQL migration to add invigilator support to the Render production database.

## Root Cause

The `invigilator_id` column was added to the SQLAlchemy `IncidentReport` model but was never migrated to the production MySQL database. This causes SQLAlchemy `OperationalError: (1054, "Unknown column 'incident_reports.invigilator_id' in 'field list'")` when attempting to submit incident reports.

## Migration Details

The migration script (`migrations/mysql_migration.sql`) will:

1. **Add `invigilator_id` column** to `incident_reports` table
   - Foreign key to `exam_invigilators(id)` with ON DELETE SET NULL
   - Index for query performance

2. **Create `exam_invigilators` table** (if not exists)
   - Stores invigilator accounts and profiles
   - Includes roles, status, validity periods, login tracking

3. **Create `invigilator_login_history` table** (if not exists)
   - Tracks all invigilator login attempts
   - Records IP addresses, user agents, failure reasons

4. **Create `incident_report_settings` table** (if not exists)
   - Stores customizable incident report form settings
   - Field visibility, requirements, labels, styling options

5. **Seed default incident report settings**
   - 30 default settings for field visibility, requirements, labels, styling

## Prerequisites

- Render MySQL database access credentials
- MySQL client installed locally OR access to Render MySQL shell
- Database connection details from Render dashboard

## Method 1: Using Render MySQL Shell (Recommended)

### Step 1: Access Render Dashboard

1. Go to your Render dashboard: https://dashboard.render.com
2. Navigate to your MySQL service
3. Click on the "Connect" tab
4. Copy the "External Connection" command

### Step 2: Execute Migration

Run the following command in your terminal:

```bash
mysql -h <your-mysql-host> -u <your-username> -p <your-database> < migrations/mysql_migration.sql
```

Replace the placeholders with your actual Render MySQL credentials from the dashboard.

Example:
```bash
mysql -h dpg-xxxxx.oregon-postgres.render.com -u admin -p exam_system < migrations/mysql_migration.sql
```

### Step 3: Verify Migration

Connect to your database and verify the changes:

```sql
-- Check if invigilator_id column exists
DESCRIBE incident_reports;

-- Verify tables were created
SHOW TABLES LIKE '%invigilator%';
SHOW TABLES LIKE 'incident_report_settings';

-- Check foreign key constraint
SELECT CONSTRAINT_NAME, TABLE_NAME, COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME = 'incident_reports'
AND CONSTRAINT_NAME = 'fk_incident_reports_invigilator_id';
```

## Method 2: Using Render Console

### Step 1: Open MySQL Console

1. In Render dashboard, navigate to your MySQL service
2. Click on the "Console" tab
3. Click "Open Console"

### Step 2: Upload and Execute Migration

Since the Render console doesn't support file uploads directly, you'll need to:

1. Copy the contents of `migrations/mysql_migration.sql`
2. Paste it into the Render MySQL console
3. Execute the script

### Step 3: Verify

Run the verification queries from Method 1, Step 3 in the console.

## Method 3: Using Python Script (Alternative)

Create a Python script to execute the migration:

```python
import pymysql
from dotenv import load_dotenv
import os

load_dotenv()

# Get Render MySQL credentials from environment
db_host = os.environ.get('RENDER_MYSQL_HOST')
db_user = os.environ.get('RENDER_MYSQL_USER')
db_password = os.environ.get('RENDER_MYSQL_PASSWORD')
db_name = os.environ.get('RENDER_MYSQL_DATABASE')

# Read migration script
with open('migrations/mysql_migration.sql', 'r') as f:
    migration_sql = f.read()

# Connect and execute
connection = pymysql.connect(
    host=db_host,
    user=db_user,
    password=db_password,
    database=db_name
)

try:
    with connection.cursor() as cursor:
        # Split by semicolon and execute each statement
        statements = [s.strip() for s in migration_sql.split(';') if s.strip()]
        for statement in statements:
            if statement:
                cursor.execute(statement)
        connection.commit()
        print("Migration executed successfully!")
except Exception as e:
    connection.rollback()
    print(f"Migration failed: {e}")
finally:
    connection.close()
```

## Post-Migration Verification

### 1. Test Incident Report Submission

After applying the migration:

1. Deploy the updated code to Render (includes CSRF token fixes)
2. Log in as an invigilator
3. Navigate to the incident report form
4. Fill out and submit an incident report
5. Verify the report is saved successfully
6. Check the Admin Incident Management section to confirm the report appears

### 2. Verify Database Schema

Run these queries to verify the migration:

```sql
-- Check incident_reports table structure
DESCRIBE incident_reports;

-- Verify invigilator_id column exists
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME = 'incident_reports'
AND COLUMN_NAME = 'invigilator_id';

-- Verify exam_invigilators table exists
SELECT COUNT(*) FROM information_schema.TABLES
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME = 'exam_invigilators';

-- Verify incident_report_settings table exists and has data
SELECT COUNT(*) FROM incident_report_settings;
```

### 3. Test Invigilator Login

1. Create a test invigilator account via Admin panel
2. Attempt to log in at `/invigilator/login`
3. Verify login succeeds (no HTTP 400 CSRF error)
4. Verify session is established correctly

## Troubleshooting

### Error: "Column invigilator_id already exists"

The migration script is idempotent and will skip adding the column if it already exists. This is normal and not an error.

### Error: "Foreign key constraint fails"

This error occurs if the `exam_invigilators` table doesn't exist when trying to add the foreign key. The migration script creates tables in the correct order, so this shouldn't happen. If it does, ensure the entire script is executed in order.

### Error: "Access denied for user"

Verify your MySQL credentials are correct and the user has the necessary permissions (ALTER, CREATE, INSERT).

### Error: "Unknown database"

Verify the database name in your connection string matches the actual database name in Render.

## Rollback (If Needed)

If you need to rollback the migration:

```sql
-- Remove foreign key constraint
ALTER TABLE incident_reports DROP FOREIGN KEY fk_incident_reports_invigilator_id;

-- Remove index
ALTER TABLE incident_reports DROP INDEX idx_incident_reports_invigilator_id;

-- Remove column
ALTER TABLE incident_reports DROP COLUMN invigilator_id;

-- Drop tables (if needed)
DROP TABLE IF EXISTS invigilator_login_history;
DROP TABLE IF EXISTS exam_invigilators;
DROP TABLE IF EXISTS incident_report_settings;
```

## Additional Files Modified

The following code changes were made to fix related issues:

1. **app/routes_public.py** - Added `flash` import (line 3)
2. **app/templates/invigilator/login.html** - Added CSRF token (line 165)
3. **app/templates/invigilator/change_password.html** - Added CSRF token (line 166)

These changes must be deployed to Render along with the database migration.

## Expected Results After Migration

- ✅ Incident Report form submits successfully
- ✅ Reports are saved with `invigilator_id` populated
- ✅ No 500 Internal Server Error on submission
- ✅ No SQLAlchemy OperationalError
- ✅ Reports appear in Admin Incident Management immediately
- ✅ Invigilator login works without HTTP 400 errors
- ✅ CSRF protection is properly enforced

## Support

If you encounter issues during the migration:

1. Check Render MySQL service logs
2. Verify your database credentials
3. Ensure the migration script is executed completely
4. Check for any existing data conflicts
5. Review the error messages carefully for specific issues
