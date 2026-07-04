import secrets
import calendar
from datetime import date
from tempfile import NamedTemporaryFile

from flask import Blueprint, abort, current_app, flash, redirect, render_template, request, send_file, url_for
from flask_login import login_required
from sqlalchemy import or_

from . import db
from .audit import audit
from .models import AcademicYear, IdCardIssue, SchoolClass, Setting, Student
from .permissions import enforce_endpoint_permission
from .services import get_settings
from .verification import id_card_qr_payload

id_cards_bp = Blueprint("admin_id_cards", __name__)


@id_cards_bp.before_request
@login_required
def require_login():
    enforce_endpoint_permission()


@id_cards_bp.route("/", methods=["GET", "POST"])
def dashboard():
    if request.method == "POST":
        editable_keys = [
            "id_card_size", "id_card_orientation", "id_card_background", "id_card_primary_color",
            "id_card_accent_color", "id_card_font_family", "id_card_border_style", "id_card_rounded_corners",
            "id_card_show_barcode", "id_card_footer", "id_card_watermark", "id_card_issue_months",
            "id_card_office_signature", "id_card_stamp_text", "id_card_found_contact_text", "id_card_exam_type",
        ]
        for key in editable_keys:
            setting = db.session.get(Setting, key) or Setting(key=key)
            setting.value = request.form.get(key, "").strip()
            db.session.add(setting)
        audit("Settings Changes", "Updated ID card designer settings")
        db.session.commit()
        flash("ID card designer saved.", "success")
        return redirect(url_for("admin_id_cards.dashboard"))

    filters = card_filters()
    students = filtered_students(filters).order_by(Student.full_name).limit(500).all()
    issues = IdCardIssue.query.order_by(IdCardIssue.updated_at.desc()).limit(200).all()
    return render_template(
        "admin/id_cards.html",
        settings=get_settings(),
        students=students,
        issues=issues,
        filters=filters,
        classes=SchoolClass.query.order_by(SchoolClass.name).all(),
        years=AcademicYear.query.order_by(AcademicYear.name.desc()).all(),
        levels=distinct_values(Student.level),
        sections=distinct_values(Student.section),
    )


@id_cards_bp.route("/generate/<int:student_id>", methods=["POST"])
def generate(student_id):
    student = db.session.get(Student, student_id) or abort(404)
    issue = get_or_create_issue(student)
    audit("ID Card Operations", f"Generated ID card for {student.student_code}")
    db.session.commit()
    flash("ID card generated.", "success")
    return redirect(url_for("admin_id_cards.print_cards", issue_ids=issue.id))


@id_cards_bp.route("/bulk-generate", methods=["POST"])
def bulk_generate():
    scope = request.form.get("scope", "selected")
    ids = [int(value) for value in request.form.getlist("student_ids") if value.isdigit()]
    query = Student.query
    if scope == "class" and request.form.get("class_id"):
        query = query.filter_by(class_id=int(request.form["class_id"]))
        ids = [s.id for s in query.all()]
    elif scope == "level" and request.form.get("level"):
        ids = [s.id for s in query.filter_by(level=request.form["level"].strip()).all()]
    elif scope == "section" and request.form.get("section"):
        ids = [s.id for s in query.filter_by(section=request.form["section"].strip()).all()]
    elif scope == "all":
        ids = [s.id for s in query.all()]
    if not ids:
        flash("Select students or choose a valid bulk scope.", "warning")
        return redirect(url_for("admin_id_cards.dashboard"))
    issue_ids = []
    for student in Student.query.filter(Student.id.in_(ids)).all():
        issue_ids.append(get_or_create_issue(student).id)
    audit("ID Card Operations", f"Bulk generated {len(issue_ids)} ID cards")
    db.session.commit()
    flash(f"Generated {len(issue_ids)} ID cards.", "success")
    return redirect(url_for("admin_id_cards.print_cards", issue_ids=",".join(str(i) for i in issue_ids)))


@id_cards_bp.route("/print")
def print_cards():
    issues = selected_issues()
    cards = [{"issue": issue, "qr": id_card_qr_payload(issue)} for issue in issues]
    return render_template("admin/id_card_print.html", cards=cards, settings=get_settings())


