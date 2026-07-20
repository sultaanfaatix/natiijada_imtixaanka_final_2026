from datetime import datetime, date, timedelta

from flask import Blueprint, abort, flash, redirect, render_template, request, send_file, session, url_for
from flask_login import current_user, login_required
from openpyxl import Workbook
from sqlalchemy import or_
from sqlalchemy.exc import SQLAlchemyError

from . import db
from .audit import audit
from .cloudinary_service import upload_image
from .import_wizard import preview_results, preview_students, result_template, student_template
from .models import AcademicLevel, AcademicClass, AcademicSection, AcademicYear, AuditLog, Exam, GradeScale, IncidentAction, IncidentAttachment, IncidentCategory, IncidentReport, Result, SchoolClass, SeverityLevel, Setting, Student, Subject, User, ExamInvigilator, InvigilatorLoginHistory, IncidentReportSettings
from .permissions import PERMISSIONS, can, enforce_endpoint_permission, permission_required
from .security import ALLOWED_PHOTOS, ALLOWED_SHEETS, allowed_file
from .services import get_settings, grade_for, result_payload
from .services import slug

admin_bp = Blueprint("admin", __name__)


INCIDENT_SETTING_DEFAULTS = [
    ("invigilator_password_type", "letters_numbers", "string", "security", "Invigilator password character type"),
    ("invigilator_password_min_length", "6", "integer", "security", "Invigilator password minimum length"),
    ("allow_signature_reuse", "true", "boolean", "security", "Allow invigilators to reuse saved digital signatures"),
]


def ensure_incident_setting_defaults():
    changed = False
    for key, value, setting_type, category, description in INCIDENT_SETTING_DEFAULTS:
        if not IncidentReportSettings.query.filter_by(setting_key=key).first():
            db.session.add(IncidentReportSettings(
                setting_key=key,
                setting_value=value,
                setting_type=setting_type,
                category=category,
                description=description,
            ))
            changed = True
    if changed:
        db.session.commit()


def incident_setting_value(key, default=None):
    row = IncidentReportSettings.query.filter_by(setting_key=key).first()
    return row.setting_value if row else default


def validate_invigilator_password(password):
    policy_type = incident_setting_value("invigilator_password_type", "letters_numbers")
    min_length = int(incident_setting_value("invigilator_password_min_length", "6") or 6)
    if len(password or "") < min_length:
        return False, f"Password must be at least {min_length} characters."
    if policy_type == "numbers" and not password.isdigit():
        return False, "Password must contain numbers only."
    if policy_type == "letters" and not password.isalpha():
        return False, "Password must contain letters only."
    if policy_type == "letters_numbers" and not password.isalnum():
        return False, "Password must contain letters and numbers only."
    return True, ""


def generate_invigilator_password():
    import random
    import string

    policy_type = incident_setting_value("invigilator_password_type", "letters_numbers")
    min_length = int(incident_setting_value("invigilator_password_min_length", "6") or 6)
    alphabet = string.ascii_letters + string.digits
    if policy_type == "numbers":
        alphabet = string.digits
    elif policy_type == "letters":
        alphabet = string.ascii_letters
    return "".join(random.choice(alphabet) for _ in range(max(4, min_length)))


@admin_bp.before_request
@login_required
def require_login():
    enforce_endpoint_permission()


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


@admin_bp.route("/incidents")
def incidents():
    """Incident Reports Dashboard"""
    q = request.args.get("q", "").strip()
    status_filter = request.args.get("status", "")
    severity_filter = request.args.get("severity", "")
    category_filter = request.args.get("category", "")
    room_filter = request.args.get("room", "").strip()
    subject_filter = request.args.get("subject", "").strip()
    session_filter = request.args.get("exam_session", "")
    academic_year_filter = request.args.get("academic_year_id", "")
    exam_filter = request.args.get("exam_id", "") or session_filter
    level_filter = request.args.get("level_id", "")
    class_filter = request.args.get("class_id", "")
    date_from = request.args.get("date_from", "")
    date_to = request.args.get("date_to", "")
    
    query = IncidentReport.query.outerjoin(IncidentReport.student).outerjoin(IncidentReport.exam)
    
    if q:
        query = query.filter(
            or_(
                Student.student_code.like(f"%{q}%"),
                Student.full_name.like(f"%{q}%")
            )
        )
    
    if status_filter:
        query = query.filter(IncidentReport.status == status_filter)
    
    if severity_filter:
        query = query.filter(IncidentReport.severity_id == int(severity_filter))
    
    if category_filter:
        query = query.filter(IncidentReport.category_id == int(category_filter))
    
    if room_filter:
        query = query.filter(IncidentReport.exam_room.like(f"%{room_filter}%"))
    
    if subject_filter:
        query = query.filter(IncidentReport.subject.has(Subject.name.like(f"%{subject_filter}%")))

    if academic_year_filter:
        query = query.filter(Exam.academic_year_id == int(academic_year_filter))

    if exam_filter:
        query = query.filter(IncidentReport.exam_id == int(exam_filter))

    if level_filter:
        query = query.filter(Student.academic_level_id == int(level_filter))

    if class_filter:
        query = query.filter(Student.academic_class_id == int(class_filter))
    
    if date_from:
        query = query.filter(IncidentReport.incident_date >= datetime.strptime(date_from, "%Y-%m-%d").date())
    
    if date_to:
        query = query.filter(IncidentReport.incident_date <= datetime.strptime(date_to, "%Y-%m-%d").date())
    
    reports = query.order_by(IncidentReport.created_at.desc()).all()
    # Statistics reflect the currently filtered report set.
    stats = {
        "total": len(reports),
        "critical": sum(1 for r in reports if r.severity and r.severity.name.lower() == "critical"),
        "serious": sum(1 for r in reports if r.severity and r.severity.name.lower() == "serious"),
        "moderate": sum(1 for r in reports if r.severity and r.severity.name.lower() == "moderate"),
        "minor": sum(1 for r in reports if r.severity and r.severity.name.lower() == "minor"),
        "resolved": sum(1 for r in reports if r.status == "Resolved"),
    }
    categories = IncidentCategory.query.filter_by(is_active=True).order_by(IncidentCategory.sort_order).all()
    severities = SeverityLevel.query.filter_by(is_active=True).order_by(SeverityLevel.sort_order).all()
    academic_years = AcademicYear.query.order_by(AcademicYear.name.desc()).all()
    exams = Exam.query.order_by(Exam.id.desc()).all()
    levels = AcademicLevel.query.order_by(AcademicLevel.sort_order, AcademicLevel.name).all()
    classes = AcademicClass.query.order_by(AcademicClass.sort_order, AcademicClass.name).all()
    exam_sessions = exams
    
    return render_template(
        "admin/incidents.html",
        reports=reports,
        stats=stats,
        categories=categories,
        severities=severities,
        academic_years=academic_years,
        exams=exams,
        levels=levels,
        classes=classes,
        exam_sessions=exam_sessions,
        session_filter=session_filter,
        academic_year_filter=academic_year_filter,
        exam_filter=exam_filter,
        level_filter=level_filter,
        class_filter=class_filter,
        room_filter=room_filter,
        subject_filter=subject_filter,
        q=q,
        status_filter=status_filter,
        severity_filter=severity_filter,
        category_filter=category_filter,
        date_from=date_from,
        date_to=date_to
    )


