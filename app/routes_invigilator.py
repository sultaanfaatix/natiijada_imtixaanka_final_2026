from datetime import datetime, timedelta
from flask import Blueprint, flash, redirect, render_template, request, session, url_for
from werkzeug.security import check_password_hash
import functools

from . import db
from .models import ExamInvigilator, IncidentReportSettings, InvigilatorLoginHistory

invigilator_bp = Blueprint("invigilator", __name__)

# Session timeout in minutes
INVIGILATOR_SESSION_TIMEOUT = 30


def incident_setting_value(key, default=None):
    row = IncidentReportSettings.query.filter_by(setting_key=key).first()
    return row.setting_value if row else default


def validate_invigilator_password(password):
    policy_type = incident_setting_value("invigilator_password_type", "letters_numbers")
    min_length = int(incident_setting_value("invigilator_password_min_length", "6") or 6)
    if len(password or "") < min_length:
        return False, f"Password must be at least {min_length} characters."
    if policy_type == "numbers" and not password.isdigit():
        return False, "Password must contain numbers only."
    if policy_type == "letters" and not password.isalpha():
        return False, "Password must contain letters only."
    if policy_type == "letters_numbers" and not password.isalnum():
        return False, "Password must contain letters and numbers only."
    return True, ""


def login_invigilator(invigilator):
    """Log in an invigilator and create session"""
    session["invigilator_id"] = invigilator.id
    session["invigilator_invigilator_id"] = invigilator.invigilator_id
    session["invigilator_username"] = invigilator.username
    session["invigilator_full_name"] = invigilator.full_name
    session["invigilator_role"] = invigilator.role
    session["invigilator_photo_path"] = invigilator.photo_path
    session["invigilator_logged_in"] = True
    session["invigilator_login_time"] = datetime.utcnow().isoformat()
    
    # Update last login time
    invigilator.last_login_at = datetime.utcnow()
    db.session.commit()


def logout_invigilator():
    """Log out the current invigilator"""
    invigilator_id = session.get("invigilator_id")
    if invigilator_id:
        invigilator = ExamInvigilator.query.get(invigilator_id)
        if invigilator:
            invigilator.last_logout_at = datetime.utcnow()
            db.session.commit()
    
    session.pop("invigilator_id", None)
    session.pop("invigilator_invigilator_id", None)
    session.pop("invigilator_username", None)
    session.pop("invigilator_full_name", None)
    session.pop("invigilator_role", None)
    session.pop("invigilator_photo_path", None)
    session.pop("invigilator_logged_in", None)
    session.pop("invigilator_login_time", None)


def current_invigilator():
    """Get the currently logged-in invigilator"""
    invigilator_id = session.get("invigilator_id")
    if invigilator_id:
        return ExamInvigilator.query.get(invigilator_id)
    return None


def check_invigilator_session():
    """Check if invigilator session is valid and not expired"""
    if not session.get("invigilator_logged_in"):
        return False
    
    login_time_str = session.get("invigilator_login_time")
    if not login_time_str:
        return False
    
    try:
        login_time = datetime.fromisoformat(login_time_str)
        session_age = datetime.utcnow() - login_time
        
        if session_age > timedelta(minutes=INVIGILATOR_SESSION_TIMEOUT):
            return False
    except (ValueError, TypeError):
        return False
    
    return True


def invigilator_login_required(f):
    """Decorator to require invigilator login"""
    @functools.wraps(f)
    def decorated_function(*args, **kwargs):
        # Check if session is valid and not expired
        if not check_invigilator_session():
            logout_invigilator()
            # Store the intended URL for redirect after login
            session["invigilator_next"] = request.url
            flash("Your session has expired. Please sign in again to continue.", "warning")
            return redirect(url_for("invigilator.login"))
        
        # Check if invigilator account is still valid
        invigilator = current_invigilator()
        if not invigilator or not invigilator.is_valid():
            logout_invigilator()
            flash("Your invigilator account is no longer valid.", "danger")
            return redirect(url_for("invigilator.login"))
        
        return f(*args, **kwargs)
    return decorated_function


def invigilator_role_required(*allowed_roles):
    """Decorator to require specific invigilator roles"""
    def decorator(f):
        @functools.wraps(f)
        def decorated_function(*args, **kwargs):
            invigilator = current_invigilator()
            if not invigilator:
                flash("Please log in as an invigilator to continue.", "warning")
                return redirect(url_for("invigilator.login"))
            
            if invigilator.role not in allowed_roles:
                flash("You don't have permission to access this page.", "danger")
                return redirect(url_for("public.qr_landing"))
            
            return f(*args, **kwargs)
        return decorated_function
    return decorator


