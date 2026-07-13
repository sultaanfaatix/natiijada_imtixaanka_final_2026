from datetime import date, datetime

from flask import Blueprint, jsonify, redirect, render_template, request, url_for
from flask_login import current_user, login_required
from sqlalchemy import func

from . import db
from .i18n import language_redirect
from .models import AcademicYear, Exam, IdCardIssue, IncidentAction, IncidentCategory, IncidentReport, ReportVerification, SeverityLevel, Student, Subject
from .services import get_settings, result_payload
from .verification import verification_payload

public_bp = Blueprint("public", __name__)


@public_bp.route("/")
def portal():
    return render_template("portal.html", settings=get_settings())


@public_bp.route("/language/<lang>")
def set_language(lang):
    return language_redirect(lang)


# =========================
# RESULT SUBMIT (MAIN FIX)
# =========================
@public_bp.route("/result", methods=["POST"])
def result():
    student_id = request.form.get("student_id", "").strip()
    settings = get_settings()
    phone = request.form.get("phone", "").strip()

    student = Student.query.filter(
        func.trim(Student.student_code) == student_id
    ).first()

    if not student:
        return render_template(
            "portal.html",
            settings=get_settings(),
            error="Ma jiro Student ID-ga aad gelisay."
        )

    if settings.get("enable_phone_verification") == "on":
        if not phone or (student.phone or "").strip() != phone:
            return render_template(
                "portal.html",
                settings=settings,
                error="Phone number verification failed."
            )

    if student.is_result_locked:
        return render_template(
            "locked_result.html",
            settings=get_settings(),
            student=student
        )

    exam = Exam.query.filter_by(
        academic_year_id=student.academic_year_id,
        is_published=True
    ).order_by(Exam.id.desc()).first()

    payload = result_payload(student, exam=exam, public_only=True)

    if not payload or not payload.get("subjects"):
        return render_template(
            "portal.html",
            settings=get_settings(),
            error="Natiijada ardaygan wali lama daabicin."
        )

    return render_template(
        "portal.html",
        settings=get_settings(),
        result=payload,
        generated_at=datetime.now()
    )


# =========================
# PRINT REPORT
# =========================
@public_bp.route("/print/<student_code>")
def print_report(student_code):
    student_code = student_code.strip()

    student = Student.query.filter(
        func.trim(Student.student_code) == student_code
    ).first_or_404()

    if student.is_result_locked:
        return render_template(
            "locked_result.html",
            settings=get_settings(),
            student=student
        ), 403

    exam = Exam.query.filter_by(
        academic_year_id=student.academic_year_id,
        is_published=True
    ).order_by(Exam.id.desc()).first_or_404()

    payload = result_payload(student, exam=exam, public_only=True)
    payload["verification"] = verification_payload(student, exam)
    payload["generated_at"] = datetime.now()
    db.session.commit()

    return render_template("print_report.html", result=payload)


# =========================
# API ENDPOINT
# =========================
@public_bp.route("/api/results/<student_code>")
def api_result(student_code):
    student_code = student_code.strip()

    student = Student.query.filter(
        func.trim(Student.student_code) == student_code
    ).first()

    if not student:
        return jsonify({"ok": False, "message": "Student ID not found."}), 404

    if student.is_result_locked:
        return jsonify({
            "ok": False,
            "locked": True,
            "message": "Result temporarily withheld.",
            "reason": student.lock_reason
        }), 423

    exam = Exam.query.filter_by(
        academic_year_id=student.academic_year_id,
        is_published=True
    ).order_by(Exam.id.desc()).first()

    if not exam:
        return jsonify({"ok": False, "message": "No published result."}), 404

    payload = result_payload(student, exam=exam, public_only=True)

    return jsonify({
        "ok": True,
        "student": {
            "id": student.student_code,
            "name": student.full_name,
            "mother_name": student.mother_name,
            "class": student.school_class.name,
            "academic_year": student.academic_year.name,
        },
        "exam": payload["exam"].name if payload.get("exam") else None,
        "subjects": payload["subjects"],
        "total": payload["total"],
        "average": payload["average"],
        "status": payload["status"],
        "grade": payload["overall_grade"],
    })


@public_bp.route("/verify/<token>")
def verify_report(token):
    settings = get_settings()
    if settings.get("verify_page_enabled") != "on":
        return render_template("verify.html", settings=settings, verified=False, disabled=True), 403
    record = ReportVerification.query.filter_by(token=token, is_valid=True).first()
    if not record:
        return render_template("verify.html", settings=settings, verified=False), 404
    payload = result_payload(record.student, exam=record.exam, public_only=True)
    return render_template("verify.html", settings=settings, verified=True, result=payload, verification=record)


