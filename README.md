# Online Exam Result Management System

This is a full-stack Flask/MySQL rebuild of the legacy static result page. The public portal only accepts a Student ID and reads the published result from MySQL. The admin dashboard manages students, results, classes, subjects, exams, academic years, users, settings, grade scales, Excel import/export, publishing, uploaded photos, and printable one-page A4 report cards.

## Structure

```text
exam_system/
  app/
    models.py              # SQLAlchemy MySQL models
    routes_public.py       # Student portal and JSON API
    routes_admin.py        # Admin dashboard and CRUD
    routes_auth.py         # Login/logout/passwords
    templates/             # Public/admin/report templates
    static/                # CSS, JS, uploads
  database/
    schema.sql             # Tables
    default_data.sql       # Settings, grades, default admin
    legacy_seed.sql        # Data migrated from legacy sample.html
    install.sql            # Complete import file
  scripts/
    extract_legacy_seed.mjs
```

## Requirements

- Python 3.11+
- MySQL 8+
- Node.js only if you want to regenerate `legacy_seed.sql`

## Installation

1. Create a MySQL database/user.

```sql
CREATE DATABASE exam_results CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'exam_user'@'%' IDENTIFIED BY 'exam_password';
GRANT ALL PRIVILEGES ON exam_results.* TO 'exam_user'@'%';
FLUSH PRIVILEGES;
```

2. Install Python dependencies.

```bash
cd exam_system
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

3. Configure environment.

```bash
copy .env.example .env
```

Edit `.env` and set `SECRET_KEY` plus your MySQL `DATABASE_URL`.

4. Import the complete SQL file.

```bash
mysql -u exam_user -p exam_results < database/install.sql
```

Alternative after creating the database: run `flask init-db` to create empty tables/default settings, then import `database/legacy_seed.sql` if needed.

5. Start the app.

```bash
flask run
```

Public portal: `http://127.0.0.1:5000/`

Admin panel: `http://127.0.0.1:5000/admin/login`

Default login: `admin` / `Admin@12345`

Change this password immediately after first login.

## Excel Formats

Student import requires `.xlsx` columns:

```text
student_id, full_name, mother_name, class, academic_year
```

Result import requires the first column to be `student_id`; every other column name is treated as a subject and imported as that subject score for the selected exam.

```text
student_id, Math, English, Somali, Arabic
```

## API

```http
GET /api/results/<student_id>
```

Returns student, exam, subject scores, total, average, status, and grade for the latest published exam in that student's academic year.

## Deployment Notes

For Render or a VPS:

- Set `DATABASE_URL` to a managed MySQL connection string.
- Set a long random `SECRET_KEY`.
- Use `gunicorn run:app`.
- Persist `app/static/uploads` on durable storage if student photos/logos must survive redeploys.
- Serve behind HTTPS so secure session cookies and admin login are protected in transit.

Example start command:

```bash
gunicorn run:app --bind 0.0.0.0:$PORT
```