@admin_bp.route("/incidents/<int:report_id>")
def incident_view(report_id):
    """View single incident report details"""
    report = IncidentReport.query.get_or_404(report_id)
    categories = IncidentCategory.query.filter_by(is_active=True).order_by(IncidentCategory.sort_order).all()
    severities = SeverityLevel.query.filter_by(is_active=True).order_by(SeverityLevel.sort_order).all()
    return render_template("admin/incident_view.html", report=report, categories=categories, severities=severities)


@admin_bp.route("/incidents/<int:report_id>/edit", methods=["GET", "POST"])
def incident_edit(report_id):
    """Edit incident report"""
    report = IncidentReport.query.get_or_404(report_id)
    
    if request.method == "POST":
        report.category_id = int(request.form.get("category_id"))
        report.severity_id = int(request.form.get("severity_id"))
        report.exam_room = request.form.get("exam_room", "")
        report.description = request.form.get("description", "")
        report.actions_taken = request.form.get("actions_taken", "")
        report.status = request.form.get("status", "Pending Review")
        report.reviewed_by_id = current_user.id
        report.reviewed_at = datetime.utcnow()
        report.review_notes = request.form.get("review_notes", "")
        
        db.session.commit()
        audit("Incident Report Updated", f"Updated report {report.report_number}")
        flash("Incident report updated successfully.", "success")
        return redirect(url_for("admin.incidents"))
    
    categories = IncidentCategory.query.filter_by(is_active=True).order_by(IncidentCategory.sort_order).all()
    severities = SeverityLevel.query.filter_by(is_active=True).order_by(SeverityLevel.sort_order).all()
    return render_template("admin/incident_edit.html", report=report, categories=categories, severities=severities)


@admin_bp.route("/incidents/<int:report_id>/delete", methods=["POST"])
def incident_delete(report_id):
    """Delete incident report"""
    report = IncidentReport.query.get_or_404(report_id)
    report_number = report.report_number
    db.session.delete(report)
    db.session.commit()
    audit("Incident Report Deleted", f"Deleted report {report_number}")
    flash("Incident report deleted successfully.", "success")
    return redirect(url_for("admin.incidents"))


@admin_bp.route("/students")
def students():
    return redirect(url_for("admin_advanced_results.students_management", **request.args.to_dict(flat=True)))


@admin_bp.route("/students/new", methods=["GET", "POST"])
@admin_bp.route("/students/<int:student_id>/edit", methods=["GET", "POST"])
def student_form(student_id=None):
    endpoint = "admin_advanced_results.student_form"
    target = url_for(endpoint, student_id=student_id) if student_id else url_for(endpoint)
    return redirect(target, code=307 if request.method == "POST" else 302)


@admin_bp.route("/students/<int:student_id>/delete", methods=["POST"])
def delete_student(student_id):
    return redirect(url_for("admin_advanced_results.delete_student", student_id=student_id), code=307)


@admin_bp.route("/students/<int:student_id>/toggle-lock", methods=["POST"])
def toggle_student_lock(student_id):
    return redirect(url_for("admin_advanced_results.toggle_student_lock", student_id=student_id), code=307)


@admin_bp.route("/students/import", methods=["POST"])
def import_students():
    return redirect(url_for("admin_advanced_results.import_students"), code=307)


@admin_bp.route("/students/import/confirm", methods=["POST"])
def confirm_student_import():
    return redirect(url_for("admin_advanced_results.confirm_student_import"), code=307)


@admin_bp.route("/students/import/template")
def student_import_template():
    return redirect(url_for("admin_advanced_results.student_import_template"))


@admin_bp.route("/students/export")
def export_students():
    return redirect(url_for("admin_advanced_results.export_students"))


@admin_bp.route("/results")
def results():
    """Redirect to new Results dashboard - old view retired"""
    return redirect(url_for("admin_advanced_results.new_dashboard"))


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
    audit("Result Publishing", f"Saved results for student {student.student_code} exam {exam.name}")
    db.session.commit()
    flash("Results saved.", "success")
    return redirect(url_for("admin_advanced_results.new_dashboard"))


@admin_bp.route("/results/<int:result_id>/delete", methods=["POST"])
def delete_result(result_id):
    result = db.session.get(Result, result_id) or abort_404()
    db.session.delete(result)
    audit("Result Publishing", f"Deleted result row {result_id}")
    db.session.commit()
    flash("Result row deleted.", "success")
    return redirect(url_for("admin_advanced_results.new_dashboard"))


