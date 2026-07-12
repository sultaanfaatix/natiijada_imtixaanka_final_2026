import io
from datetime import datetime

from flask import Blueprint, abort, flash, jsonify, make_response, redirect, render_template, request, url_for
from flask_login import current_user
from openpyxl import Workbook
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4, landscape
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.platypus import Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle

from . import db
from .teacher_analytics import (
    classes_cards,
    comparison_data,
    dashboard_summary,
    exam_analysis_data,
    filter_options,
    generate_ai_insights,
    grade_distribution_data,
    pass_fail_analysis_data,
    performance_trends_data,
    report_summary,
    student_analysis_data,
    subject_analysis_data,
    subjects_cards,
    top_performers_data,
    validate_filter_ids,
    weak_students_data,
)
from .teacher_portal import (
    get_current_teacher,
    is_teacher_account,
    parse_teacher_filters,
    record_teacher_visit,
    teacher_can,
    teacher_login_required,
    teacher_nav_items,
    teacher_permission_required,
    teacher_theme,
)
from .teacher_services import get_teacher_settings, log_teacher_activity

teacher_portal_bp = Blueprint("teacher_portal", __name__)


@teacher_portal_bp.before_request
def protect_teacher_portal():
    if request.endpoint and request.endpoint.startswith("teacher_portal."):
        if request.endpoint == "teacher_portal.login_redirect":
            return None
        if not current_user.is_authenticated:
            return redirect(url_for("auth.login", next=request.url))
        if not is_teacher_account():
            if current_user.role in ("super_admin", "admin"):
                flash("Admin accounts should use the admin portal.", "warning")
                return redirect(url_for("admin.dashboard"))
            flash("This area is only available to teacher accounts.", "danger")
            return redirect(url_for("auth.login"))


def _ctx(teacher, filters, page_title, active_endpoint):
    options = filter_options(teacher, filters)
    return {
        "teacher": teacher,
        "filters": filters,
        "filter_options": options,
        "page_title": page_title,
        "active_endpoint": active_endpoint,
        "nav_items": teacher_nav_items(),
        "teacher_can": teacher_can,
        "teacher_theme": teacher_theme(),
        "teacher_settings": get_teacher_settings(),
    }


@teacher_portal_bp.route("/")
@teacher_login_required
@teacher_permission_required("view_examination_results")
def dashboard():
    teacher = get_current_teacher()
    filters = validate_filter_ids(teacher, parse_teacher_filters(request.args))
    record_teacher_visit(teacher, "Dashboard")
    ctx = _ctx(teacher, filters, "Teacher Analysis Dashboard", "teacher_portal.dashboard")
    ctx["summary"] = dashboard_summary(teacher, filters)
    db.session.commit()
    return render_template("teacher/dashboard.html", **ctx)


@teacher_portal_bp.route("/subjects")
@teacher_login_required
@teacher_permission_required("view_assigned_subjects")
def subjects():
    teacher = get_current_teacher()
    filters = validate_filter_ids(teacher, parse_teacher_filters(request.args))
    record_teacher_visit(teacher, "My Subjects")
    ctx = _ctx(teacher, filters, "My Subjects", "teacher_portal.subjects")
    ctx["cards"] = subjects_cards(teacher, filters)
    db.session.commit()
    return render_template("teacher/subjects.html", **ctx)


@teacher_portal_bp.route("/classes")
@teacher_login_required
@teacher_permission_required("view_assigned_classes")
def classes():
    teacher = get_current_teacher()
    filters = validate_filter_ids(teacher, parse_teacher_filters(request.args))
    record_teacher_visit(teacher, "My Classes")
    ctx = _ctx(teacher, filters, "My Classes", "teacher_portal.classes")
    ctx["cards"] = classes_cards(teacher, filters)
    db.session.commit()
    return render_template("teacher/classes.html", **ctx)


