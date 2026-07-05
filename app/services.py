from decimal import Decimal

from .models import GradeScale, Result, Setting


DEFAULT_SETTINGS = {
    "school_name": "Taysir Schools",
    "school_address": "Mogadishu, Somalia",
    "school_phone": "+252",
    "school_email": "info@example.com",
    "school_website": "https://example.com",
    "school_motto": "Excellence through knowledge",
    "principal_name": "Principal",
    "school_footer": "Prepared by the Examination Office",
    "logo_path": "",
    "admin_logo_path": "",
    "dashboard_title": "School Result Management",
    "dashboard_subtitle": "Academic results, publishing, and student records in one secure workspace.",
    "dashboard_theme": "light",
    "primary_color": "#002060",
    "secondary_color": "#007bff",
    "sidebar_color": "#001a4d",
    "dashboard_background": "",
    "visible_cards": "students,classes,exams,published,subjects,locked",
    "homepage_widgets": "search,quick_links,social",
    "default_language": "en",
    "whatsapp_url": "",
    "facebook_url": "",
    "instagram_url": "",
    "telegram_url": "",
    "twitter_url": "",
    "email_url": "mailto:info@example.com",
    "call_url": "tel:+252",
    "maps_url": "",
    "principal_signature_path": "",
    "vice_principal_signature_path": "",
    "exam_officer_signature_path": "",
    "passing_mark": "50",
    "enable_phone_verification": "off",
    "report_header_style": "classic",
    "report_footer_text": "",
    "report_primary_color": "#002060",
    "report_accent_color": "#007bff",
    "report_font_family": "Segoe UI",
    "report_border_style": "rounded",
    "report_background": "#f8fbff",
    "report_watermark": "",
    "report_logo_position": "left",
    "report_qr_position": "right",
    "report_photo_position": "left",
    "report_signature_position": "bottom",
    "report_comment_box": "highlighted",
    "report_table_style": "striped",
    "principal_comment": "",
    "school_stamp_path": "",
    "attendance_color_present": "#16a34a",
    "attendance_color_absent": "#dc2626",
    "attendance_color_late": "#f59e0b",
    "attendance_color_excused": "#2563eb",
    "attendance_color_medical_leave": "#7c3aed",
    "attendance_color_blocked": "#111827",
    "attendance_icon_present": "fa-circle-check",
    "attendance_icon_absent": "fa-circle-xmark",
    "attendance_icon_late": "fa-clock",
    "attendance_icon_excused": "fa-file-circle-check",
    "attendance_icon_medical_leave": "fa-kit-medical",
    "attendance_icon_blocked": "fa-ban",
    "id_card_size": "cr80",
    "id_card_orientation": "portrait",
    "id_card_template": "classic",
    "id_card_background": "#ffffff",
    "id_card_primary_color": "#002060",
    "id_card_accent_color": "#007bff",
    "id_card_font_family": "Segoe UI",
    "id_card_border_style": "solid",
    "id_card_rounded_corners": "on",
    "id_card_logo_position": "left",
    "id_card_photo_position": "left",
    "id_card_qr_position": "right",
    "id_card_icon_style": "solid",
    "id_card_label_style": "uppercase",
    "id_card_spacing": "comfortable",
    "id_card_print_margin": "8",
    "id_card_show_barcode": "off",
    "id_card_header_text": "KAARKA OGOLAANSHAHA IMTIXAANKA",
    "id_card_footer": "Fadlan kaadhkan haddii aad hesho la xidhiidh:",
    "id_card_found_contact_text": "Fadlan kaadhkan haddii aad hesho la xidhiidh:",
    "id_card_exam_type": "Examination Office",
    "id_card_watermark": "",
    "id_card_signature_text": "",
    "id_card_issue_months": "12",
    "id_card_office_signature": "Office Examination Signature",
    "id_card_stamp_text": "School Stamp",
    "result_page_primary_color": "#002060",
    "result_page_accent_color": "#007bff",
    "result_table_style": "striped",
    "result_card_style": "soft",
    "result_button_style": "filled",
    "result_icon_style": "solid",
}


def get_settings():
    rows = Setting.query.all()
    settings = DEFAULT_SETTINGS.copy()
    settings.update({row.key: row.value for row in rows})
    return settings