@admin_bp.route("/results/<int:student_id>/<int:exam_id>/edit", methods=["GET", "POST"])
def edit_result_set(student_id, exam_id):
    student = db.session.get(Student, student_id) or abort_404()
    exam = db.session.get(Exam, exam_id) or abort_404()
    subjects = Subject.query.order_by(Subject.sort_order, Subject.name).all()
    existing = {row.subject_id: row for row in Result.query.filter_by(student_id=student.id, exam_id=exam.id).all()}
    if request.method == "POST":
        changes = []
        for subject in subjects:
            raw = request.form.get(f"score_{subject.id}", "").strip()
            result = existing.get(subject.id)
            if raw == "":
                continue
            score = max(0, min(float(raw), float(subject.max_score)))
            if not result:
                result = Result(student=student, exam=exam, subject=subject)
            old_score = float(result.score) if result.id and result.score is not None else None
            old_grade = result.grade_override or ""
            old_comment = result.comment or ""
            result.score = score
            result.grade_override = request.form.get(f"grade_{subject.id}", "").strip() or None
            result.comment = request.form.get(f"comment_{subject.id}", "").strip() or None
            result.is_published = bool(request.form.get(f"published_{subject.id}"))
            db.session.add(result)
            if old_score != score or old_grade != (result.grade_override or "") or old_comment != (result.comment or ""):
                changes.append(f"{subject.name}: {old_score} -> {score}")
        audit("Result Publishing", f"Edited result set for {student.student_code} / {exam.name}: {', '.join(changes) or 'no score changes'}")
        db.session.commit()
        flash("Result changes saved. Totals, averages, grades, and status recalculated automatically.", "success")
        return redirect(url_for("admin.edit_result_set", student_id=student.id, exam_id=exam.id))
    payload = result_payload(student, exam=exam, public_only=False)
    subject_previews = {}
    for subject in subjects:
        row = existing.get(subject.id)
        percentage = float(row.score) / float(subject.max_score) * 100 if row and subject.max_score else 0
        subject_previews[subject.id] = grade_for(percentage)
    return render_template(
        "admin/result_edit.html",
        student=student,
        exam=exam,
        subjects=subjects,
        existing=existing,
        subject_previews=subject_previews,
        payload=payload,
        scales=GradeScale.query.order_by(GradeScale.min_score.desc()).all(),
    )


@admin_bp.route("/results/import", methods=["POST"])
def import_results():
    file = request.files.get("file")
    exam_id = request.form.get("exam_id")
    if not file or not allowed_file(file.filename, ALLOWED_SHEETS) or not exam_id:
        flash("Choose an exam and upload an .xlsx file.", "danger")
        return redirect(url_for("admin_advanced_results.new_dashboard"))
    rows, errors = preview_results(file, int(exam_id))
    if not errors:
        session["result_import_rows"] = rows
    audit("Import Operations", f"Previewed result import: {len(rows)} rows, {len(errors)} errors")
    db.session.commit()
    return render_template("admin/import_wizard.html", kind="results", rows=rows, errors=errors, confirm_url=url_for("admin.confirm_result_import"))


@admin_bp.route("/results/import/confirm", methods=["POST"])
def confirm_result_import():
    rows = session.pop("result_import_rows", [])
    if not rows:
        flash("No validated result import is waiting for confirmation.", "warning")
        return redirect(url_for("admin_advanced_results.new_dashboard"))
    try:
        for data in rows:
            student = Student.query.filter_by(student_code=data["student_id"]).one()
            subject = Subject.query.filter_by(name=data["subject"]).one()
            exam = db.session.get(Exam, int(data["exam_id"]))
            result = Result.query.filter_by(student_id=student.id, exam_id=exam.id, subject_id=subject.id).first() or Result(student=student, exam=exam, subject=subject)
            result.score = float(data["score"])
            result.is_published = True
            db.session.add(result)
        audit("Import Operations", f"Confirmed result import: {len(rows)} rows")
        db.session.commit()
    except Exception:
        db.session.rollback()
        flash("Import failed. No records were saved.", "danger")
        return redirect(url_for("admin_advanced_results.new_dashboard"))
    flash(f"Imported {len(rows)} result rows.", "success")
    return redirect(url_for("admin_advanced_results.new_dashboard"))


@admin_bp.route("/results/import/template")
def result_import_template():
    return workbook_response(result_template(), "result_import_template.xlsx")


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
    payload = result_payload(student, exam=exam, public_only=False)
    from .verification import verification_payload

    payload["verification"] = verification_payload(student, exam)
    payload["generated_at"] = datetime.now()
    db.session.commit()
    return render_template("print_report.html", result=payload)


@admin_bp.route("/classes", methods=["GET", "POST"])
def classes():
    if request.method == "POST":
        cls = db.session.get(SchoolClass, int(request.form.get("id") or 0)) or SchoolClass()
        cls.name = request.form["name"].strip()
        cls.description = request.form.get("description", "").strip()
        db.session.add(cls)
        db.session.commit()
        flash("Class saved.", "success")
        return redirect(url_for("admin_advanced_results.new_dashboard"))
    return redirect(url_for("admin_advanced_results.new_dashboard"))


@admin_bp.route("/subjects", methods=["GET", "POST"])
def subjects():
    if request.method == "POST":
        subject = db.session.get(Subject, int(request.form.get("id") or 0)) or Subject()
        subject.name = request.form["name"].strip()
        subject.max_score = float(request.form.get("max_score", 100))
        subject.sort_order = int(request.form.get("sort_order", 0))
        db.session.add(subject)
        db.session.commit()
        flash("Subject saved.", "success")
        return redirect(url_for("admin_advanced_results.new_setup"))
    return redirect(url_for("admin_advanced_results.new_setup"))


@admin_bp.route("/exams", methods=["GET", "POST"])
def exams():
    if request.method == "POST":
        exam = db.session.get(Exam, int(request.form.get("id") or 0)) or Exam()
        exam.name = request.form["name"].strip()
        exam.short_code = request.form.get("short_code", "").strip()
        exam.academic_year_id = int(request.form["academic_year_id"])
        exam.weight_percentage = float(request.form.get("weight_percentage", 0))
        exam.sort_order = int(request.form.get("sort_order", 0))
        exam.is_active = bool(request.form.get("is_active"))
        exam.is_published = bool(request.form.get("is_published"))
        db.session.add(exam)
        db.session.commit()
        flash("Exam saved.", "success")
        return redirect(url_for("admin_advanced_results.new_setup"))
    return redirect(url_for("admin_advanced_results.new_setup"))


@admin_bp.route("/exams/<int:row_id>/delete", methods=["POST"])
def delete_exam(row_id):
    return delete_row(Exam, row_id, "admin_advanced_results.new_setup")


@admin_bp.route("/exams/<int:row_id>/toggle", methods=["POST"])
def toggle_exam(row_id):
    exam = db.session.get(Exam, row_id) or abort_404()
    exam.is_published = not exam.is_published
    Result.query.filter_by(exam_id=exam.id).update({"is_published": exam.is_published})
    db.session.commit()
    flash("Publish status updated.", "success")
    return redirect(url_for("admin_advanced_results.new_setup"))


@admin_bp.route("/academic-years", methods=["GET", "POST"])
def academic_years():
    if request.method == "POST":
        year = db.session.get(AcademicYear, int(request.form.get("id") or 0)) or AcademicYear()
        year.name = request.form["name"].strip()
        db.session.add(year)
        db.session.commit()
        flash("Academic year saved.", "success")
        return redirect(url_for("admin_advanced_results.new_dashboard"))
    return redirect(url_for("admin_advanced_results.new_dashboard"))