@id_cards_bp.route("/export.pdf")
def export_pdf():
    issues = selected_issues()
    from io import BytesIO
    import qrcode
    from reportlab.lib import colors
    from reportlab.lib.pagesizes import A4
    from reportlab.lib.units import mm
    from reportlab.lib.utils import ImageReader
    from reportlab.pdfgen import canvas

    tmp = NamedTemporaryFile(delete=False, suffix=".pdf")
    pdf = canvas.Canvas(tmp.name, pagesize=A4)
    settings = get_settings()
    page_w, page_h = A4
    margin = 8 * mm
    gap = 4 * mm
    slot_w = (page_w - (2 * margin) - gap) / 2
    slot_h = (page_h - (2 * margin) - (2 * gap)) / 3
    primary = colors.HexColor(settings.get("id_card_primary_color") or "#002060")
    accent = colors.HexColor(settings.get("id_card_accent_color") or "#007bff")

    for index, issue in enumerate(issues):
        slot = index % 6
        if index and slot == 0:
            pdf.showPage()
        col = slot % 2
        row = slot // 2
        x = margin + col * (slot_w + gap)
        y = page_h - margin - (row + 1) * slot_h - row * gap
        draw_id_card_pdf(pdf, issue, settings, x, y, slot_w, slot_h, primary, accent, qrcode, ImageReader, BytesIO)
    if not issues:
        pdf.drawString(margin, page_h - margin, "No ID cards selected.")
    pdf.save()
    audit("ID Card Operations", "Exported ID cards PDF")
    db.session.commit()
    return send_file(tmp.name, as_attachment=True, download_name="student_id_cards.pdf")


def draw_id_card_pdf(pdf, issue, settings, x, y, w, h, primary, accent, qrcode, ImageReader, BytesIO):
    from reportlab.lib import colors
    from reportlab.lib.units import mm

    pdf.setDash(3, 2)
    pdf.setStrokeColor(colors.HexColor("#94a3b8"))
    pdf.rect(x, y, w, h, stroke=1, fill=0)
    pdf.setDash()
    pad = 2.5 * mm
    card_x, card_y = x + pad, y + pad
    card_w, card_h = w - 2 * pad, h - 2 * pad
    pdf.setStrokeColor(primary)
    pdf.setFillColor(colors.white)
    pdf.roundRect(card_x, card_y, card_w, card_h, 8, stroke=1, fill=1)

    header_h = 17 * mm
    pdf.setFillColor(primary)
    pdf.roundRect(card_x, card_y + card_h - header_h, card_w, header_h, 8, stroke=0, fill=1)
    pdf.setFillColor(colors.white)
    logo_x, logo_y = card_x + 3 * mm, card_y + card_h - header_h + 3 * mm
    pdf.roundRect(logo_x, logo_y, 11 * mm, 11 * mm, 4, stroke=0, fill=1)
    pdf.setFillColor(primary)
    pdf.setFont("Helvetica-Bold", 7)
    pdf.drawCentredString(logo_x + 5.5 * mm, logo_y + 4.6 * mm, "LOGO")

    pdf.setFillColor(colors.white)
    pdf.setFont("Helvetica-Bold", 8.5)
    pdf.drawString(card_x + 17 * mm, card_y + card_h - 7 * mm, (settings.get("school_name") or "School")[:34])
    pdf.setFont("Helvetica", 6.5)
    pdf.drawString(card_x + 17 * mm, card_y + card_h - 12 * mm, (settings.get("id_card_exam_type") or "Examination Office")[:34])
    pdf.setFont("Helvetica-Bold", 6.5)
    pdf.drawRightString(card_x + card_w - 3 * mm, card_y + card_h - 8 * mm, issue.academic_year.name[:14])

    body_y = card_y + 13 * mm
    photo_x = card_x + 4 * mm
    photo_y = body_y + 10 * mm
    pdf.setStrokeColor(accent)
    pdf.setFillColor(colors.HexColor("#eef6ff"))
    pdf.roundRect(photo_x, photo_y, 24 * mm, 29 * mm, 6, stroke=1, fill=1)
    if issue.student.photo_path:
        image_path = current_app.static_folder + "/" + issue.student.photo_path.replace("\\", "/")
        try:
            pdf.drawImage(image_path, photo_x + 1, photo_y + 1, 24 * mm - 2, 29 * mm - 2, preserveAspectRatio=True, mask="auto")
        except Exception:
            pass

    info_x = photo_x + 28 * mm
    pdf.setFillColor(primary)
    pdf.setFont("Helvetica-Bold", 10)
    pdf.drawString(info_x, body_y + 33 * mm, issue.student.full_name[:32])
    pdf.setFont("Helvetica", 6)
    pdf.setFillColor(colors.HexColor("#64748b"))
    pdf.drawString(info_x, body_y + 30 * mm, "STUDENT NAME")
    pdf.setFillColor(primary)
    pdf.setFont("Helvetica-Bold", 7)
    pdf.drawString(info_x, body_y + 23 * mm, f"ID: {issue.student.student_code}")
    pdf.drawString(info_x + 30 * mm, body_y + 23 * mm, f"Class: {issue.student.school_class.name[:12]}")
    pdf.drawString(info_x, body_y + 15 * mm, f"Issue: {issue.issue_date}")
    pdf.drawString(info_x + 30 * mm, body_y + 15 * mm, f"Expiry: {issue.expiry_date or ''}")

    qr = qrcode.make(id_card_qr_payload(issue)["url"])
    buffer = BytesIO()
    qr.save(buffer, format="PNG")
    buffer.seek(0)
    qr_size = 18 * mm
    qr_x = card_x + card_w - qr_size - 5 * mm
    qr_y = body_y + 1 * mm
    pdf.setFillColor(colors.HexColor("#f8fbff"))
    pdf.roundRect(qr_x - 2 * mm, qr_y - 2 * mm, qr_size + 4 * mm, qr_size + 5 * mm, 7, stroke=1, fill=1)
    pdf.drawImage(ImageReader(buffer), qr_x, qr_y, qr_size, qr_size)
    pdf.setFont("Helvetica-Bold", 5.5)
    pdf.setFillColor(primary)
    pdf.drawCentredString(qr_x + qr_size / 2, qr_y - 1 * mm, "SCAN TO VERIFY")

    if settings.get("id_card_show_barcode") == "on":
        pdf.setFillColor(colors.black)
        bx = info_x
        by = body_y + 6 * mm
        for n, ch in enumerate(issue.student.student_code[:22]):
            width = 0.4 * mm if ord(ch) % 2 else 0.8 * mm
            pdf.rect(bx + n * 1.15 * mm, by, width, 4 * mm, fill=1, stroke=0)

    footer_h = 10 * mm
    pdf.setFillColor(primary)
    pdf.rect(card_x, card_y, card_w, footer_h, stroke=0, fill=1)
    pdf.setFillColor(colors.white)
    pdf.setFont("Helvetica", 6)
    contact = f"{settings.get('id_card_found_contact_text')} {issue.student.phone or settings.get('school_phone')}"
    pdf.drawCentredString(card_x + card_w / 2, card_y + 3.6 * mm, contact[:95])


