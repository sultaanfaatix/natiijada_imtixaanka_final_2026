import json
from datetime import datetime

from flask_login import UserMixin
from sqlalchemy import UniqueConstraint
from werkzeug.security import check_password_hash, generate_password_hash

from . import db


class TimestampMixin:
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)


class User(UserMixin, TimestampMixin, db.Model):
    __tablename__ = "users"

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False, index=True)
    full_name = db.Column(db.String(150), nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)
    role = db.Column(db.Enum("super_admin", "admin", "staff"), default="admin", nullable=False)
    permissions = db.Column(db.Text)
    photo_path = db.Column(db.String(255))
    is_active = db.Column(db.Boolean, default=True, nullable=False)

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def can_manage_users(self):
        return self.role == "super_admin"

    def permission_set(self):
        if self.role == "super_admin":
            return {"*"}
        if not self.permissions:
            return set()
        try:
            value = json.loads(self.permissions)
        except (TypeError, ValueError):
            return set()
        return set(value if isinstance(value, list) else [])

    def has_permission(self, permission):
        return self.role == "super_admin" or permission in self.permission_set()

    def set_permissions(self, permissions):
        self.permissions = json.dumps(sorted(set(permissions or [])))


class AcademicYear(TimestampMixin, db.Model):
    __tablename__ = "academic_years"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(30), unique=True, nullable=False)
    is_current = db.Column(db.Boolean, default=False, nullable=False)


class SchoolClass(TimestampMixin, db.Model):
    __tablename__ = "school_classes"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), unique=True, nullable=False)
    description = db.Column(db.String(255))


class Subject(TimestampMixin, db.Model):
    __tablename__ = "subjects"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(120), unique=True, nullable=False)
    max_score = db.Column(db.Numeric(6, 2), default=100, nullable=False)
    sort_order = db.Column(db.Integer, default=0, nullable=False)


class Exam(TimestampMixin, db.Model):
    __tablename__ = "exams"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(150), nullable=False)
    academic_year_id = db.Column(db.Integer, db.ForeignKey("academic_years.id"), nullable=False)
    is_published = db.Column(db.Boolean, default=False, nullable=False)

    academic_year = db.relationship("AcademicYear")

    __table_args__ = (
        UniqueConstraint("name", "academic_year_id", name="uq_exam_year"),
    )


class Student(TimestampMixin, db.Model):
    __tablename__ = "students"

    id = db.Column(db.Integer, primary_key=True)

    # ✅ THIS IS THE ID USERS TYPE (3007)
    student_code = db.Column(db.String(50), unique=True, nullable=False, index=True)

    full_name = db.Column(db.String(180), nullable=False)
    mother_name = db.Column(db.String(180))
    phone = db.Column(db.String(40))

    class_id = db.Column(db.Integer, db.ForeignKey("school_classes.id"), nullable=False)
    academic_year_id = db.Column(db.Integer, db.ForeignKey("academic_years.id"), nullable=False)
    level = db.Column(db.String(80))
    section = db.Column(db.String(80))

    photo_path = db.Column(db.String(255))
    note = db.Column(db.Text)

    is_result_locked = db.Column(db.Boolean, default=False, nullable=False)
    lock_reason = db.Column(db.String(255))
    is_active = db.Column(db.Boolean, default=True, nullable=False)

    school_class = db.relationship("SchoolClass")
    academic_year = db.relationship("AcademicYear")

    # ✅ FIX: allow system to use "student_id" in queries safely
    @property
    def student_id(self):
        return self.student_code


class Result(TimestampMixin, db.Model):
    __tablename__ = "results"

    id = db.Column(db.Integer, primary_key=True)

    student_id = db.Column(db.Integer, db.ForeignKey("students.id", ondelete="CASCADE"), nullable=False)
    exam_id = db.Column(db.Integer, db.ForeignKey("exams.id", ondelete="CASCADE"), nullable=False)
    subject_id = db.Column(db.Integer, db.ForeignKey("subjects.id"), nullable=False)

    score = db.Column(db.Numeric(6, 2), nullable=False)
    grade_override = db.Column(db.String(10))
    comment = db.Column(db.String(255))
    is_published = db.Column(db.Boolean, default=True, nullable=False)

    student = db.relationship("Student", backref=db.backref("results", cascade="all, delete-orphan"))
    exam = db.relationship("Exam")
    subject = db.relationship("Subject")

    __table_args__ = (
        UniqueConstraint("student_id", "exam_id", "subject_id", name="uq_student_exam_subject"),
    )