@public_bp.route("/verify-id/<token>")
def verify_id_card(token):
    settings = get_settings()
    issue = IdCardIssue.query.filter_by(token=token).first()
    if not issue:
        return render_template("verify_id.html", settings=settings, verified=False), 404
    status = "Expired" if issue.expiry_date and issue.expiry_date < date.today() else issue.status
    return render_template("verify_id.html", settings=settings, verified=True, issue=issue, display_status=status)


@public_bp.route("/qr/<token>")
def qr_landing(token):
    """QR Landing Page with two action cards"""
    settings = get_settings()
    issue = IdCardIssue.query.filter_by(token=token).first()
    if not issue:
        return render_template("qr_landing.html", settings=settings, token=token, student=None), 404
    return render_template("qr_landing.html", settings=settings, token=token, student=issue.student)


@public_bp.route("/incident-report/<token>", methods=["GET", "POST"])
@login_required
def incident_report_form(token):
    """Incident Report Form - Requires authentication"""
    settings = get_settings()
    issue = IdCardIssue.query.filter_by(token=token).first()
    
    if not issue:
        return render_template("qr_landing.html", settings=settings, token=token, student=None), 404
    
    student = issue.student
    
    # Check if user has permission (admin or staff)
    if not current_user.is_authenticated or current_user.role not in ["super_admin", "admin", "staff"]:
        return render_template("qr_landing.html", settings=settings, token=token, student=student, error="Unauthorized"), 403
    
    if request.method == "POST":
        # Generate report number
        from .models import IncidentReport
        import random
        import string
        
        report_num = f"INC-{datetime.now().strftime('%Y%m%d')}-{''.join(random.choices(string.digits, k=4))}"
        
        # Handle actions taken as comma-separated string from checkboxes
        actions_list = request.form.getlist("actions_taken")
        actions_taken = ", ".join(actions_list) if actions_list else ""
        
        # Create incident report
        report = IncidentReport(
            report_number=report_num,
            student_id=student.id,
            user_id=current_user.id,
            teacher_id=current_user.id if current_user.role in ["super_admin", "admin", "staff"] else None,
            category_id=int(request.form.get("category_id")),
            severity_id=int(request.form.get("severity_id")),
            exam_id=int(request.form.get("exam_id")) if request.form.get("exam_id") else None,
            subject_id=int(request.form.get("subject_id")) if request.form.get("subject_id") else None,
            exam_room=request.form.get("exam_room", ""),
            incident_date=datetime.strptime(request.form.get("incident_date"), "%Y-%m-%d").date(),
            incident_time=datetime.strptime(request.form.get("incident_time"), "%H:%M").time(),
            description=request.form.get("description", ""),
            actions_taken=actions_taken,
            status="Pending Review"
        )
        
        db.session.add(report)
        db.session.commit()
        
        # Handle file uploads if any
        if request.files.getlist("evidence"):
            from .services import upload_image
            for file in request.files.getlist("evidence"):
                if file and file.filename:
                    file_path = upload_image(file, "incident/evidence")
                    from .models import IncidentAttachment
                    attachment = IncidentAttachment(
                        report_id=report.id,
                        file_path=file_path,
                        file_name=file.filename,
                        file_type=file.content_type or "application/octet-stream",
                        file_size=len(file.read()),
                        uploaded_by_id=current_user.id
                    )
                    db.session.add(attachment)
            db.session.commit()
        
        return render_template("incident_success.html", settings=settings, report=report, student=student)
    
    # GET request - show form
    categories = IncidentCategory.query.filter_by(is_active=True).order_by(IncidentCategory.sort_order).all()
    severities = SeverityLevel.query.filter_by(is_active=True).order_by(SeverityLevel.sort_order).all()
    actions = IncidentAction.query.filter_by(is_active=True).order_by(IncidentAction.sort_order).all()
    exams = Exam.query.filter_by(is_published=True).order_by(Exam.id.desc()).all()
    subjects = Subject.query.order_by(Subject.name).all()
    
    # Pre-compute current date/time for form defaults
    current_date = datetime.now().strftime('%Y-%m-%d')
    current_time = datetime.now().strftime('%H:%M')
    
    # Generate preview report number
    import random
    import string
    preview_report_num = f"INC-{datetime.now().strftime('%Y%m%d')}-{''.join(random.choices(string.digits, k=4))}"
    
    return render_template(
        "incident_form.html",
        settings=settings,
        token=token,
        student=student,
        categories=categories,
        severities=severities,
        actions=actions,
        exams=exams,
        subjects=subjects,
        current_date=current_date,
        current_time=current_time,
        preview_report_num=preview_report_num,
        current_user=current_user
    )
