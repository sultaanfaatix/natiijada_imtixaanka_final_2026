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
}


def get_settings():
    rows = Setting.query.all()
    settings = DEFAULT_SETTINGS.copy()
    settings.update({row.key: row.value for row in rows})
    return settings


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
        subject_rows.append(
            {
                "id": row.id,
                "subject": row.subject.name.strip(),
                "score": float(row.score),
                "max_score": float(row.subject.max_score),
                "grade": grade_for(percentage),
                "status": "Pass" if percentage >= passing else "Needs Support",
                "percentage": float(round(percentage, 2)),
            }
        )

    return {
        "student": student,
        "exam": exam or (rows[0].exam if rows else None),
        "subjects": subject_rows,
        "total": float(total),
        "max_total": float(max_total),
        "average": float(round(average, 2)),
        "status": status,
        "overall_grade": overall,
        "comment": student.note or automatic_comment(average),
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
