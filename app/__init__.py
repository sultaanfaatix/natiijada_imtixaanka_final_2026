from flask import Flask, url_for
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
    from .permissions import can
    from .services import DEFAULT_SETTINGS, seed_grade_scales

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
        from .i18n import active_translations, current_language, translate
        from .services import get_settings

        settings = get_settings()
        lang = current_language(settings.get("default_language", "en"))

        def asset_url(path):
            if not path:
                return ""
            value = str(path)
            if value.startswith(("http://", "https://", "data:")):
                return value
            return url_for("static", filename=value)

        return {
            "ui_settings": settings,
            "_": translate,
            "active_translations": active_translations(),
            "current_language": lang,
            "text_direction": "rtl" if lang == "ar" else "ltr",
            "can": can,
            "asset_url": asset_url,
        }

    from .routes_admin import admin_bp
    from .routes_advanced_results import advanced_results_bp
    from .routes_attendance import attendance_bp
    from .routes_auth import auth_bp
    from .routes_id_cards import id_cards_bp
    from .routes_public import public_bp
    from .routes_teacher_portal import teacher_portal_bp
    from .routes_teachers import teachers_bp

    app.register_blueprint(public_bp)
    app.register_blueprint(auth_bp)
    app.register_blueprint(admin_bp, url_prefix="/admin")
    app.register_blueprint(attendance_bp, url_prefix="/admin/attendance")
    app.register_blueprint(id_cards_bp, url_prefix="/admin/id-cards")
    app.register_blueprint(advanced_results_bp, url_prefix="/admin/advanced-results")
    app.register_blueprint(teachers_bp, url_prefix="/admin/teachers")
    app.register_blueprint(teacher_portal_bp, url_prefix="/teacher")

    register_cli(app)

    # =========================
    # FIX: AUTO CREATE EVERYTHING
    # =========================
    with app.app_context():
        db.create_all()
        from .schema_compat import ensure_schema_compatibility

        ensure_schema_compatibility()

        # seed missing settings only; never overwrite production values
        if DEFAULT_SETTINGS:
            for key, value in DEFAULT_SETTINGS.items():
                if not db.session.get(Setting, key):
                    db.session.add(Setting(key=key, value=value))
            seed_grade_scales()
            from .teacher_services import seed_teacher_settings

            seed_teacher_settings()
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
    from .services import DEFAULT_SETTINGS, seed_grade_scales

    @app.cli.command("init-db")
    def init_db_command():
        db.create_all()
        from .schema_compat import ensure_schema_compatibility

        ensure_schema_compatibility()

        for key, value in DEFAULT_SETTINGS.items():
            if not db.session.get(Setting, key):
                db.session.add(Setting(key=key, value=value))

        seed_grade_scales()
        from .teacher_services import seed_teacher_settings

        seed_teacher_settings()

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
