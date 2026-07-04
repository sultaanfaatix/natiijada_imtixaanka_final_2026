from pathlib import Path

from flask import Blueprint, flash, redirect, render_template, request, send_file, url_for
from flask_login import current_user, login_required
from openpyxl import Workbook, load_workbook
from sqlalchemy import or_

from . import db
from .models import AcademicYear, Exam, GradeScale, Result, SchoolClass, Setting, Student, Subject, User
from .security import ALLOWED_PHOTOS, ALLOWED_SHEETS, allowed_file, role_required, safe_upload_name
from .services import get_settings, result_payload

admin_bp = Blueprint("admin", __name__)


@admin_bp.before_request
@login_required
def require_login():
    pass


@admin_bp.route("/")
def dashboard():
    current_year = AcademicYear.query.filter_by(is_current=True).first()
    stats = {
        "students": Student.query.count(),
        "classes": SchoolClass.query.count(),
        "exams": Exam.query.count(),
        "published": Exam.query.filter_by(is_published=True).count(),
        "subjects": Subject.query.count(),
        "locked": Student.query.filter_by(is_result_locked=True).count(),
    }
    latest_results = Result.query.order_by(Result.updated_at.desc()).limit(10).all()
    return render_template("admin/dashboard.html", stats=stats, current_year=current_year, latest_results=latest_results)


@admin_bp.route("/students")
def students():
    q = request.args.get("q", "").strip()
    query = Student.query
    if q:
        query = query.filter(or_(Student.student_code.like(f"%{q}%"), Student.full_name.like(f"%{q}%"), Student.mother_name.like(f"%{q}%")))
    return render_template("admin/students.html", students=query.order_by(Student.full_name).all(), q=q)


@admin_bp.route("/students/new", methods=["GET", "POST"])
@admin_bp.route("/students/<int:student_id>/edit", methods=["GET", "POST"])
def student_form(student_id=None):
    student = db.session.get(Student, student_id) if student_id else Student()
    if request.method == "POST":
        student.student_code = request.form["student_code"].strip()
        student.full_name = request.form["full_name"].strip()
        student.mother_name = request.form.get("mother_name", "").strip()
        student.class_id = int(request.form["class_id"])
        student.academic_year_id = int(request.form["academic_year_id"])
        student.note = request.form.get("note", "").strip()
        student.is_result_locked = bool(request.form.get("is_result_locked"))
        student.lock_reason = request.form.get("lock_reason", "").strip()
        student.is_active = bool(request.form.get("is_active"))
        photo = request.files.get("photo")
        if photo and photo.filename:
            if not allowed_file(photo.filename, ALLOWED_PHOTOS):
                flash("Photo must be JPG, PNG, or WEBP.", "danger")
                return redirect(request.url)
            filename = f"{student.student_code}_{safe_upload_name(photo.filename)}"
            upload_dir = Path(current_app_config("UPLOAD_FOLDER"))
            upload_dir.mkdir(parents=True, exist_ok=True)
            photo.save(upload_dir / filename)
            student.photo_path = f"uploads/{filename}"
        db.session.add(student)
        db.session.commit()
        flash("Student saved successfully.", "success")
        return redirect(url_for("admin.students"))
    return render_template(
        "admin/student_form.html",
        student=student,
        classes=SchoolClass.query.order_by(SchoolClass.name).all(),
        years=AcademicYear.query.order_by(AcademicYear.name.desc()).all(),
    )


@admin_bp.route("/students/<int:student_id>/delete", methods=["POST"])
def delete_student(student_id):
    student = db.session.get(Student, student_id) or abort_404()
    db.session.delete(student)
    db.session.commit()
    flash("Student deleted.", "success")
    return redirect(url_for("admin.students"))


@admin_bp.route("/students/<int:student_id>/toggle-lock", methods=["POST"])
def toggle_student_lock(student_id):
    student = db.session.get(Student, student_id) or abort_404()
    student.is_result_locked = not student.is_result_locked
    if student.is_result_locked:
        student.lock_reason = request.form.get("lock_reason", "").strip() or "Outstanding clearance required."
    else:
        student.lock_reason = ""
    db.session.commit()
    flash("Result lock status updated.", "success")
    return redirect(url_for("admin.students"))