@teacher_portal_bp.route("/exam-analysis")
@teacher_login_required
@teacher_permission_required("view_examination_results")
def exam_analysis():
    teacher = get_current_teacher()
    filters = validate_filter_ids(teacher, parse_teacher_filters(request.args))
    record_teacher_visit(teacher, "Exam Analysis")
    ctx = _ctx(teacher, filters, "Exam Analysis", "teacher_portal.exam_analysis")
    ctx["analysis"] = exam_analysis_data(teacher, filters)
    db.session.commit()
    return render_template("teacher/exam_analysis.html", **ctx)


@teacher_portal_bp.route("/subject-analysis")
@teacher_login_required
@teacher_permission_required("subject_analysis")
def subject_analysis():
    teacher = get_current_teacher()
    filters = validate_filter_ids(teacher, parse_teacher_filters(request.args))
    record_teacher_visit(teacher, "Subject Analysis")
    ctx = _ctx(teacher, filters, "Subject Analysis", "teacher_portal.subject_analysis")
    ctx["analysis"] = subject_analysis_data(teacher, filters)
    db.session.commit()
    return render_template("teacher/subject_analysis.html", **ctx)


@teacher_portal_bp.route("/students")
@teacher_login_required
@teacher_permission_required("student_analysis")
def student_analysis():
    teacher = get_current_teacher()
    filters = validate_filter_ids(teacher, parse_teacher_filters(request.args))
    record_teacher_visit(teacher, "Student Analysis")
    ctx = _ctx(teacher, filters, "Student Analysis", "teacher_portal.student_analysis")
    if filters.get("student_id"):
        ctx["analysis"] = student_analysis_data(teacher, filters["student_id"], filters)
        if ctx["analysis"] is None:
            abort(403)
    else:
        ctx["analysis"] = None
    db.session.commit()
    return render_template("teacher/student_analysis.html", **ctx)


@teacher_portal_bp.route("/trends")
@teacher_login_required
@teacher_permission_required("performance_trends")
def trends():
    teacher = get_current_teacher()
    filters = validate_filter_ids(teacher, parse_teacher_filters(request.args))
    record_teacher_visit(teacher, "Performance Trends")
    ctx = _ctx(teacher, filters, "Performance Trends", "teacher_portal.trends")
    ctx["trends"] = performance_trends_data(teacher, filters)
    db.session.commit()
    return render_template("teacher/trends.html", **ctx)


@teacher_portal_bp.route("/grades")
@teacher_login_required
@teacher_permission_required("grade_distribution")
def grades():
    teacher = get_current_teacher()
    filters = validate_filter_ids(teacher, parse_teacher_filters(request.args))
    record_teacher_visit(teacher, "Grade Distribution")
    ctx = _ctx(teacher, filters, "Grade Distribution", "teacher_portal.grades")
    ctx["distribution"] = grade_distribution_data(teacher, filters)
    db.session.commit()
    return render_template("teacher/grades.html", **ctx)


@teacher_portal_bp.route("/pass-fail")
@teacher_login_required
@teacher_permission_required("grade_distribution")
def pass_fail():
    teacher = get_current_teacher()
    filters = validate_filter_ids(teacher, parse_teacher_filters(request.args))
    record_teacher_visit(teacher, "Pass / Fail Analysis")
    ctx = _ctx(teacher, filters, "Pass / Fail Analysis", "teacher_portal.pass_fail")
    ctx["analysis"] = pass_fail_analysis_data(teacher, filters)
    db.session.commit()
    return render_template("teacher/pass_fail.html", **ctx)


@teacher_portal_bp.route("/top-performers")
@teacher_login_required
@teacher_permission_required("top_performers")
def top_performers():
    teacher = get_current_teacher()
    filters = validate_filter_ids(teacher, parse_teacher_filters(request.args))
    record_teacher_visit(teacher, "Top Performers")
    ctx = _ctx(teacher, filters, "Top Performers", "teacher_portal.top_performers")
    ctx["data"] = top_performers_data(teacher, filters)
    db.session.commit()
    return render_template("teacher/top_performers.html", **ctx)


