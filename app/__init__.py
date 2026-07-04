from flask import Flask
from flask_login import LoginManager
from flask_sqlalchemy import SQLAlchemy
from flask_wtf import CSRFProtect

from config import Config

db = SQLAlchemy()
csrf = CSRFProtect()
login_manager = LoginManager()
login_manager.login_view = "auth.login"
login_manager.login_message_category = "warning"


def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)

    db.init_app(app)
    csrf.init_app(app)
    login_manager.init_app(app)

    from .models import User, Setting
    from .services import DEFAULT_SETTINGS

    @login_manager.user_loader
    def load_user(user_id):
        return db.session.get(User, int(user_id))

    @app.after_request
    def secure_headers(response):
        response.headers.setdefault("X-Content-Type-Options", "nosniff")
        response.headers.setdefault("X-Frame-Options", "SAMEORIGIN")
        response.headers.setdefault("Referrer-Policy", "strict-origin-when-cross-origin")
        return response

    @app.context_processor
    def inject_ui_settings():
        from .services import get_settings
        return {"ui_settings": get_settings()}

    from .routes_admin import admin_bp
    from .routes_auth import auth_bp
    from .routes_public import public_bp

    app.register_blueprint(public_bp)
    app.register_blueprint(auth_bp)
    app.register_blueprint(admin_bp, url_prefix="/admin")

    register_cli(app)

    # =========================
    # FIX: AUTO CREATE EVERYTHING
    # =========================
    with app.app_context():
        db.create_all()

        # seed settings
        if DEFAULT_SETTINGS:
            for key, value in DEFAULT_SETTINGS.items():
                db.session.merge(Setting(key=key, value=value))
            db.session.commit()

        # 🔥 AUTO ADMIN FIX (IMPORTANT)
        from .models import User

        admin = User.query.filter_by(username="admin").first()
        if not admin:
            admin = User(
                username="admin",
                full_name="System Administrator",
                role="super_admin",
                is_active=True
            )
            admin.set_password("Admin@12345")
            db.session.add(admin)
            db.session.commit()

    return app


def register_cli(app):
    import click

    from .models import AcademicYear, GradeScale, Setting, User
    from .services import DEFAULT_SETTINGS

    @app.cli.command("init-db")
    def init_db_command():
        db.create_all()

        for key, value in DEFAULT_SETTINGS.items():
            db.session.merge(Setting(key=key, value=value))

        if not GradeScale.query.first():
            for grade, min_score, max_score, comment in [
                ("A+", 95, 100, "Heer Sare"),
                ("A", 90, 94.99, "Heer Sare"),
                ("A-", 85, 89.99, "Heer Sare"),
                ("B+", 80, 84.99, "Aad u Wanaagsan"),
                ("B", 75, 79.99, "Aad u Wanaagsan"),
                ("B-", 70, 74.99, "Wanaagsan"),
                ("C+", 65, 69.99, "Wanaagsan"),
                ("C", 60, 64.99, "Wanaagsan"),
                ("C-", 50, 59.99, "Dhexdhexaad"),
                ("D", 40, 49.99, "Liita"),
                ("E", 20, 39.99, "Liita"),
                ("F", 0, 19.99, "Liita"),
            ]:
                db.session.add(GradeScale(
                    grade=grade,
                    min_score=min_score,
                    max_score=max_score,
                    comment=comment
                ))

        if not AcademicYear.query.first():
            db.session.add(AcademicYear(name="2024-2025", is_current=True))

        if not User.query.filter_by(username="admin").first():
            admin = User(
                username="admin",
                full_name="System Administrator",
                role="super_admin",
                is_active=True
            )
            admin.set_password("Admin@12345")
            db.session.add(admin)

        db.session.commit()
        click.echo("Database initialized. Default login: admin / Admin@12345")