@admin_bp.route("/academic-years/<int:row_id>/current", methods=["POST"])
def switch_year(row_id):
    AcademicYear.query.update({"is_current": False})
    year = db.session.get(AcademicYear, row_id) or abort_404()
    year.is_current = True
    db.session.commit()
    flash("Current academic year switched.", "success")
    return redirect(url_for("admin_advanced_results.new_dashboard"))


@admin_bp.route("/users", methods=["GET", "POST"])
@permission_required("users")
def users():
    if request.method == "POST":
        user = db.session.get(User, int(request.form.get("id") or 0)) or User()
        user.username = request.form["username"].strip()
        user.full_name = request.form["full_name"].strip()
        user.role = request.form["role"]
        user.is_active = bool(request.form.get("is_active"))
        photo = request.files.get("photo")
        if photo and photo.filename:
            if not allowed_file(photo.filename, ALLOWED_PHOTOS):
                flash("Admin photo must be JPG, PNG, or WEBP.", "danger")
                return redirect(url_for("admin.users"))
            photo_url = upload_image(photo, "school/admins")
            user.photo_path = photo_url
        password = request.form.get("password", "")
        if password:
            user.set_password(password)
        elif not user.id:
            flash("Password is required for new users.", "danger")
            return redirect(url_for("admin.users"))
        db.session.add(user)
        posted_permissions = request.form.getlist("permissions")
        user.set_permissions(posted_permissions)
        audit("Admin Updates", f"Saved admin {user.username}")
        audit("Permission Changes", f"Updated permissions for {user.username}: {', '.join(posted_permissions)}")
        db.session.commit()
        flash("User saved.", "success")
        return redirect(url_for("admin.users"))
    return render_template("admin/users.html", rows=User.query.order_by(User.username).all(), permissions=PERMISSIONS)