@teacher_portal_bp.route("/weak-students")
@teacher_login_required
@teacher_permission_required("weak_students")
def weak_students():
    teacher = get_current_teacher()
    filters = validate_filter_ids(teacher, parse_teacher_filters(request.args))
    record_teacher_visit(teacher, "Weak Students")
    ctx = _ctx(teacher, filters, "Weak Students", "teacher_portal.weak_students")
    ctx["data"] = weak_students_data(teacher, filters)
    db.session.commit()
    return render_template("teacher/weak_students.html", **ctx)


@teacher_portal_bp.route("/comparison")
@teacher_login_required
@teacher_permission_required("exam_comparison")
def comparison():
    teacher = get_current_teacher()
    filters = validate_filter_ids(teacher, parse_teacher_filters(request.args))
    record_teacher_visit(teacher, "Comparison")
    ctx = _ctx(teacher, filters, "Comparison", "teacher_portal.comparison")
    ctx["comparison"] = comparison_data(teacher, filters)
    db.session.commit()
    return render_template("teacher/comparison.html", **ctx)


@teacher_portal_bp.route("/reports")
@teacher_login_required
@teacher_permission_required("reports")
def reports():
    teacher = get_current_teacher()
    filters = validate_filter_ids(teacher, parse_teacher_filters(request.args))
    record_teacher_visit(teacher, "Reports")
    ctx = _ctx(teacher, filters, "Reports", "teacher_portal.reports")
    ctx["report"] = report_summary(teacher, filters)
    db.session.commit()
    return render_template("teacher/reports.html", **ctx)


@teacher_portal_bp.route("/ai-insights")
@teacher_login_required
@teacher_permission_required("ai_insights")
def ai_insights():
    teacher = get_current_teacher()
    filters = validate_filter_ids(teacher, parse_teacher_filters(request.args))
    record_teacher_visit(teacher, "AI Insights")
    ctx = _ctx(teacher, filters, "AI Insights", "teacher_portal.ai_insights")
    ctx["insights"] = generate_ai_insights(teacher, filters)
    db.session.commit()
    return render_template("teacher/ai_insights.html", **ctx)


@teacher_portal_bp.route("/settings", methods=["GET", "POST"])
@teacher_login_required
def settings():
    from .models import Setting

    teacher = get_current_teacher()
    filters = validate_filter_ids(teacher, parse_teacher_filters(request.args))
    settings_data = get_teacher_settings()
    if request.method == "POST":
        theme = request.form.get("teacher_theme", "light")
        if theme in ("light", "dark"):
            row = db.session.get(Setting, "teacher_theme")
            if not row:
                row = Setting(key="teacher_theme", value=theme)
                db.session.add(row)
            else:
                row.value = theme
            log_teacher_activity(teacher, "Settings", f"Updated theme to {theme}")
            db.session.commit()
            flash("Settings saved.", "success")
            return redirect(url_for("teacher_portal.settings"))
    ctx = _ctx(teacher, filters, "Settings", "teacher_portal.settings")
    ctx["settings_data"] = settings_data
    return render_template("teacher/settings.html", **ctx)


@teacher_portal_bp.route("/api/filter-options")
@teacher_login_required
def api_filter_options():
    teacher = get_current_teacher()
    filters = validate_filter_ids(teacher, parse_teacher_filters(request.args))
    options = filter_options(teacher, filters)
    return jsonify(
        {
            "academic_years": [{"id": year.id, "name": year.name} for year in options["academic_years"]],
            "exams": [{"id": exam.id, "name": exam.name} for exam in options["exams"]],
            "subjects": [{"id": subject.id, "name": subject.name} for subject in options["subjects"]],
            "classes": [{"id": school_class.id, "name": school_class.name} for school_class in options["classes"]],
            "sections": options["sections"],
            "students": [{"id": student.id, "name": student.full_name, "code": student.student_code} for student in options["students"]],
        }
    )