class Setting(TimestampMixin, db.Model):
    __tablename__ = "settings"

    key = db.Column(db.String(80), primary_key=True)
    value = db.Column(db.Text)


class GradeScale(TimestampMixin, db.Model):
    __tablename__ = "grade_scales"

    id = db.Column(db.Integer, primary_key=True)
    grade = db.Column(db.String(5), nullable=False)
    min_score = db.Column(db.Numeric(6, 2), nullable=False)
    max_score = db.Column(db.Numeric(6, 2), nullable=False)
    comment = db.Column(db.String(120), nullable=False)


class ReportVerification(TimestampMixin, db.Model):
    __tablename__ = "report_verifications"

    id = db.Column(db.Integer, primary_key=True)
    token = db.Column(db.String(120), unique=True, nullable=False, index=True)
    student_id = db.Column(db.Integer, db.ForeignKey("students.id", ondelete="CASCADE"), nullable=False)
    exam_id = db.Column(db.Integer, db.ForeignKey("exams.id", ondelete="CASCADE"), nullable=False)
    is_valid = db.Column(db.Boolean, default=True, nullable=False)

    student = db.relationship("Student")
    exam = db.relationship("Exam")

    __table_args__ = (
        UniqueConstraint("student_id", "exam_id", name="uq_report_student_exam"),
    )


class AttendanceRecord(TimestampMixin, db.Model):
    __tablename__ = "attendance_records"

    id = db.Column(db.Integer, primary_key=True)
    student_id = db.Column(db.Integer, db.ForeignKey("students.id", ondelete="CASCADE"), nullable=False, index=True)
    academic_year_id = db.Column(db.Integer, db.ForeignKey("academic_years.id"), nullable=False, index=True)
    class_id = db.Column(db.Integer, db.ForeignKey("school_classes.id"), nullable=False, index=True)
    exam_id = db.Column(db.Integer, db.ForeignKey("exams.id", ondelete="SET NULL"), index=True)
    attendance_date = db.Column(db.Date, nullable=False, index=True)
    status = db.Column(
        db.Enum("Present", "Absent", "Late", "Excused", "Medical Leave", "Blocked"),
        default="Present",
        nullable=False,
        index=True,
    )
    note = db.Column(db.String(255))
    marked_by_id = db.Column(db.Integer, db.ForeignKey("users.id", ondelete="SET NULL"))

    student = db.relationship("Student")
    academic_year = db.relationship("AcademicYear")
    school_class = db.relationship("SchoolClass")
    exam = db.relationship("Exam")
    marked_by = db.relationship("User")


class IdCardIssue(TimestampMixin, db.Model):
    __tablename__ = "id_card_issues"

    id = db.Column(db.Integer, primary_key=True)
    token = db.Column(db.String(120), unique=True, nullable=False, index=True)
    student_id = db.Column(db.Integer, db.ForeignKey("students.id", ondelete="CASCADE"), nullable=False, index=True)
    academic_year_id = db.Column(db.Integer, db.ForeignKey("academic_years.id"), nullable=False, index=True)
    issue_date = db.Column(db.Date, nullable=False)
    expiry_date = db.Column(db.Date)
    status = db.Column(db.Enum("Active", "Inactive", "Expired", "Blocked"), default="Active", nullable=False, index=True)
    template_name = db.Column(db.String(80), default="default", nullable=False)

    student = db.relationship("Student")
    academic_year = db.relationship("AcademicYear")


class AuditLog(db.Model):
    __tablename__ = "audit_logs"

    id = db.Column(db.Integer, primary_key=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False, index=True)
    username = db.Column(db.String(80), nullable=False)
    ip_address = db.Column(db.String(80))
    action = db.Column(db.String(120), nullable=False)
    details = db.Column(db.Text)