@admin_bp.route("/users/<int:row_id>/reset", methods=["POST"])
@permission_required("users")
def reset_user_password(row_id):
    user = db.session.get(User, row_id) or abort_404()
    password = request.form.get("password", "")
    if len(password) < 8:
        flash("New password must be at least 8 characters.", "danger")
    else:
        user.set_password(password)
        audit("Admin Updates", f"Reset password for {user.username}")
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
            "dashboard_title",
            "dashboard_subtitle",
            "dashboard_theme",
            "primary_color",
            "secondary_color",
            "sidebar_color",
            "visible_cards",
            "homepage_widgets",
            "search_footer_text",
            "search_footer_font_size",
            "search_footer_font_weight",
            "search_footer_text_color",
            "search_footer_background_color",
            "search_footer_border_color",
            "search_footer_visibility",
            "typography_page_title_size",
            "typography_subtitle_size",
            "typography_input_label_size",
            "typography_input_placeholder_size",
            "typography_button_size",
            "typography_footer_size",
            "typography_copyright_size",
            "typography_student_info_size",
            "typography_dashboard_heading_size",
            "typography_table_text_size",
            "default_language",
            "whatsapp_url",
            "facebook_url",
            "instagram_url",
            "telegram_url",
            "twitter_url",
            "email_url",
            "call_url",
            "maps_url",
            "enable_phone_verification",
            "report_header_style",
            "report_footer_text",
            "report_primary_color",
            "report_accent_color",
            "report_font_family",
            "report_border_style",
            "report_background",
            "report_watermark",
            "report_logo_position",
            "report_qr_position",
            "report_photo_position",
            "report_signature_position",
            "report_comment_box",
            "report_table_style",
            "principal_comment",
            "student_photo_shape",
            "student_photo_size",
            "student_photo_border",
            "student_photo_shadow",
            "attendance_color_present",
            "attendance_color_absent",
            "attendance_color_late",
            "attendance_color_excused",
            "attendance_color_medical_leave",
            "attendance_color_blocked",
            "attendance_icon_present",
            "attendance_icon_absent",
            "attendance_icon_late",
            "attendance_icon_excused",
            "attendance_icon_medical_leave",
            "attendance_icon_blocked",
            "result_page_primary_color",
            "result_page_accent_color",
            "result_dashboard_primary_color",
            "result_dashboard_secondary_color",
            "result_dashboard_accent_color",
            "result_dashboard_background_color",
            "result_dashboard_card_color",
            "result_dashboard_button_color",
            "result_dashboard_header_color",
            "result_dashboard_footer_color",
            "result_dashboard_table_header_color",
            "result_dashboard_text_color",
            "result_dashboard_muted_text_color",
            "result_dashboard_font_family",
            "result_dashboard_base_font_size",
            "result_dashboard_font_weight",
            "result_dashboard_line_height",
            "result_dashboard_border_radius",
            "result_dashboard_card_spacing",
            "result_dashboard_shadow",
            "result_dashboard_padding",
            "result_dashboard_margin",
            "result_dashboard_show_student_photo",
            "result_dashboard_show_school_logo",
            "result_dashboard_show_qr",
            "result_dashboard_show_sidebar",
            "result_dashboard_show_grade_scale",
            "result_dashboard_show_performance",
            "result_dashboard_show_teacher_remarks",
            "result_dashboard_show_summary",
            "result_dashboard_show_footer",
            "result_dashboard_show_social_icons",
            "result_dashboard_show_download_button",
            "result_dashboard_show_print_button",
            "result_dashboard_show_share_button",
            "result_sidebar_theme",
            "result_sidebar_student_name_size",
            "result_sidebar_student_name_weight",
            "result_sidebar_label_size",
            "result_sidebar_value_size",
            "result_sidebar_title_size",
            "result_sidebar_school_name_size",
            "result_sidebar_school_motto_size",
            "result_sidebar_photo_border_width",
            "result_sidebar_photo_border_color",
            "result_sidebar_photo_border_style",
            "result_sidebar_photo_border_radius",
            "result_sidebar_photo_width",
            "result_sidebar_photo_height",
            "result_sidebar_photo_object_fit",
            "result_sidebar_photo_object_position",
            "result_sidebar_photo_shadow",
            "result_sidebar_label_color",
            "result_sidebar_label_font_weight",
            "result_sidebar_label_letter_spacing",
            "result_sidebar_label_text_transform",
            "result_sidebar_value_color",
            "result_sidebar_value_weight",
            "result_sidebar_show_student_photo",
            "result_sidebar_show_school_logo",
            "result_sidebar_show_overlay_logo",
            "result_sidebar_show_student_name",
            "result_sidebar_show_student_class",
            "result_sidebar_show_parent_name",
            "result_sidebar_show_student_id",
            "result_sidebar_show_exam_name",
            "result_sidebar_show_download_date",
            "result_sidebar_show_percentage",
            "result_sidebar_show_school_name",
            "result_sidebar_show_school_motto",
            "result_table_style",
            "result_card_style",
            "result_button_style",
            "result_icon_style",
            "result_online_title_primary",
            "result_online_title_accent",
            "result_online_quote",
            "result_label_mother_name",
            "result_label_student_id",
            "result_label_student_class",
            "result_label_exam_type",
            "result_label_date_issued",
            "result_label_subject_percentage",
            "result_academic_summary_title",
            "result_teacher_remarks_title",
            "result_footer_owner",
            "download_datetime_format",
            "print_brand_code",
            "print_report_title",
            "print_exam_banner_text",
            "print_subtitle",
            "print_student_heading",
            "print_marks_heading",
            "print_qr_label",
            "print_comments_heading",
            "print_signature_title",
            "print_signature_subtitle",
            "print_footer_owner",
            "print_layout_header_color",
            "print_layout_banner_color",
            "print_layout_banner_accent",
            "print_layout_table_header_color",
            "print_layout_border_color",
            "print_layout_background_color",
            "print_layout_text_color",
            "print_layout_font_family",
            "print_layout_font_size",
            "print_layout_font_weight",
            "print_layout_margin",
            "print_layout_padding",
            "print_layout_radius",
            "print_layout_shadow",
            "print_layout_table_row_height",
            "print_layout_table_font_size",
            "print_layout_page_spacing",
            "print_show_school_logo",
            "print_show_school_name",
            "print_show_academic_year_badge",
            "print_show_exam_banner",
            "print_show_student_photo",
            "print_show_qr_code",
            "print_show_download_date",
            "print_show_teacher_signature",
            "print_show_principal_signature",
            "print_show_footer",
            "print_show_watermark",
            "verify_page_enabled",
            "verify_page_title",
            "verify_page_subtitle",
            "verify_page_footer_text",
            "verify_page_copyright_text",
            "verify_success_message",
            "verify_badge_style",
            "verify_theme",
            "verify_school_motto",
            "verify_primary_color",
            "verify_secondary_color",
            "verify_accent_color",
            "verify_background_color",
            "verify_card_color",
            "verify_success_color",
            "verify_text_color",
            "verify_muted_text_color",
            "verify_button_color",
            "verify_border_color",
            "verify_icon_color",
            "verify_font_family",
            "verify_font_size",
            "verify_font_weight",
            "verify_card_radius",
            "verify_card_shadow",
            "verify_spacing",
            "verify_page_width",
            "verify_section_order",
            "verify_show_student_photo",
            "verify_show_school_logo",
            "verify_show_badge",
            "verify_show_digital_seal",
            "verify_show_result_summary",
            "verify_show_details",
            "verify_show_footer",
            "verify_fields_student_name",
            "verify_fields_student_id",
            "verify_fields_class",
            "verify_fields_exam",
            "verify_fields_academic_year",
            "verify_fields_total_marks",
            "verify_fields_percentage",
            "verify_fields_grade",
            "verify_fields_rank",
            "verify_fields_status",
            "verify_message",
            "verify_badge_text",
            "verify_status_text",
            "verify_id_prefix",
            "verify_footer_heading",
            "verify_animation_success",
            "verify_animation_loading",
            "verify_design_preset",
            "verify_animation_fade",
            "verify_animation_zoom",
            "verify_animation_slide",
            "verify_animation_bounce",
            "verify_animation_ripple",
            "verify_animation_glow",
            "verify_custom_css",
            "verify_custom_js",
            "verify_id_header_primary",
            "verify_id_header_secondary",
            "verify_id_badge_primary",
            "verify_id_badge_secondary",
            "verify_id_logo_size",
            "verify_id_header_padding",
            "verify_id_photo_size",
            "verify_id_photo_border_width",
            "verify_id_photo_border_color",
            "verify_id_photo_radius",
            "verify_id_card_radius",
            "verify_id_card_padding",
            "verify_id_card_spacing",
            "verify_id_stamp_size",
            "verify_id_stamp_color",
            "verify_id_status_color",
            "verify_id_status_dark",
            "verify_id_badge_radius",
            "verify_id_badge_animation",
            "verify_id_glass_effect",
            "verify_id_show_watermark",
            "verify_id_photo_shadow",
            "verify_id_show_header",
            "verify_id_show_badge",
            "verify_id_show_status_card",
            "verify_id_show_verification_area",
            "verify_id_show_footer",
            "verify_id_show_icons",
            "verify_id_show_background_decorations",
            "verify_id_show_logo",
            "verify_id_show_photo",
            "verify_id_show_student_name",
            "verify_id_show_student_id",
            "verify_id_show_mother_name",
            "verify_id_show_class",
            "verify_id_show_section",
            "verify_id_show_academic_year",
            "verify_id_show_exam_type",
            "verify_id_show_issue_date",
            "verify_id_show_expiry_date",
            "verify_id_show_stamp",
            "verify_id_show_verification_code",
            "verify_id_show_date_time",
            "verify_id_font_family",
            "verify_id_font_size",
            "verify_id_font_weight",
            "verify_id_text_color",
            "verify_id_letter_spacing",
            "verify_id_line_height",
            "verify_id_text_align",
            "verify_id_header_font_size",
            "verify_id_name_font_size",
            "verify_id_label_font_size",
            "verify_id_value_font_size",
            "verify_id_bg_color",
            "verify_id_card_bg",
            "verify_id_border_color",
            "verify_id_footer_bg",
            "verify_id_footer_text_color",
            "verify_id_badge_text_color",
            "verify_id_status_text_color",
            "verify_id_shadow_color",
            "verify_id_template_style",
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
            "school_stamp": "school_stamp_path",
            "result_dashboard_background_image": "result_dashboard_background_image",
            "result_dashboard_default_avatar": "result_dashboard_default_avatar",
            "result_dashboard_footer_logo": "result_dashboard_footer_logo",
            "print_background_image": "print_background_image",
            "print_watermark_image": "print_watermark_image",
            "print_footer_logo": "print_footer_logo",
            "verify_background_image": "verify_background_image",
            "verify_default_student_photo": "verify_default_student_photo",
        }
        for field_name, setting_key in upload_fields.items():
            upload = request.files.get(field_name)
            if not upload or not upload.filename:
                continue
            if not allowed_file(upload.filename, ALLOWED_PHOTOS):
                flash("Uploaded images must be JPG, PNG, or WEBP.", "danger")
                return redirect(url_for("admin.settings"))
            image_url = upload_image(upload, "school/settings")
            setting = db.session.get(Setting, setting_key) or Setting(key=setting_key)
            setting.value = image_url
            db.session.add(setting)
        for subject in Subject.query.order_by(Subject.name).all():
            field_name = f"subject_icon_{subject.id}"
            upload = request.files.get(field_name)
            if not upload or not upload.filename:
                continue
            if not allowed_file(upload.filename, ALLOWED_PHOTOS):
                flash("Uploaded subject icons must be JPG, PNG, or WEBP.", "danger")
                return redirect(url_for("admin.settings"))
            image_url = upload_image(upload, "school/subjects")
            setting_key = f"subject_icon_{slug(subject.name)}"
            setting = db.session.get(Setting, setting_key) or Setting(key=setting_key)
            setting.value = image_url
            db.session.add(setting)
        for grade in GradeScale.query.all():
            grade.grade = request.form.get(f"grade_{grade.id}", grade.grade).strip() or grade.grade
            grade.min_score = request.form.get(f"min_{grade.id}", grade.min_score)
            grade.max_score = request.form.get(f"max_{grade.id}", grade.max_score)
            grade.grade_point = request.form.get(f"point_{grade.id}", grade.grade_point)
            grade.comment = request.form.get(f"comment_{grade.id}", grade.comment).strip()
            grade.is_pass = request.form.get(f"status_{grade.id}", "fail") == "pass"
            grade.badge_color = request.form.get(f"badge_color_{grade.id}", grade.badge_color)
            grade.text_color = request.form.get(f"text_color_{grade.id}", grade.text_color)
            grade.background_color = request.form.get(f"background_color_{grade.id}", grade.background_color)
            grade.border_color = request.form.get(f"border_color_{grade.id}", grade.border_color)
            grade.sort_order = int(request.form.get(f"sort_order_{grade.id}") or grade.sort_order or 0)
            grade.is_active = request.form.get(f"active_{grade.id}") == "on"
        new_grade = request.form.get("new_grade", "").strip()
        if new_grade:
            db.session.add(GradeScale(
                grade=new_grade,
                min_score=request.form.get("new_min") or 0,
                max_score=request.form.get("new_max") or 0,
                grade_point=request.form.get("new_point") or 0,
                comment=request.form.get("new_comment", "").strip() or "Custom grade",
                is_pass=request.form.get("new_status", "pass") == "pass",
                badge_color=request.form.get("new_badge_color") or "#2563eb",
                text_color=request.form.get("new_text_color") or "#ffffff",
                background_color=request.form.get("new_background_color") or "#eff6ff",
                border_color=request.form.get("new_border_color") or "#93c5fd",
                sort_order=int(request.form.get("new_sort_order") or 0),
                is_active=request.form.get("new_active", "on") == "on",
            ))
        audit("Settings Changes", "Updated system settings")
        db.session.commit()
        flash("Settings saved.", "success")
        return redirect(url_for("admin.settings"))
    return render_template(
        "admin/settings.html",
        settings=get_settings(),
        scales=GradeScale.query.order_by(GradeScale.sort_order.asc(), GradeScale.min_score.desc()).all(),
        subjects=Subject.query.order_by(Subject.name).all(),
        slug=slug,
    )