@admin_bp.route("/students/import", methods=["POST"])
def import_students():
    file = request.files.get("file")
    if not file or not allowed_file(file.filename, ALLOWED_SHEETS):
        flash("Upload an .xlsx file.", "danger")
        return redirect(url_for("admin.students"))
    wb = load_workbook(file, data_only=True)
    ws = wb.active
    headers = [str(c.value).strip().lower() for c in ws[1]]
    required = ["student_id", "full_name", "mother_name", "class", "academic_year"]
    if any(col not in headers for col in required):
        flash("Excel columns required: student_id, full_name, mother_name, class, academic_year.", "danger")
        return redirect(url_for("admin.students"))
    added = 0
    for row in ws.iter_rows(min_row=2, values_only=True):
        data = dict(zip(headers, row))
        if not data.get("student_id"):
            continue
        school_class = get_or_create(SchoolClass, name=str(data["class"]).strip())
        year = get_or_create(AcademicYear, name=str(data["academic_year"]).strip())
        student = Student.query.filter_by(student_code=str(data["student_id"]).strip()).first() or Student()
        student.student_code = str(data["student_id"]).strip()
        student.full_name = str(data.get("full_name") or "").strip()
        student.mother_name = str(data.get("mother_name") or "").strip()
        student.school_class = school_class
        student.academic_year = year
        student.is_active = True
        db.session.add(student)
        added += 1
    db.session.commit()
    flash(f"Imported {added} students.", "success")
    return redirect(url_for("admin.students"))


@admin_bp.route("/students/export")
def export_students():
    wb = Workbook()
    ws = wb.active
    ws.title = "Students"
    ws.append(["student_id", "full_name", "mother_name", "class", "academic_year", "active"])
    for s in Student.query.order_by(Student.full_name).all():
        ws.append([s.student_code, s.full_name, s.mother_name, s.school_class.name, s.academic_year.name, s.is_active])
    return workbook_response(wb, "students.xlsx")


@admin_bp.route("/results")
def results():
    students = Student.query.order_by(Student.full_name).all()
    exams = Exam.query.order_by(Exam.id.desc()).all()
    subjects = Subject.query.order_by(Subject.sort_order, Subject.name).all()
    rows = Result.query.join(Result.student).order_by(Result.updated_at.desc()).limit(200).all()
    return render_template("admin/results.html", students=students, exams=exams, subjects=subjects, rows=rows)


@admin_bp.route("/results/save", methods=["POST"])
def save_results():
    student = db.session.get(Student, int(request.form["student_id"])) or abort_404()
    exam = db.session.get(Exam, int(request.form["exam_id"])) or abort_404()
    for subject in Subject.query.order_by(Subject.sort_order, Subject.name).all():
        raw = request.form.get(f"subject_{subject.id}", "").strip()
        if raw == "":
            continue
        score = max(0, min(float(raw), float(subject.max_score)))
        result = Result.query.filter_by(student_id=student.id, exam_id=exam.id, subject_id=subject.id).first() or Result(
            student=student, exam=exam, subject=subject
        )
        result.score = score
        result.is_published = bool(request.form.get("is_published"))
        db.session.add(result)
    db.session.commit()
    flash("Results saved.", "success")
    return redirect(url_for("admin.results"))


@admin_bp.route("/results/<int:result_id>/delete", methods=["POST"])
def delete_result(result_id):
    result = db.session.get(Result, result_id) or abort_404()
    db.session.delete(result)
    db.session.commit()
    flash("Result row deleted.", "success")
    return redirect(url_for("admin.results"))


@admin_bp.route("/results/import", methods=["POST"])
def import_results():
    file = request.files.get("file")
    exam_id = request.form.get("exam_id")
    if not file or not allowed_file(file.filename, ALLOWED_SHEETS) or not exam_id:
        flash("Choose an exam and upload an .xlsx file.", "danger")
        return redirect(url_for("admin.results"))
    exam = db.session.get(Exam, int(exam_id)) or abort_404()
    wb = load_workbook(file, data_only=True)
    ws = wb.active
    headers = [str(c.value).strip() for c in ws[1]]
    subject_names = headers[1:]
    imported = 0
    for row in ws.iter_rows(min_row=2, values_only=True):
        student = Student.query.filter_by(student_code=str(row[0]).strip()).first()
        if not student:
            continue
        for subject_name, score in zip(subject_names, row[1:]):
            if score is None:
                continue
            subject = get_or_create(Subject, name=subject_name.strip())
            result = Result.query.filter_by(student_id=student.id, exam_id=exam.id, subject_id=subject.id).first() or Result(
                student=student, exam=exam, subject=subject
            )
            result.score = float(score)
            result.is_published = True
            db.session.add(result)
        imported += 1
    db.session.commit()
    flash(f"Imported results for {imported} students.", "success")
    return redirect(url_for("admin.results"))