def record_login_history(invigilator, status, ip_address=None, failure_reason=None):
    """Record invigilator login attempt in history"""
    history = InvigilatorLoginHistory(
        invigilator_id=invigilator.id,
        login_time=datetime.utcnow(),
        ip_address=ip_address or request.remote_addr,
        user_agent=request.user_agent.string if request.user_agent else None,
        login_status=status,
        failure_reason=failure_reason
    )
    db.session.add(history)
    db.session.commit()


@invigilator_bp.route("/login", methods=["GET", "POST"])
def login():
    """Invigilator login page"""
    if session.get("invigilator_logged_in"):
        # If already logged in, redirect to next page or dashboard
        next_url = session.pop("invigilator_next", None)
        if next_url:
            return redirect(next_url)
        return redirect(url_for("public.qr_landing"))
    
    if request.method == "POST":
        username = request.form.get("username", "").strip()
        password = request.form.get("password", "")
        
        if not username or not password:
            flash("Please provide both username and password.", "danger")
            return render_template("invigilator/login.html")
        
        invigilator = ExamInvigilator.query.filter_by(username=username).first()
        
        if not invigilator:
            flash("Invalid username or password.", "danger")
            record_login_history(
                invigilator=ExamInvigilator.query.filter_by(username=username).first() or ExamInvigilator.query.first(),
                status="Failed",
                failure_reason="Invalid username"
            )
            return render_template("invigilator/login.html")
        
        # Check if account is locked
        if invigilator.status == "Locked":
            flash("Your account has been locked. Please contact an administrator.", "danger")
            record_login_history(invigilator, "Locked", failure_reason="Account locked")
            return render_template("invigilator/login.html")
        
        # Check if account is inactive
        if invigilator.status == "Inactive" or not invigilator.is_active:
            flash("Your account is inactive. Please contact an administrator.", "danger")
            record_login_history(invigilator, "Failed", failure_reason="Account inactive")
            return render_template("invigilator/login.html")
        
        # Check if account is within validity period
        if not invigilator.is_valid():
            flash("Your account is not within the valid examination period.", "danger")
            record_login_history(invigilator, "Expired", failure_reason="Account expired")
            return render_template("invigilator/login.html")
        
        # Check password
        if invigilator.check_password(password):
            # Check if password change is forced
            if invigilator.force_password_change:
                session["invigilator_id"] = invigilator.id
                session["invigilator_requires_password_change"] = True
                flash("You must change your password before continuing.", "warning")
                return redirect(url_for("invigilator.change_password"))
            
            # Successful login
            login_invigilator(invigilator)
            record_login_history(invigilator, "Success")
            flash(f"Welcome, {invigilator.full_name}!", "success")
            
            # Redirect to intended page or QR landing
            next_url = session.pop("invigilator_next", None)
            if next_url:
                return redirect(next_url)
            return redirect(url_for("public.qr_landing"))
        else:
            flash("Invalid username or password.", "danger")
            record_login_history(invigilator, "Failed", failure_reason="Invalid password")
            return render_template("invigilator/login.html")
    
    return render_template("invigilator/login.html")


@invigilator_bp.route("/logout")
def logout():
    """Invigilator logout"""
    invigilator = current_invigilator()
    if invigilator:
        flash(f"Goodbye, {invigilator.full_name}!", "info")
    logout_invigilator()
    return redirect(url_for("invigilator.login"))


@invigilator_bp.route("/change-password", methods=["GET", "POST"])
@invigilator_login_required
def change_password():
    """Change invigilator password"""
    invigilator = current_invigilator()
    
    if request.method == "POST":
        current_password = request.form.get("current_password", "")
        new_password = request.form.get("new_password", "")
        confirm_password = request.form.get("confirm_password", "")
        
        if not current_password or not new_password or not confirm_password:
            flash("Please fill in all fields.", "danger")
            return render_template("invigilator/change_password.html")
        
        if not invigilator.check_password(current_password):
            flash("Current password is incorrect.", "danger")
            return render_template("invigilator/change_password.html")
        
        if new_password != confirm_password:
            flash("New passwords do not match.", "danger")
            return render_template("invigilator/change_password.html")
        
        is_valid_password, password_error = validate_invigilator_password(new_password)
        if not is_valid_password:
            flash(password_error, "danger")
            return render_template("invigilator/change_password.html")
        
        invigilator.set_password(new_password)
        invigilator.visible_password = new_password
        invigilator.force_password_change = False
        db.session.commit()
        
        session.pop("invigilator_requires_password_change", None)
        flash("Password changed successfully!", "success")
        
        # Redirect to intended page or QR landing
        next_url = session.pop("invigilator_next", None)
        if next_url:
            return redirect(next_url)
        return redirect(url_for("public.qr_landing"))
    
    return render_template("invigilator/change_password.html")


@invigilator_bp.route("/profile")
@invigilator_login_required
def profile():
    """Invigilator profile page"""
    invigilator = current_invigilator()
    return render_template("invigilator/profile.html", invigilator=invigilator)