@admin_bp.route("/settings/grade-scale/<int:grade_id>/delete", methods=["POST"])
@permission_required("settings")
def delete_grade_scale(grade_id):
    # Redirect to Results Hub Grade Management (consolidated grade scale operations)
    flash("Grade Scale Management has been moved to Results → Grade Management", "info")
    return redirect(url_for("admin_advanced_results.grade_management"))


@admin_bp.route("/audit-logs")
def audit_logs():
    rows = AuditLog.query.order_by(AuditLog.created_at.desc()).limit(500).all()
    return render_template("admin/audit_logs.html", rows=rows)


@admin_bp.route("/classes/<int:row_id>/delete", methods=["POST"])
def delete_class(row_id):
    return delete_row(SchoolClass, row_id, "admin_advanced_results.new_dashboard")


@admin_bp.route("/subjects/<int:row_id>/delete", methods=["POST"])
def delete_subject(row_id):
    return delete_row(Subject, row_id, "admin_advanced_results.new_setup")


@admin_bp.route("/academic-years/<int:row_id>/delete", methods=["POST"])
def delete_academic_year(row_id):
    return delete_row(AcademicYear, row_id, "admin_advanced_results.new_setup")


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
    audit("Admin Updates", f"Deleted {model.__name__} {row_id}")
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


# =========================
# INVIGILATOR MANAGEMENT
# =========================

@admin_bp.route("/invigilators")
def invigilators():
    """Manage Exam Invigilators"""
    q = request.args.get("q", "").strip()
    status_filter = request.args.get("status", "")
    role_filter = request.args.get("role", "")
    school_filter = request.args.get("school", "")
    validity_filter = request.args.get("validity", "")
    
    query = ExamInvigilator.query
    
    if q:
        query = query.filter(
            or_(
                ExamInvigilator.full_name.like(f"%{q}%"),
                ExamInvigilator.username.like(f"%{q}%"),
                ExamInvigilator.invigilator_id.like(f"%{q}%"),
                ExamInvigilator.mobile_number.like(f"%{q}%")
            )
        )
    
    if status_filter:
        query = query.filter(ExamInvigilator.status == status_filter)
    
    if role_filter:
        query = query.filter(ExamInvigilator.role == role_filter)
    
    if school_filter:
        query = query.filter(ExamInvigilator.school.like(f"%{school_filter}%"))
    
    if validity_filter:
        today = date.today()
        if validity_filter == "active":
            query = query.filter(ExamInvigilator.active_from <= today, ExamInvigilator.active_until >= today)
        elif validity_filter == "expiring_soon":
            query = query.filter(ExamInvigilator.active_until.between(today, today + timedelta(days=7)))
        elif validity_filter == "expired":
            query = query.filter(ExamInvigilator.active_until < today)
    
    invigilators = query.order_by(ExamInvigilator.created_at.desc()).all()
    
    # Statistics
    today = date.today()
    week_from_now = today + timedelta(days=7)
    
    stats = {
        "total": ExamInvigilator.query.count(),
        "active": ExamInvigilator.query.filter_by(status="Active").count(),
        "inactive": ExamInvigilator.query.filter_by(status="Inactive").count(),
        "expiring_soon": ExamInvigilator.query.filter(
            ExamInvigilator.active_until.between(today, week_from_now)
        ).count(),
        "supervisors": ExamInvigilator.query.filter(ExamInvigilator.role.in_(["Supervisor", "Chief Invigilator"])).count(),
        "administrators": ExamInvigilator.query.filter_by(role="Administrator").count(),
    }
    
    return render_template(
        "admin/invigilators.html",
        invigilators=invigilators,
        stats=stats,
        q=q,
        status_filter=status_filter,
        role_filter=role_filter,
        school_filter=school_filter,
        validity_filter=validity_filter
    )


