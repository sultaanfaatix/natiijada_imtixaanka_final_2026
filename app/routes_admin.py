from .cloudinary_service import upload_image
from datetime import datetime
from pathlib import Path

from flask import Blueprint, abort, flash, redirect, render_template, request, send_file, session, url_for
from flask_login import current_user, login_required
from openpyxl import Workbook
from sqlalchemy import or_

from . import db
from .audit import audit
from .import_wizard import preview_results, preview_students, result_template, student_template
from .models import AcademicYear, AuditLog, Exam, GradeScale, Result, SchoolClass, Setting, Student, Subject, User
from .permissions import PERMISSIONS, can, enforce_endpoint_permission, permission_required
from .security import ALLOWED_PHOTOS, ALLOWED_SHEETS, allowed_file, safe_upload_name
from .services import get_settings, grade_for, result_payload
from .services import slug

admin_bp = Blueprint("admin", __name__)


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
        student.phone = request.form.get("phone", "").strip()
        student.class_id = int(request.form["class_id"])
        student.academic_year_id = int(request.form["academic_year_id"])
        student.level = request.form.get("level", "").strip()
        student.section = request.form.get("section", "").strip()
        student.note = request.form.get("note", "").strip()
        student.is_result_locked = bool(request.form.get("is_result_locked"))
        student.lock_reason = request.form.get("lock_reason", "").strip()
        student.is_active = bool(request.form.get("is_active"))
        photo = request.files.get("photo")
        if photo and photo.filename:
            if not allowed_file(photo.filename, ALLOWED_PHOTOS):
                flash("Photo must be JPG, PNG, or WEBP.", "danger")
                return redirect(request.url)

            photo_url = upload_image(photo, "school/students")
            student.photo_path = photo_url
        db.session.add(student)
        audit("Student Updates", f"Saved student {student.student_code}")
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
    audit("Student Updates", f"Deleted student {student.student_code}")
    db.session.commit()
    flash("Student deleted.", "success")
    return redirect(url_for("admin.students"))


@admin_bp.route("/students/<int:student_id>/toggle-lock", methods=["POST"])
def toggle_student_lock(student_id):
    student = db.session.get(Student, student_id) or abort_404()
    if student.is_result_locked and not can("unlock_results"):
        abort(403)
    if not student.is_result_locked and not can("lock_results"):
        abort(403)
    student.is_result_locked = not student.is_result_locked
    if student.is_result_locked:
        student.lock_reason = request.form.get("lock_reason", "").strip() or "Outstanding clearance required."
        audit("Result Locking", f"Locked result for {student.student_code}")
    else:
        student.lock_reason = ""
        audit("Result Locking", f"Unlocked result for {student.student_code}")
    db.session.commit()
    flash("Result lock status updated.", "success")
    return redirect(url_for("admin.students"))


@admin_bp.route("/students/import", methods=["POST"])
def import_students():
    file = request.files.get("file")
    if not file or not allowed_file(file.filename, ALLOWED_SHEETS):
        flash("Upload an .xlsx file.", "danger")
        return redirect(url_for("admin.students"))
    rows, errors = preview_students(file)
    if not errors:
        session["student_import_rows"] = rows
    audit("Import Operations", f"Previewed student import: {len(rows)} rows, {len(errors)} errors")
    db.session.commit()
    return render_template("admin/import_wizard.html", kind="students", rows=rows, errors=errors, confirm_url=url_for("admin.confirm_student_import"))


@admin_bp.route("/students/import/confirm", methods=["POST"])
def confirm_student_import():
    rows = session.pop("student_import_rows", [])
    if not rows:
        flash("No validated student import is waiting for confirmation.", "warning")
        return redirect(url_for("admin.students"))
    try:
        for data in rows:
            school_class = SchoolClass.query.filter_by(name=data["class"]).one()
            year = AcademicYear.query.filter_by(name=data["academic_year"]).one()
            student = Student.query.filter_by(student_code=data["student_id"]).first() or Student(student_code=data["student_id"])
            student.full_name = data["full_name"]
            student.mother_name = data.get("mother_name", "")
            student.phone = data.get("phone", "")
            student.school_class = school_class
            student.academic_year = year
            student.is_active = True
            db.session.add(student)
        audit("Import Operations", f"Confirmed student import: {len(rows)} rows")
        db.session.commit()
    except Exception:
        db.session.rollback()
        flash("Import failed. No records were saved.", "danger")
        return redirect(url_for("admin.students"))
    flash(f"Imported {len(rows)} students.", "success")
    return redirect(url_for("admin.students"))


@admin_bp.route("/students/import/template")
def student_import_template():
    return workbook_response(student_template(), "student_import_template.xlsx")


@admin_bp.route("/students/export")
def export_students():
    wb = Workbook()
    ws = wb.active
    ws.title = "Students"
    ws.append(["student_id", "full_name", "mother_name", "phone", "class", "academic_year", "active"])
    for s in Student.query.order_by(Student.full_name).all():
        ws.append([s.student_code, s.full_name, s.mother_name, s.phone, s.school_class.name, s.academic_year.name, s.is_active])
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
    audit("Result Publishing", f"Saved results for student {student.student_code} exam {exam.name}")
    db.session.commit()
    flash("Results saved.", "success")
    return redirect(url_for("admin.results"))


@admin_bp.route("/results/<int:result_id>/delete", methods=["POST"])
def delete_result(result_id):
    result = db.session.get(Result, result_id) or abort_404()
    db.session.delete(result)
    audit("Result Publishing", f"Deleted result row {result_id}")
    db.session.commit()
    flash("Result row deleted.", "success")
    return redirect(url_for("admin.results"))


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
        return redirect(url_for("admin.results"))
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
        return redirect(url_for("admin.results"))
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
        return redirect(url_for("admin.results"))
    flash(f"Imported {len(rows)} result rows.", "success")
    return redirect(url_for("admin.results"))


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
            "passing_mark",
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
            grade.min_score = request.form.get(f"min_{grade.id}", grade.min_score)
            grade.max_score = request.form.get(f"max_{grade.id}", grade.max_score)
            grade.comment = request.form.get(f"comment_{grade.id}", grade.comment)
        audit("Settings Changes", "Updated system settings")
        db.session.commit()
        flash("Settings saved.", "success")
        return redirect(url_for("admin.settings"))
    return render_template(
        "admin/settings.html",
        settings=get_settings(),
        scales=GradeScale.query.order_by(GradeScale.min_score.desc()).all(),
        subjects=Subject.query.order_by(Subject.name).all(),
        slug=slug,
    )


@admin_bp.route("/audit-logs")
def audit_logs():
    rows = AuditLog.query.order_by(AuditLog.created_at.desc()).limit(500).all()
    return render_template("admin/audit_logs.html", rows=rows)


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