@admin_bp.route("/results/export")
def export_results():
    wb = Workbook()
    ws = wb.active
    ws.title = "Results"
    ws.append(["student_id", "student_name", "exam", "subject", "score", "published"])
    for r in Result.query.join(Result.student).order_by(Student.full_name).all():
        ws.append([r.student.student_code, r.student.full_name, r.exam.name, r.subject.name, float(r.score), r.is_published])
    return workbook_response(wb, "results.xlsx")


@admin_bp.route("/reports/<int:student_id>/<int:exam_id>")
def admin_print_report(student_id, exam_id):
    student = db.session.get(Student, student_id) or abort_404()
    exam = db.session.get(Exam, exam_id) or abort_404()
    return render_template("print_report.html", result=result_payload(student, exam=exam, public_only=False))


@admin_bp.route("/classes", methods=["GET", "POST"])
def classes():
    return simple_crud(SchoolClass, "classes", ["name", "description"])


@admin_bp.route("/subjects", methods=["GET", "POST"])
def subjects():
    return simple_crud(Subject, "subjects", ["name", "max_score", "sort_order"])


@admin_bp.route("/exams", methods=["GET", "POST"])
def exams():
    if request.method == "POST":
        exam = db.session.get(Exam, int(request.form.get("id") or 0)) or Exam()
        exam.name = request.form["name"].strip()
        exam.academic_year_id = int(request.form["academic_year_id"])
        exam.is_published = bool(request.form.get("is_published"))
        db.session.add(exam)
        db.session.commit()
        flash("Exam saved.", "success")
        return redirect(url_for("admin.exams"))
    return render_template("admin/exams.html", rows=Exam.query.order_by(Exam.id.desc()).all(), years=AcademicYear.query.order_by(AcademicYear.name.desc()).all())


@admin_bp.route("/exams/<int:row_id>/delete", methods=["POST"])
def delete_exam(row_id):
    return delete_row(Exam, row_id, "admin.exams")


@admin_bp.route("/exams/<int:row_id>/toggle", methods=["POST"])
def toggle_exam(row_id):
    exam = db.session.get(Exam, row_id) or abort_404()
    exam.is_published = not exam.is_published
    Result.query.filter_by(exam_id=exam.id).update({"is_published": exam.is_published})
    db.session.commit()
    flash("Publish status updated.", "success")
    return redirect(url_for("admin.exams"))


@admin_bp.route("/academic-years", methods=["GET", "POST"])
def academic_years():
    if request.method == "POST":
        year = db.session.get(AcademicYear, int(request.form.get("id") or 0)) or AcademicYear()
        year.name = request.form["name"].strip()
        db.session.add(year)
        db.session.commit()
        flash("Academic year saved.", "success")
        return redirect(url_for("admin.academic_years"))
    return render_template("admin/academic_years.html", rows=AcademicYear.query.order_by(AcademicYear.name.desc()).all())


@admin_bp.route("/academic-years/<int:row_id>/current", methods=["POST"])
def switch_year(row_id):
    AcademicYear.query.update({"is_current": False})
    year = db.session.get(AcademicYear, row_id) or abort_404()
    year.is_current = True
    db.session.commit()
    flash("Current academic year switched.", "success")
    return redirect(url_for("admin.academic_years"))


@admin_bp.route("/users", methods=["GET", "POST"])
@role_required("super_admin")
def users():
    if request.method == "POST":
        user = db.session.get(User, int(request.form.get("id") or 0)) or User()
        user.username = request.form["username"].strip()
        user.full_name = request.form["full_name"].strip()
        user.role = request.form["role"]
        user.is_active = bool(request.form.get("is_active"))
        password = request.form.get("password", "")
        if password:
            user.set_password(password)
        elif not user.id:
            flash("Password is required for new users.", "danger")
            return redirect(url_for("admin.users"))
        db.session.add(user)
        db.session.commit()
        flash("User saved.", "success")
        return redirect(url_for("admin.users"))
    return render_template("admin/users.html", rows=User.query.order_by(User.username).all())


@admin_bp.route("/users/<int:row_id>/reset", methods=["POST"])
@role_required("super_admin")
def reset_user_password(row_id):
    user = db.session.get(User, row_id) or abort_404()
    password = request.form.get("password", "")
    if len(password) < 8:
        flash("New password must be at least 8 characters.", "danger")
    else:
        user.set_password(password)
        db.session.commit()
        flash("Password reset.", "success")
    return redirect(url_for("admin.users"))


