from flask import Blueprint, jsonify, render_template, request

from .models import Exam, Student
from .services import get_settings, result_payload

public_bp = Blueprint("public", __name__)


@public_bp.route("/")
def portal():
    return render_template("portal.html", settings=get_settings())


@public_bp.route("/result", methods=["POST"])
def result():
    student_id = request.form.get("student_id", "").strip()
    student = Student.query.filter_by(student_code=student_id, is_active=True).first()
    if not student:
        return render_template("portal.html", settings=get_settings(), error="Ma jiro Student ID-ga aad gelisay.")
    if student.is_result_locked:
        return render_template("locked_result.html", settings=get_settings(), student=student)
    exam = Exam.query.filter_by(academic_year_id=student.academic_year_id, is_published=True).order_by(Exam.id.desc()).first()
    payload = result_payload(student, exam=exam, public_only=True)
    if not payload["subjects"]:
        return render_template("portal.html", settings=get_settings(), error="Natiijada ardaygan wali lama daabicin.")
    return render_template("portal.html", settings=get_settings(), result=payload)


@public_bp.route("/print/<student_code>")
def print_report(student_code):
    student = Student.query.filter_by(student_code=student_code, is_active=True).first_or_404()
    if student.is_result_locked:
        return render_template("locked_result.html", settings=get_settings(), student=student), 403
    exam = Exam.query.filter_by(academic_year_id=student.academic_year_id, is_published=True).order_by(Exam.id.desc()).first_or_404()
    payload = result_payload(student, exam=exam, public_only=True)
    return render_template("print_report.html", result=payload)


@public_bp.route("/api/results/<student_code>")
def api_result(student_code):
    student = Student.query.filter_by(student_code=student_code, is_active=True).first()
    if not student:
        return jsonify({"ok": False, "message": "Student ID not found."}), 404
    if student.is_result_locked:
        return jsonify({"ok": False, "locked": True, "message": "Result temporarily withheld.", "reason": student.lock_reason}), 423
    exam = Exam.query.filter_by(academic_year_id=student.academic_year_id, is_published=True).order_by(Exam.id.desc()).first()
    if not exam:
        return jsonify({"ok": False, "message": "No published result."}), 404
    payload = result_payload(student, exam=exam, public_only=True)
    return jsonify(
        {
            "ok": True,
            "student": {
                "id": student.student_code,
                "name": student.full_name,
                "mother_name": student.mother_name,
                "class": student.school_class.name,
                "academic_year": student.academic_year.name,
            },
            "exam": payload["exam"].name if payload["exam"] else None,
            "subjects": payload["subjects"],
            "total": payload["total"],
            "average": payload["average"],
            "status": payload["status"],
            "grade": payload["overall_grade"],
        }
    )