SUBJECT_ICON_DEFAULTS = {
    "math": "fa-calculator",
    "mathematics": "fa-calculator",
    "physics": "fa-atom",
    "chemistry": "fa-flask-vial",
    "biology": "fa-dna",
    "business": "fa-briefcase",
    "technology": "fa-microchip",
    "history": "fa-landmark",
    "geography": "fa-earth-africa",
    "islamic": "fa-mosque",
    "islamic studies": "fa-mosque",
    "arabic": "fa-language",
    "somali": "fa-book-open-reader",
    "english": "fa-spell-check",
}


def subject_icon(subject_name, settings=None):
    settings = settings or get_settings()
    key = f"subject_icon_{slug(subject_name)}"
    uploaded = settings.get(key)
    if uploaded:
        return {"type": "image", "value": uploaded}
    normalized = (subject_name or "").strip().lower()
    for needle, icon in SUBJECT_ICON_DEFAULTS.items():
        if needle in normalized:
            return {"type": "fa", "value": icon}
    return {"type": "fa", "value": "fa-book"}


def slug(value):
    return "".join(ch.lower() if ch.isalnum() else "_" for ch in str(value or "")).strip("_")


def grade_for(score):
    scale = (
        GradeScale.query.filter(GradeScale.min_score <= score, GradeScale.max_score >= score)
        .order_by(GradeScale.min_score.desc())
        .first()
    )
    if scale:
        return {"grade": scale.grade, "comment": scale.comment}
    return {"grade": "F", "comment": "Needs improvement"}


def result_payload(student, exam=None, public_only=True):
    query = Result.query.filter_by(student_id=student.id)
    if exam:
        query = query.filter_by(exam_id=exam.id)
    if public_only:
        query = query.join(Result.exam).filter(Result.is_published.is_(True))
    rows = query.join(Result.subject).order_by(Result.subject_id.asc()).all()
    if exam and not exam.is_published and public_only:
        rows = []

    total = sum(Decimal(row.score) for row in rows)
    max_total = sum(Decimal(row.subject.max_score) for row in rows) or Decimal("0")
    average = (total / max_total * 100) if max_total else Decimal("0")
    settings = get_settings()
    passing = Decimal(settings.get("passing_mark") or "50")
    status = "Gudbay" if average >= passing else "Haray"
    overall = grade_for(average)

    subject_rows = []
    for row in rows:
        percentage = Decimal(row.score) / Decimal(row.subject.max_score) * 100 if row.subject.max_score else 0
        automatic_grade = grade_for(percentage)
        displayed_grade = {
            "grade": row.grade_override or automatic_grade["grade"],
            "comment": row.comment or automatic_grade["comment"],
        }
        subject_rows.append(
            {
                "id": row.id,
                "subject": row.subject.name.strip(),
                "score": float(row.score),
                "max_score": float(row.subject.max_score),
                "grade": displayed_grade,
                "automatic_grade": automatic_grade,
                "status": "Pass" if percentage >= passing else "Needs Support",
                "percentage": float(round(percentage, 2)),
                "icon": subject_icon(row.subject.name, settings),
            }
        )

    rank = None
    if rows:
        peers = {}
        peer_rows = Result.query.filter_by(exam_id=rows[0].exam_id).all()
        for peer in peer_rows:
            peers.setdefault(peer.student_id, {"total": Decimal("0"), "max": Decimal("0")})
            peers[peer.student_id]["total"] += Decimal(peer.score)
            peers[peer.student_id]["max"] += Decimal(peer.subject.max_score)
        ordered = sorted(
            ((sid, data["total"] / data["max"] * 100 if data["max"] else Decimal("0")) for sid, data in peers.items()),
            key=lambda item: item[1],
            reverse=True,
        )
        for index, (sid, _avg) in enumerate(ordered, start=1):
            if sid == student.id:
                rank = index
                break

    return {
        "student": student,
        "exam": exam or (rows[0].exam if rows else None),
        "subjects": subject_rows,
        "total": float(total),
        "max_total": float(max_total),
        "average": float(round(average, 2)),
        "status": status,
        "overall_grade": overall,
        "rank": rank,
        "comment": automatic_comment(average),
        "settings": settings,
    }


def automatic_comment(average):
    if average >= 90:
        return "Masha Allah! Waxaad gaadhay heer sare oo tusaale u ah dedaalka iyo kartida wanaagsan."
    if average >= 75:
        return "Waxaad si wanaagsan u muujisay faham qoto dheer. Sii wad dadaalkaaga."
    if average >= 50:
        return "Waxaad muujisay dadaal muuqda. Xoogga saar meelaha u baahan horumar."
    return "Ha niyad jabin. La shaqee macallimiinta, joogtee akhriska, hana quusan."
