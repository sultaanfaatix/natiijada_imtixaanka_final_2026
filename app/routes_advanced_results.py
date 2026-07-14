from collections import defaultdict
from decimal import Decimal
from tempfile import NamedTemporaryFile

from flask import Blueprint, abort, flash, redirect, render_template, request, send_file, url_for
from flask_login import login_required
from openpyxl import Workbook
from sqlalchemy import or_

from . import db
from .audit import audit
from .models import AcademicYear, Exam, Result, SchoolClass, Student, Subject
from .permissions import enforce_endpoint_permission
from .services import get_settings, grade_for, result_payload

advanced_results_bp = Blueprint("admin_advanced_results", __name__)


@advanced_results_bp.before_request
@login_required
def require_login():
    enforce_endpoint_permission()


@advanced_results_bp.route("/")
def dashboard():
    filters = result_filters()
    rows = result_query(filters).order_by(Result.updated_at.desc()).limit(1000).all()
    student_ids = sorted({row.student_id for row in rows})
    exams = Exam.query.order_by(Exam.id.desc()).all()
    payloads = []
    for student_id in student_ids:
        student = db.session.get(Student, student_id)
        exam = db.session.get(Exam, filters["exam_id"]) if filters["exam_id"] else (rows[0].exam if rows else None)
        if student and exam:
            payloads.append(result_payload(student, exam=exam, public_only=False))
    stats = build_stats(payloads, rows)
    grouped = group_results(rows)
    return render_template(
        "admin/advanced_results.html",
        rows=rows,
        grouped=grouped,
        filters=filters,
        stats=stats,
        years=AcademicYear.query.order_by(AcademicYear.name.desc()).all(),
        exams=exams,
        classes=SchoolClass.query.order_by(SchoolClass.name).all(),
        subjects=Subject.query.order_by(Subject.sort_order, Subject.name).all(),
        levels=distinct_values(Student.level),
        sections=distinct_values(Student.section),
        settings=get_settings(),
    )


@advanced_results_bp.route("/bulk", methods=["POST"])
def bulk():
    ids = [int(value) for value in request.form.getlist("result_ids") if value.isdigit()]
    action = request.form.get("action", "")
    if not ids:
        flash("Select result rows first.", "warning")
        return redirect(url_for("admin_advanced_results.dashboard"))
    rows = Result.query.filter(Result.id.in_(ids)).all()
    if action == "publish":
        for row in rows:
            row.is_published = True
        audit("Result Publishing", f"Bulk published {len(rows)} result rows")
    elif action == "unpublish":
        for row in rows:
            row.is_published = False
        audit("Result Publishing", f"Bulk unpublished {len(rows)} result rows")
    elif action == "lock":
        for row in rows:
            row.student.is_result_locked = True
            row.student.lock_reason = "Locked from advanced results."
        audit("Result Locking", f"Bulk locked {len(rows)} result rows")
    elif action == "unlock":
        for row in rows:
            row.student.is_result_locked = False
            row.student.lock_reason = ""
        audit("Result Locking", f"Bulk unlocked {len(rows)} result rows")
    elif action == "delete":
        for row in rows:
            db.session.delete(row)
        audit("Result Publishing", f"Bulk deleted {len(rows)} result rows")
    else:
        abort(400)
    db.session.commit()
    flash("Bulk result action completed.", "success")
    return redirect(url_for("admin_advanced_results.dashboard"))


@advanced_results_bp.route("/export.xlsx")
def export_excel():
    filters = result_filters()
    wb = Workbook()
    ws = wb.active
    ws.title = "Advanced Results"
    ws.append(["Academic Year", "Exam", "Level", "Class", "Section", "Student ID", "Student Name", "Subject", "Score", "Published", "Locked"])
    for row in result_query(filters).order_by(Result.updated_at.desc()).all():
        ws.append([
            row.exam.academic_year.name,
            row.exam.name,
            row.student.level or "",
            row.student.school_class.name,
            row.student.section or "",
            row.student.student_code,
            row.student.full_name,
            row.subject.name,
            float(row.score),
            row.is_published,
            row.student.is_result_locked,
        ])
    audit("Result Export", "Exported advanced results")
    db.session.commit()
    tmp = NamedTemporaryFile(delete=False, suffix=".xlsx")
    wb.save(tmp.name)
    tmp.close()
    return send_file(tmp.name, as_attachment=True, download_name="advanced_results.xlsx")


def result_filters():
    return {
        "q": request.args.get("q", "").strip(),
        "year_id": int_or_none(request.args.get("year_id")),
        "exam_id": int_or_none(request.args.get("exam_id")),
        "class_id": int_or_none(request.args.get("class_id")),
        "level": request.args.get("level", "").strip(),
        "section": request.args.get("section", "").strip(),
        "status": request.args.get("status", "").strip(),
    }


def result_query(filters):
    query = Result.query.join(Result.student).join(Result.exam).join(Result.subject)
    if filters["q"]:
        q = f"%{filters['q']}%"
        query = query.filter(or_(Student.student_code.like(q), Student.full_name.like(q), Subject.name.like(q)))
    if filters["year_id"]:
        query = query.filter(Exam.academic_year_id == filters["year_id"])
    if filters["exam_id"]:
        query = query.filter(Result.exam_id == filters["exam_id"])
    if filters["class_id"]:
        query = query.filter(Student.class_id == filters["class_id"])
    if filters["level"]:
        query = query.filter(Student.level == filters["level"])
    if filters["section"]:
        query = query.filter(Student.section == filters["section"])
    if filters["status"] == "Published":
        query = query.filter(Result.is_published.is_(True))
    elif filters["status"] == "Locked":
        query = query.filter(Student.is_result_locked.is_(True))
    elif filters["status"] == "Unpublished":
        query = query.filter(Result.is_published.is_(False))
    return query


def group_results(rows):
    grouped = defaultdict(lambda: defaultdict(lambda: defaultdict(lambda: defaultdict(lambda: defaultdict(list)))))
    for row in rows:
        grouped[row.exam.academic_year.name][row.exam.name][row.student.level or "No Level"][row.student.school_class.name][row.student.section or "No Section"].append(row)
    return grouped


def build_stats(payloads, rows):
    averages = [Decimal(str(payload["average"])) for payload in payloads if payload.get("subjects")]
    pass_count = sum(1 for avg in averages if grade_for(avg).get("is_pass"))
    subject_totals = defaultdict(list)
    for row in rows:
        subject_totals[row.subject.name].append(Decimal(row.score) / Decimal(row.subject.max_score) * 100 if row.subject.max_score else Decimal("0"))
    subject_averages = {name: round(sum(values) / len(values), 2) for name, values in subject_totals.items() if values}
    ranked = sorted(payloads, key=lambda item: item.get("average", 0), reverse=True)
    return {
        "rows": len(rows),
        "students": len({row.student_id for row in rows}),
        "published": sum(1 for row in rows if row.is_published),
        "locked": len({row.student_id for row in rows if row.student.is_result_locked}),
        "pass_rate": round(pass_count / len(averages) * 100, 2) if averages else 0,
        "fail_rate": round((len(averages) - pass_count) / len(averages) * 100, 2) if averages else 0,
        "top_students": ranked[:5],
        "lowest_students": list(reversed(ranked[-5:])),
        "subject_averages": subject_averages,
        "exam_average": round(sum(averages) / len(averages), 2) if averages else 0,
    }


def distinct_values(column):
    return [value[0] for value in db.session.query(column).filter(column.isnot(None), column != "").distinct().order_by(column).all()]


def int_or_none(value):
    return int(value) if value and str(value).isdigit() else None