@admin_bp.route("/invigilators/add", methods=["GET", "POST"])
def invigilator_add():
    """Add new invigilator"""
    if request.method == "POST":
        invigilator_id = request.form.get("invigilator_id", "").strip()
        username = request.form.get("username", "").strip()
        password = request.form.get("password", "")
        full_name = request.form.get("full_name", "").strip()
        mobile_number = request.form.get("mobile_number", "").strip()
        role = request.form.get("role", "Invigilator")
        school = request.form.get("school", "").strip()
        notes = request.form.get("notes", "").strip()
        active_from = request.form.get("active_from", "")
        active_until = request.form.get("active_until", "")
        
        # Validate required fields
        if not all([invigilator_id, username, password, full_name]):
            flash("Invigilator ID, username, password, and full name are required.", "danger")
            return render_template("admin/invigilator_form.html", invigilator=None)
        is_valid_password, password_error = validate_invigilator_password(password)
        if not is_valid_password:
            flash(password_error, "danger")
            return render_template("admin/invigilator_form.html", invigilator=None)
        
        # Check if invigilator_id or username already exists
        if ExamInvigilator.query.filter_by(invigilator_id=invigilator_id).first():
            flash("Invigilator ID already exists.", "danger")
            return render_template("admin/invigilator_form.html", invigilator=None)
        
        if ExamInvigilator.query.filter_by(username=username).first():
            flash("Username already exists.", "danger")
            return render_template("admin/invigilator_form.html", invigilator=None)
        
        # Create invigilator
        invigilator = ExamInvigilator(
            invigilator_id=invigilator_id,
            username=username,
            full_name=full_name,
            mobile_number=mobile_number,
            role=role,
            school=school,
            notes=notes,
            active_from=datetime.strptime(active_from, "%Y-%m-%d").date() if active_from else None,
            active_until=datetime.strptime(active_until, "%Y-%m-%d").date() if active_until else None
        )
        invigilator.set_password(password)
        invigilator.visible_password = password
        
        db.session.add(invigilator)
        db.session.commit()
        
        audit("Invigilator Created", f"Created invigilator {invigilator.full_name} ({invigilator.invigilator_id})")
        flash(f"Invigilator {full_name} added successfully!", "success")
        return redirect(url_for("admin.invigilators"))
    
    return render_template("admin/invigilator_form.html", invigilator=None)


@admin_bp.route("/invigilators/<int:invigilator_id>/edit", methods=["GET", "POST"])
def invigilator_edit(invigilator_id):
    """Edit invigilator"""
    invigilator = ExamInvigilator.query.get_or_404(invigilator_id)
    
    if request.method == "POST":
        invigilator.invigilator_id = request.form.get("invigilator_id", "").strip()
        invigilator.username = request.form.get("username", "").strip()
        invigilator.full_name = request.form.get("full_name", "").strip()
        invigilator.mobile_number = request.form.get("mobile_number", "").strip()
        invigilator.role = request.form.get("role", "Invigilator")
        invigilator.school = request.form.get("school", "").strip()
        invigilator.notes = request.form.get("notes", "").strip()
        invigilator.status = request.form.get("status", "Active")
        invigilator.active_from = datetime.strptime(request.form.get("active_from", ""), "%Y-%m-%d").date() if request.form.get("active_from") else None
        invigilator.active_until = datetime.strptime(request.form.get("active_until", ""), "%Y-%m-%d").date() if request.form.get("active_until") else None
        
        # Update password if provided
        new_password = request.form.get("new_password", "")
        if new_password:
            is_valid_password, password_error = validate_invigilator_password(new_password)
            if not is_valid_password:
                flash(password_error, "danger")
                return render_template("admin/invigilator_form.html", invigilator=invigilator)
            invigilator.set_password(new_password)
            invigilator.visible_password = new_password
        
        # Handle photo upload
        if request.files.get("photo") and request.files["photo"].filename:
            photo = request.files["photo"]
            if allowed_file(photo.filename, ALLOWED_PHOTOS):
                photo_url = upload_image(photo, "invigilators")
                invigilator.photo_path = photo_url
        
        db.session.commit()
        
        audit("Invigilator Updated", f"Updated invigilator {invigilator.full_name} ({invigilator.invigilator_id})")
        flash(f"Invigilator {invigilator.full_name} updated successfully!", "success")
        return redirect(url_for("admin.invigilators"))
    
    return render_template("admin/invigilator_form.html", invigilator=invigilator)


@admin_bp.route("/invigilators/<int:invigilator_id>/delete", methods=["POST"])
def invigilator_delete(invigilator_id):
    """Delete invigilator"""
    invigilator = ExamInvigilator.query.get_or_404(invigilator_id)
    
    full_name = invigilator.full_name
    invigilator_id_str = invigilator.invigilator_id
    
    db.session.delete(invigilator)
    db.session.commit()
    
    audit("Invigilator Deleted", f"Deleted invigilator {full_name} ({invigilator_id_str})")
    flash(f"Invigilator {full_name} deleted successfully!", "success")
    return redirect(url_for("admin.invigilators"))


@admin_bp.route("/invigilators/<int:invigilator_id>/toggle-status", methods=["POST"])
def invigilator_toggle_status(invigilator_id):
    """Toggle invigilator active status"""
    invigilator = ExamInvigilator.query.get_or_404(invigilator_id)
    
    invigilator.is_active = not invigilator.is_active
    if not invigilator.is_active:
        invigilator.status = "Inactive"
    else:
        invigilator.status = "Active"
    
    db.session.commit()
    
    status_text = "activated" if invigilator.is_active else "deactivated"
    audit("Invigilator Status Changed", f"{status_text.capitalize()} invigilator {invigilator.full_name}")
    flash(f"Invigilator {invigilator.full_name} {status_text} successfully!", "success")
    return redirect(url_for("admin.invigilators"))