@teacher_portal_bp.route("/reports/export/excel")
@teacher_login_required
@teacher_permission_required("download_reports")
def export_excel():
    teacher = get_current_teacher()
    filters = validate_filter_ids(teacher, parse_teacher_filters(request.args))
    report = report_summary(teacher, filters)
    workbook = Workbook()
    sheet = workbook.active
    sheet.title = "Teacher Summary"
    sheet.append(["Teacher Analysis Report", teacher.full_name, datetime.utcnow().strftime("%Y-%m-%d %H:%M")])
    sheet.append([])
    sheet.append(["Metric", "Value"])
    for key, value in report["dashboard"].items():
        if key not in ("trends", "chart_labels", "chart_values"):
            sheet.append([key.replace("_", " ").title(), value])
    sheet.append([])
    sheet.append(["Subject", "Average", "Pass Rate"])
    for card in report["subjects"]:
        sheet.append([card["subject"].name, card["average"], card["pass_rate"]])
    log_teacher_activity(teacher, "Download", "Exported Excel report")
    db.session.commit()
    output = io.BytesIO()
    workbook.save(output)
    output.seek(0)
    response = make_response(output.read())
    response.headers["Content-Type"] = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    response.headers["Content-Disposition"] = f'attachment; filename=teacher-report-{teacher.teacher_code}.xlsx'
    return response


@teacher_portal_bp.route("/reports/export/pdf")
@teacher_login_required
@teacher_permission_required("download_reports")
def export_pdf():
    teacher = get_current_teacher()
    filters = validate_filter_ids(teacher, parse_teacher_filters(request.args))
    report = report_summary(teacher, filters)
    buffer = io.BytesIO()
    doc = SimpleDocTemplate(buffer, pagesize=landscape(A4), rightMargin=36, leftMargin=36, topMargin=36, bottomMargin=24)
    styles = getSampleStyleSheet()
    title_style = ParagraphStyle("Title", parent=styles["Heading1"], textColor=colors.HexColor("#002060"))
    story = [
        Paragraph("Teacher Analysis Report", title_style),
        Paragraph(f"{teacher.full_name} ({teacher.teacher_code})", styles["Normal"]),
        Spacer(1, 0.2 * inch),
    ]
    rows = [["Metric", "Value"]]
    for key, value in report["dashboard"].items():
        if key not in ("trends", "chart_labels", "chart_values"):
            rows.append([key.replace("_", " ").title(), str(value)])
    table = Table(rows, colWidths=[3 * inch, 2 * inch])
    table.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#002060")),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
                ("GRID", (0, 0), (-1, -1), 0.5, colors.grey),
                ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
            ]
        )
    )
    story.append(table)
    story.append(Spacer(1, 0.2 * inch))
    story.append(Paragraph("AI Insights", styles["Heading2"]))
    for insight in report["insights"]:
        story.append(Paragraph(f"• {insight}", styles["Normal"]))
    doc.build(story)
    log_teacher_activity(teacher, "Report Generated", "Exported PDF report")
    db.session.commit()
    buffer.seek(0)
    response = make_response(buffer.read())
    response.headers["Content-Type"] = "application/pdf"
    response.headers["Content-Disposition"] = f'attachment; filename=teacher-report-{teacher.teacher_code}.pdf'
    return response


@teacher_portal_bp.route("/reports/print")
@teacher_login_required
@teacher_permission_required("reports")
def print_report():
    teacher = get_current_teacher()
    filters = validate_filter_ids(teacher, parse_teacher_filters(request.args))
    ctx = _ctx(teacher, filters, "Printable Report", "teacher_portal.reports")
    ctx["report"] = report_summary(teacher, filters)
    ctx["generated_at"] = datetime.utcnow()
    return render_template("teacher/print_report.html", **ctx)
