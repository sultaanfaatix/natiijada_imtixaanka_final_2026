from functools import wraps

from flask import abort, flash, redirect, request, url_for
from flask_login import current_user

from .teacher_services import TEACHER_PERMISSIONS, get_teacher_settings, log_teacher_activity, teacher_permission_set


def get_current_teacher():
    if not current_user.is_authenticated:
        return None
    return getattr(current_user, "teacher_profile", None)


def is_teacher_account():
    teacher = get_current_teacher()
    return bool(
        teacher
        and teacher.is_active
        and teacher.employment_status == "Active"
        and getattr(teacher, "user_id", None) == current_user.id
    )


def teacher_can(permission):
    teacher = get_current_teacher()
    if not teacher:
        return False
    perms = teacher_permission_set(teacher)
    if not perms:
        return True
    return permission in perms


def teacher_permission_required(permission):
    def decorator(view):
        @wraps(view)
        def wrapped(*args, **kwargs):
            if not current_user.is_authenticated:
                return redirect(url_for("auth.login", next=request.url))
            if not is_teacher_account():
                flash("This area is only available to teacher accounts.", "danger")
                return redirect(url_for("auth.login"))
            if not teacher_can(permission):
                flash("You do not have permission to access this feature.", "danger")
                return redirect(url_for("teacher_portal.dashboard"))
            return view(*args, **kwargs)

        return wrapped

    return decorator


def teacher_login_required(view):
    @wraps(view)
    def wrapped(*args, **kwargs):
        if not current_user.is_authenticated:
            return redirect(url_for("auth.login", next=request.url))
        if not is_teacher_account():
            flash("This area is only available to teacher accounts.", "danger")
            if current_user.role in ("super_admin", "admin"):
                return redirect(url_for("admin.dashboard"))
            return redirect(url_for("auth.login"))
        return view(*args, **kwargs)

    return wrapped


def ensure_teacher_resource(teacher, class_id=None, subject_id=None, student_id=None):
    class_ids = {school_class.id for school_class in teacher.classes}
    subject_ids = {subject.id for subject in teacher.subjects}
    if class_id is not None and int(class_id) not in class_ids:
        abort(403)
    if subject_id is not None and int(subject_id) not in subject_ids:
        abort(403)
    if student_id is not None:
        from .models import Student

        student = Student.query.get_or_404(int(student_id))
        if student.class_id not in class_ids:
            abort(403)
    return True


def parse_teacher_filters(args):
    def _int(value):
        return int(value) if value and str(value).isdigit() else None

    return {
        "academic_year_id": _int(args.get("academic_year_id")),
        "exam_id": _int(args.get("exam_id")),
        "subject_id": _int(args.get("subject_id")),
        "class_id": _int(args.get("class_id")),
        "section": (args.get("section") or "").strip() or None,
        "student_id": _int(args.get("student_id")),
        "date_from": (args.get("date_from") or "").strip() or None,
        "date_to": (args.get("date_to") or "").strip() or None,
        "q": (args.get("q") or "").strip() or None,
        "limit": _int(args.get("limit")) or 10,
        "compare_exam_id": _int(args.get("compare_exam_id")),
        "compare_class_id": _int(args.get("compare_class_id")),
        "compare_section": (args.get("compare_section") or "").strip() or None,
        "compare_year_id": _int(args.get("compare_year_id")),
        "compare_subject_id": _int(args.get("compare_subject_id")),
        "compare_type": (args.get("compare_type") or "exam").strip(),
    }


def teacher_nav_items():
    items = [
        ("teacher_portal.dashboard", "Dashboard", "fa-chart-pie", "view_examination_results"),
        ("teacher_portal.subjects", "My Subjects", "fa-book-open", "view_assigned_subjects"),
        ("teacher_portal.classes", "My Classes", "fa-people-roof", "view_assigned_classes"),
        ("teacher_portal.exam_analysis", "Exam Analysis", "fa-file-circle-check", "view_examination_results"),
        ("teacher_portal.subject_analysis", "Subject Analysis", "fa-book", "subject_analysis"),
        ("teacher_portal.student_analysis", "Student Analysis", "fa-user-graduate", "student_analysis"),
        ("teacher_portal.trends", "Performance Trends", "fa-chart-line", "performance_trends"),
        ("teacher_portal.grades", "Grade Distribution", "fa-layer-group", "grade_distribution"),
        ("teacher_portal.pass_fail", "Pass / Fail Analysis", "fa-circle-half-stroke", "grade_distribution"),
        ("teacher_portal.top_performers", "Top Performers", "fa-trophy", "top_performers"),
        ("teacher_portal.weak_students", "Weak Students", "fa-triangle-exclamation", "weak_students"),
        ("teacher_portal.comparison", "Comparison", "fa-code-compare", "exam_comparison"),
        ("teacher_portal.reports", "Reports", "fa-file-export", "reports"),
        ("teacher_portal.ai_insights", "AI Insights", "fa-wand-magic-sparkles", "ai_insights"),
        ("teacher_portal.settings", "Settings", "fa-sliders", None),
    ]
    return items


def record_teacher_visit(teacher, page_name):
    log_teacher_activity(teacher, "Analysis", f"Viewed {page_name}")


def teacher_theme():
    settings = get_teacher_settings()
    return settings.get("teacher_theme") or "light"


def all_teacher_permission_keys():
    return [key for key, _ in TEACHER_PERMISSIONS]
