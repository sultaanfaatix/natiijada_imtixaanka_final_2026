from flask import Blueprint, flash, redirect, render_template, request, url_for
from flask_login import current_user, login_required, login_user, logout_user

from .models import User

auth_bp = Blueprint("auth", __name__)


@auth_bp.route("/admin/login", methods=["GET", "POST"])
def login():
    if current_user.is_authenticated:
        return redirect(url_for("admin.dashboard"))
    if request.method == "POST":
        username = request.form.get("username", "").strip()
        password = request.form.get("password", "")
        user = User.query.filter_by(username=username, is_active=True).first()
        if user and user.check_password(password):
            login_user(user)
            return redirect(request.args.get("next") or url_for("admin.dashboard"))
        flash("Invalid username or password.", "danger")
    return render_template("admin/login.html")


@auth_bp.route("/admin/logout", methods=["POST"])
@login_required
def logout():
    logout_user()
    flash("You have been logged out.", "success")
    return redirect(url_for("auth.login"))


@auth_bp.route("/admin/change-password", methods=["GET", "POST"])
@login_required
def change_password():
    if request.method == "POST":
        current = request.form.get("current_password", "")
        new_password = request.form.get("new_password", "")
        confirm = request.form.get("confirm_password", "")
        if not current_user.check_password(current):
            flash("Current password is incorrect.", "danger")
        elif len(new_password) < 8:
            flash("Password must be at least 8 characters.", "danger")
        elif new_password != confirm:
            flash("Passwords do not match.", "danger")
        else:
            current_user.set_password(new_password)
            from . import db

            db.session.commit()
            flash("Password changed successfully.", "success")
            return redirect(url_for("admin.dashboard"))
    return render_template("admin/change_password.html")