@admin_bp.route("/settings", methods=["GET", "POST"])
def settings():
    if request.method == "POST":
        editable_keys = [
            "school_name",
            "school_address",
            "school_phone",
            "school_email",
            "school_website",
            "school_motto",
            "principal_name",
            "school_footer",
            "passing_mark",
            "dashboard_title",
            "dashboard_subtitle",
            "dashboard_theme",
            "primary_color",
            "secondary_color",
            "sidebar_color",
            "visible_cards",
            "homepage_widgets",
            "default_language",
            "whatsapp_url",
            "facebook_url",
            "instagram_url",
            "telegram_url",
            "twitter_url",
            "email_url",
            "call_url",
            "maps_url",
        ]
        for key in editable_keys:
            setting = db.session.get(Setting, key) or Setting(key=key)
            setting.value = request.form.get(key, "").strip()
            db.session.add(setting)
        upload_fields = {
            "logo": "logo_path",
            "admin_logo": "admin_logo_path",
            "dashboard_background": "dashboard_background",
            "principal_signature": "principal_signature_path",
            "vice_principal_signature": "vice_principal_signature_path",
            "exam_officer_signature": "exam_officer_signature_path",
        }
        for field_name, setting_key in upload_fields.items():
            upload = request.files.get(field_name)
            if not upload or not upload.filename:
                continue
            if not allowed_file(upload.filename, ALLOWED_PHOTOS):
                flash("Uploaded images must be JPG, PNG, or WEBP.", "danger")
                return redirect(url_for("admin.settings"))
            filename = f"{setting_key}_{safe_upload_name(upload.filename)}"
            upload_dir = Path(current_app_config("UPLOAD_FOLDER"))
            upload_dir.mkdir(parents=True, exist_ok=True)
            upload.save(upload_dir / filename)
            setting = db.session.get(Setting, setting_key) or Setting(key=setting_key)
            setting.value = f"uploads/{filename}"
            db.session.add(setting)
        for grade in GradeScale.query.all():
            grade.min_score = request.form.get(f"min_{grade.id}", grade.min_score)
            grade.max_score = request.form.get(f"max_{grade.id}", grade.max_score)
            grade.comment = request.form.get(f"comment_{grade.id}", grade.comment)
        db.session.commit()
        flash("Settings saved.", "success")
        return redirect(url_for("admin.settings"))
    return render_template("admin/settings.html", settings=get_settings(), scales=GradeScale.query.order_by(GradeScale.min_score.desc()).all())


@admin_bp.route("/classes/<int:row_id>/delete", methods=["POST"])
def delete_class(row_id):
    return delete_row(SchoolClass, row_id, "admin.classes")


@admin_bp.route("/subjects/<int:row_id>/delete", methods=["POST"])
def delete_subject(row_id):
    return delete_row(Subject, row_id, "admin.subjects")


@admin_bp.route("/academic-years/<int:row_id>/delete", methods=["POST"])
def delete_academic_year(row_id):
    return delete_row(AcademicYear, row_id, "admin.academic_years")


def simple_crud(model, template, fields):
    if request.method == "POST":
        row = db.session.get(model, int(request.form.get("id") or 0)) or model()
        for field in fields:
            setattr(row, field, request.form.get(field, "").strip())
        db.session.add(row)
        db.session.commit()
        flash("Saved successfully.", "success")
        return redirect(url_for(f"admin.{template}"))
    return render_template(f"admin/{template}.html", rows=model.query.order_by(model.id.desc()).all())


def delete_row(model, row_id, endpoint):
    row = db.session.get(model, row_id) or abort_404()
    db.session.delete(row)
    db.session.commit()
    flash("Deleted successfully.", "success")
    return redirect(url_for(endpoint))


def get_or_create(model, **kwargs):
    row = model.query.filter_by(**kwargs).first()
    if row:
        return row
    row = model(**kwargs)
    db.session.add(row)
    db.session.flush()
    return row


def workbook_response(workbook, filename):
    from tempfile import NamedTemporaryFile

    tmp = NamedTemporaryFile(delete=False, suffix=".xlsx")
    workbook.save(tmp.name)
    tmp.close()
    return send_file(tmp.name, as_attachment=True, download_name=filename, mimetype="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")


def current_app_config(key):
    from flask import current_app

    return current_app.config[key]


def abort_404():
    from flask import abort

    abort(404)