def get_or_create_issue(student):
    issue = IdCardIssue.query.filter_by(student_id=student.id, academic_year_id=student.academic_year_id, status="Active").first()
    settings = get_settings()
    months = int(settings.get("id_card_issue_months") or 12)
    if not issue:
        issue = IdCardIssue(
            token=secrets.token_urlsafe(32),
            student=student,
            academic_year=student.academic_year,
            issue_date=date.today(),
            expiry_date=add_months(date.today(), months),
            status="Active",
        )
        db.session.add(issue)
        db.session.flush()
    return issue


def selected_issues():
    raw = request.args.get("issue_ids", "")
    ids = [int(value) for value in raw.split(",") if value.isdigit()]
    if ids:
        return IdCardIssue.query.filter(IdCardIssue.id.in_(ids)).order_by(IdCardIssue.id).all()
    return IdCardIssue.query.order_by(IdCardIssue.updated_at.desc()).limit(50).all()


def card_filters():
    return {
        "q": request.args.get("q", "").strip(),
        "class_id": int_or_none(request.args.get("class_id")),
        "year_id": int_or_none(request.args.get("year_id")),
        "level": request.args.get("level", "").strip(),
        "section": request.args.get("section", "").strip(),
    }


def filtered_students(filters):
    query = Student.query
    if filters["q"]:
        q = f"%{filters['q']}%"
        query = query.filter(or_(Student.student_code.like(q), Student.full_name.like(q), Student.mother_name.like(q)))
    if filters["class_id"]:
        query = query.filter(Student.class_id == filters["class_id"])
    if filters["year_id"]:
        query = query.filter(Student.academic_year_id == filters["year_id"])
    if filters["level"]:
        query = query.filter(Student.level == filters["level"])
    if filters["section"]:
        query = query.filter(Student.section == filters["section"])
    return query


def distinct_values(column):
    return [value[0] for value in db.session.query(column).filter(column.isnot(None), column != "").distinct().order_by(column).all()]


def int_or_none(value):
    return int(value) if value and str(value).isdigit() else None


def add_months(value, months):
    month = value.month - 1 + months
    year = value.year + month // 12
    month = month % 12 + 1
    day = min(value.day, calendar.monthrange(year, month)[1])
    return date(year, month, day)