@admin_bp.route("/invigilators/<int:invigilator_id>/reset-password", methods=["POST"])
def invigilator_reset_password(invigilator_id):
    """Reset invigilator password and force change"""
    invigilator = ExamInvigilator.query.get_or_404(invigilator_id)
    
    temp_password = generate_invigilator_password()
    invigilator.set_password(temp_password)
    invigilator.visible_password = temp_password
    invigilator.force_password_change = True
    db.session.commit()
    
    audit("Invigilator Password Reset", f"Reset password for {invigilator.full_name}")
    flash(f"Temporary password for {invigilator.full_name}: {temp_password}", "info")
    return redirect(url_for("admin.invigilators"))


@admin_bp.route("/invigilators/<int:invigilator_id>/history")
def invigilator_history(invigilator_id):
    """View invigilator login history"""
    invigilator = ExamInvigilator.query.get_or_404(invigilator_id)
    history = InvigilatorLoginHistory.query.filter_by(invigilator_id=invigilator_id).order_by(InvigilatorLoginHistory.login_time.desc()).limit(50).all()
    
    return render_template("admin/invigilator_history.html", invigilator=invigilator, history=history)


# =========================
# INCIDENT REPORT SETTINGS
# =========================

@admin_bp.route("/incident-settings")
def incident_settings():
    """Manage Incident Report Settings"""
    ensure_incident_setting_defaults()
    settings = IncidentReportSettings.query.order_by(IncidentReportSettings.category, IncidentReportSettings.setting_key).all()
    categories = IncidentCategory.query.order_by(IncidentCategory.sort_order, IncidentCategory.name).all()
    severities = SeverityLevel.query.order_by(SeverityLevel.sort_order, SeverityLevel.name).all()
    actions = IncidentAction.query.order_by(IncidentAction.sort_order, IncidentAction.name).all()
    
    # Group settings by category
    grouped_settings = {}
    for setting in settings:
        if setting.category not in grouped_settings:
            grouped_settings[setting.category] = []
        grouped_settings[setting.category].append(setting)
    
    return render_template(
        "admin/incident_settings.html",
        grouped_settings=grouped_settings,
        categories=categories,
        severities=severities,
        actions=actions,
    )


@admin_bp.route("/incident-settings/update", methods=["POST"])
def incident_settings_update():
    """Update incident report settings"""
    ensure_incident_setting_defaults()
    # Get all settings first to handle unchecked checkboxes
    all_settings = IncidentReportSettings.query.all()
    
    for setting in all_settings:
        form_key = f"setting_{setting.setting_key}"
        
        if setting.setting_type == 'boolean':
            # Checkboxes only send 'on' when checked, so we need to handle unchecked case
            if form_key in request.form:
                setting.setting_value = 'true'
            else:
                setting.setting_value = 'false'
        else:
            # For non-boolean settings, use the form value if present
            if form_key in request.form:
                setting.setting_value = request.form[form_key]
    
    db.session.commit()
    
    audit("Incident Settings Updated", "Updated incident report form settings")
    flash("Incident report settings updated successfully!", "success")
    return redirect(url_for("admin.incident_settings"))


def incident_lookup_model(kind):
    models = {
        "category": IncidentCategory,
        "severity": SeverityLevel,
        "action": IncidentAction,
    }
    return models.get(kind)


@admin_bp.route("/incident-settings/<kind>/create", methods=["POST"])
def incident_lookup_create(kind):
    model = incident_lookup_model(kind)
    if not model:
        abort(404)
    name = request.form.get("name", "").strip()
    if not name:
        flash("Name is required.", "danger")
        return redirect(url_for("admin.incident_settings"))
    row = model(name=name)
    if hasattr(row, "description"):
        row.description = request.form.get("description", "").strip()
    if hasattr(row, "color") and request.form.get("color"):
        row.color = request.form.get("color")
    row.sort_order = int(request.form.get("sort_order") or 0)
    row.is_active = request.form.get("is_active", "on") == "on"
    db.session.add(row)
    try:
        db.session.commit()
        audit("Incident Settings Updated", f"Created incident {kind}: {name}")
        flash(f"{kind.title()} created successfully.", "success")
    except SQLAlchemyError:
        db.session.rollback()
        flash(f"Could not create {kind}. The name may already exist.", "danger")
    return redirect(url_for("admin.incident_settings"))


@admin_bp.route("/incident-settings/<kind>/<int:row_id>/update", methods=["POST"])
def incident_lookup_update(kind, row_id):
    model = incident_lookup_model(kind)
    if not model:
        abort(404)
    row = model.query.get_or_404(row_id)
    name = request.form.get("name", "").strip()
    if not name:
        flash("Name is required.", "danger")
        return redirect(url_for("admin.incident_settings"))
    row.name = name
    if hasattr(row, "description"):
        row.description = request.form.get("description", "").strip()
    if hasattr(row, "color") and request.form.get("color"):
        row.color = request.form.get("color")
    row.sort_order = int(request.form.get("sort_order") or 0)
    row.is_active = request.form.get("is_active", "on") == "on"
    try:
        db.session.commit()
        audit("Incident Settings Updated", f"Updated incident {kind}: {name}")
        flash(f"{kind.title()} updated successfully.", "success")
    except SQLAlchemyError:
        db.session.rollback()
        flash(f"Could not update {kind}. The name may already exist.", "danger")
    return redirect(url_for("admin.incident_settings"))


@admin_bp.route("/incident-settings/<kind>/<int:row_id>/delete", methods=["POST"])
def incident_lookup_delete(kind, row_id):
    model = incident_lookup_model(kind)
    if not model:
        abort(404)
    row = model.query.get_or_404(row_id)
    name = row.name
    referenced = False
    if kind == "category":
        referenced = IncidentReport.query.filter_by(category_id=row.id).first() is not None
    elif kind == "severity":
        referenced = IncidentReport.query.filter_by(severity_id=row.id).first() is not None

    try:
        if referenced:
            row.is_active = False
            message = f"{kind.title()} is used by existing reports, so it was deactivated safely."
        else:
            db.session.delete(row)
            message = f"{kind.title()} deleted successfully."
        db.session.commit()
        audit("Incident Settings Updated", f"Deleted/deactivated incident {kind}: {name}")
        flash(message, "success")
    except SQLAlchemyError:
        db.session.rollback()
        flash(f"Could not delete {kind}. It was not changed.", "danger")
    return redirect(url_for("admin.incident_settings"))
