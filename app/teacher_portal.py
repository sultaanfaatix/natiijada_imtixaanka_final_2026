from functools import wraps

from flask import abort, flash, redirect, request, url_for
from flask_login import current_user

from .teacher_services import (
    TEACHER_PERMISSIONS,
    get_teacher_settings,
    log_teacher_activity,
    teacher_has_permission,
    teacher_permission_set,
)

TEACHER_PUBLIC_ENDPOINTS = frozenset(
    {
        "teacher_portal.login",
        "teacher_portal.forgot_password",
    }
)


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
    return teacher_has_permission(teacher, permission)


def safe_teacher_next_url(next_url):
    from flask import url_has_allowed_host_and_scheme

    if next_url and url_has_allowed_host_and_scheme(next_url, request.host):
        return next_url
    return url_for("teacher_portal.dashboard")


def teacher_requires_password_change():
    teacher = get_current_teacher()
    return bool(teacher and teacher.force_password_change)


def teacher_permission_required(permission):
    def decorator(view):
        @wraps(view)
        def wrapped(*args, **kwargs):
            if not current_user.is_authenticated:
                return redirect(url_for("teacher_portal.login", next=request.url))
            if not is_teacher_account():
                flash("This area is only available to teacher accounts.", "danger")
                return redirect(url_for("teacher_portal.login"))
            if teacher_requires_password_change() and request.endpoint != "teacher_portal.change_password":
                flash("Please change your password before continuing.", "warning")
                return redirect(url_for("teacher_portal.change_password"))
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
            return redirect(url_for("teacher_portal.login", next=request.url))
        if not is_teacher_account():
            flash("This area is only available to teacher accounts.", "danger")
            if current_user.role in ("super_admin", "admin"):
                return redirect(url_for("admin.dashboard"))
            return redirect(url_for("teacher_portal.login"))
        if teacher_requires_password_change() and request.endpoint != "teacher_portal.change_password":
            flash("Please change your password before continuing.", "warning")
            return redirect(url_for("teacher_portal.change_password"))
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
        ("teacher_portal.dashboard", "Dashboard", "fa-chart-pie", "view_dashboard"),
        ("teacher_portal.profile", "My Profile", "fa-user", None),
        ("teacher_portal.subjects", "My Subjects", "fa-book-open", "view_assigned_subjects"),
        ("teacher_portal.classes", "My Classes", "fa-people-roof", "view_assigned_classes"),
        ("teacher_portal.my_students", "My Students", "fa-user-graduate", "view_students"),
        ("teacher_portal.examinations", "Examinations", "fa-file-circle-check", "view_examinations"),
        ("teacher_portal.results", "Results", "fa-clipboard-list", "view_student_results"),
        ("teacher_portal.reports", "Reports", "fa-file-export", "generate_reports"),
        ("teacher_portal.settings", "Settings", "fa-sliders", None),
    ]
    if teacher_can("future_analysis_features"):
        items.extend(
            [
                ("teacher_portal.trends", "Performance Trends", "fa-chart-line", "future_analysis_features"),
                ("teacher_portal.grades", "Grade Distribution", "fa-layer-group", "future_analysis_features"),
                ("teacher_portal.top_performers", "Top Performers", "fa-trophy", "future_analysis_features"),
                ("teacher_portal.weak_students", "Weak Students", "fa-triangle-exclamation", "future_analysis_features"),
            ]
        )
    if teacher_can("future_ai_features"):
        items.append(("teacher_portal.ai_insights", "AI Insights", "fa-wand-magic-sparkles", "future_ai_features"))
    return items


def record_teacher_visit(teacher, page_name):
    log_teacher_activity(teacher, "Analysis", f"Viewed {page_name}")


def teacher_theme():
    settings = get_teacher_settings()
    return settings.get("teacher_theme") or "light"


def all_teacher_permission_keys():
    return [key for key, _ in TEACHER_PERMISSIONS]
