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


class AcademicLevel(TimestampMixin, db.Model):
    __tablename__ = "academic_levels"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), unique=True, nullable=False)
    sort_order = db.Column(db.Integer, default=0, nullable=False)
    is_active = db.Column(db.Boolean, default=True, nullable=False)


class AcademicClass(TimestampMixin, db.Model):
    __tablename__ = "academic_classes"

    id = db.Column(db.Integer, primary_key=True)
    academic_level_id = db.Column(db.Integer, db.ForeignKey("academic_levels.id"), nullable=False)
    name = db.Column(db.String(80), nullable=False)
    sort_order = db.Column(db.Integer, default=0, nullable=False)
    is_active = db.Column(db.Boolean, default=True, nullable=False)

    academic_level = db.relationship("AcademicLevel", backref=db.backref("classes", lazy="dynamic"))

    __table_args__ = (
        UniqueConstraint("academic_level_id", "name", name="uq_level_class"),
    )


class AcademicSection(TimestampMixin, db.Model):
    __tablename__ = "academic_sections"

    id = db.Column(db.Integer, primary_key=True)
    academic_class_id = db.Column(db.Integer, db.ForeignKey("academic_classes.id"), nullable=False)
    name = db.Column(db.String(80), nullable=False)
    sort_order = db.Column(db.Integer, default=0, nullable=False)
    is_active = db.Column(db.Boolean, default=True, nullable=False)

    academic_class = db.relationship("AcademicClass", backref=db.backref("sections", lazy="dynamic"))

    __table_args__ = (
        UniqueConstraint("academic_class_id", "name", name="uq_class_section"),
    )


class SchoolClass(TimestampMixin, db.Model):
    __tablename__ = "school_classes"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), unique=True, nullable=False)
    description = db.Column(db.String(255))


class Subject(TimestampMixin, db.Model):
    __tablename__ = "subjects"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(120), nullable=False)
    academic_level_id = db.Column(db.Integer, db.ForeignKey("academic_levels.id"), nullable=True)
    max_score = db.Column(db.Numeric(6, 2), default=100, nullable=False)
    sort_order = db.Column(db.Integer, default=0, nullable=False)

    academic_level = db.relationship("AcademicLevel", backref=db.backref("subjects", lazy="dynamic"))

    __table_args__ = (
        UniqueConstraint("name", "academic_level_id", name="uq_subject_level"),
    )


class Exam(TimestampMixin, db.Model):
    __tablename__ = "exams"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(150), nullable=False)
    academic_year_id = db.Column(db.Integer, db.ForeignKey("academic_years.id"), nullable=False)
    
    # New academic hierarchy fields
    academic_level_id = db.Column(db.Integer, db.ForeignKey("academic_levels.id"), nullable=True)
    academic_class_id = db.Column(db.Integer, db.ForeignKey("academic_classes.id"), nullable=True)
    academic_section_id = db.Column(db.Integer, db.ForeignKey("academic_sections.id"), nullable=True)
    
    is_published = db.Column(db.Boolean, default=False, nullable=False)

    academic_year = db.relationship("AcademicYear")
    academic_level = db.relationship("AcademicLevel")
    academic_class = db.relationship("AcademicClass")
    academic_section = db.relationship("AcademicSection")

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

    # Legacy fields for backward compatibility during migration
    class_id = db.Column(db.Integer, db.ForeignKey("school_classes.id"), nullable=True)
    academic_year_id = db.Column(db.Integer, db.ForeignKey("academic_years.id"), nullable=False)
    level = db.Column(db.String(80))
    section = db.Column(db.String(80))

    # New academic hierarchy fields
    academic_level_id = db.Column(db.Integer, db.ForeignKey("academic_levels.id"), nullable=True)
    academic_class_id = db.Column(db.Integer, db.ForeignKey("academic_classes.id"), nullable=True)
    academic_section_id = db.Column(db.Integer, db.ForeignKey("academic_sections.id"), nullable=True)

    photo_path = db.Column(db.String(255))
    note = db.Column(db.Text)

    is_result_locked = db.Column(db.Boolean, default=False, nullable=False)
    lock_reason = db.Column(db.String(255))
    is_active = db.Column(db.Boolean, default=True, nullable=False)

    school_class = db.relationship("SchoolClass")
    academic_year = db.relationship("AcademicYear")
    academic_level = db.relationship("AcademicLevel")
    academic_class = db.relationship("AcademicClass")
    academic_section = db.relationship("AcademicSection")

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
    grade_override = db.Column(db.String(20))
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
    grade = db.Column(db.String(20), nullable=False)
    min_score = db.Column(db.Numeric(6, 2), nullable=False)
    max_score = db.Column(db.Numeric(6, 2), nullable=False)
    comment = db.Column(db.String(120), nullable=False)
    grade_point = db.Column(db.Numeric(4, 2), default=0, nullable=False)
    is_pass = db.Column(db.Boolean, default=True, nullable=False)
    badge_color = db.Column(db.String(20), default="#10b981", nullable=False)
    text_color = db.Column(db.String(20), default="#ffffff", nullable=False)
    background_color = db.Column(db.String(20), default="#ecfdf5", nullable=False)
    border_color = db.Column(db.String(20), default="#10b981", nullable=False)
    sort_order = db.Column(db.Integer, default=0, nullable=False)
    is_active = db.Column(db.Boolean, default=True, nullable=False)


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
    
    # Legacy field for backward compatibility
    class_id = db.Column(db.Integer, db.ForeignKey("school_classes.id"), nullable=True, index=True)
    
    # New academic hierarchy fields
    academic_level_id = db.Column(db.Integer, db.ForeignKey("academic_levels.id"), nullable=True)
    academic_class_id = db.Column(db.Integer, db.ForeignKey("academic_classes.id"), nullable=True)
    academic_section_id = db.Column(db.Integer, db.ForeignKey("academic_sections.id"), nullable=True)
    
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
    academic_level = db.relationship("AcademicLevel")
    academic_class = db.relationship("AcademicClass")
    academic_section = db.relationship("AcademicSection")
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


teacher_subjects = db.Table(
    "teacher_subjects",
    db.Column("teacher_id", db.Integer, db.ForeignKey("teachers.id", ondelete="CASCADE"), primary_key=True),
    db.Column("subject_id", db.Integer, db.ForeignKey("subjects.id", ondelete="CASCADE"), primary_key=True),
)

teacher_classes = db.Table(
    "teacher_classes",
    db.Column("teacher_id", db.Integer, db.ForeignKey("teachers.id", ondelete="CASCADE"), primary_key=True),
    db.Column("class_id", db.Integer, db.ForeignKey("academic_classes.id", ondelete="CASCADE"), primary_key=True),
)

teacher_sections = db.Table(
    "teacher_sections",
    db.Column("teacher_id", db.Integer, db.ForeignKey("teachers.id", ondelete="CASCADE"), primary_key=True),
    db.Column("section_id", db.Integer, db.ForeignKey("academic_sections.id", ondelete="CASCADE"), primary_key=True),
)

teacher_academic_levels = db.Table(
    "teacher_academic_levels",
    db.Column("teacher_id", db.Integer, db.ForeignKey("teachers.id", ondelete="CASCADE"), primary_key=True),
    db.Column("academic_level_id", db.Integer, db.ForeignKey("academic_levels.id", ondelete="CASCADE"), primary_key=True),
)


class Teacher(TimestampMixin, db.Model):
    __tablename__ = "teachers"

    id = db.Column(db.Integer, primary_key=True)
    teacher_id = db.Column(db.String(50), unique=True, nullable=False, index=True)
    teacher_code = db.Column(db.String(50), unique=True, nullable=False, index=True)
    full_name = db.Column(db.String(180), nullable=False)
    gender = db.Column(db.Enum("Male", "Female", "Other"), nullable=True)
    phone = db.Column(db.String(40))
    email = db.Column(db.String(120))
    address = db.Column(db.Text)
    emergency_contact = db.Column(db.String(180))
    employment_date = db.Column(db.Date)
    employment_type = db.Column(db.Enum("Full Time", "Part Time", "Contract"), default="Full Time", nullable=False)
    qualification = db.Column(db.String(255))
    years_experience = db.Column(db.Integer, default=0, nullable=False)
    department = db.Column(db.String(120))
    employment_status = db.Column(db.Enum("Active", "Inactive"), default="Active", nullable=False)
    school_level = db.Column(db.Enum("Primary", "Middle", "Secondary", "High School"), nullable=True)
    photo_path = db.Column(db.String(255))
    user_id = db.Column(db.Integer, db.ForeignKey("users.id", ondelete="SET NULL"), unique=True)
    force_password_change = db.Column(db.Boolean, default=False, nullable=False)
    is_active = db.Column(db.Boolean, default=True, nullable=False)
    last_login_at = db.Column(db.DateTime)
    last_logout_at = db.Column(db.DateTime)

    user = db.relationship("User", backref=db.backref("teacher_profile", uselist=False))
    subjects = db.relationship("Subject", secondary=teacher_subjects, backref=db.backref("assigned_teachers", lazy="dynamic"))
    classes = db.relationship("AcademicClass", secondary=teacher_classes, backref=db.backref("assigned_teachers", lazy="dynamic"))
    sections = db.relationship("AcademicSection", secondary=teacher_sections, backref=db.backref("assigned_teachers", lazy="dynamic"))
    academic_levels = db.relationship("AcademicLevel", secondary=teacher_academic_levels, backref=db.backref("assigned_teachers", lazy="dynamic"))


class TeacherPermission(db.Model):
    __tablename__ = "teacher_permissions"

    id = db.Column(db.Integer, primary_key=True)
    teacher_id = db.Column(db.Integer, db.ForeignKey("teachers.id", ondelete="CASCADE"), nullable=False, index=True)
    permission = db.Column(db.String(80), nullable=False)

    teacher = db.relationship("Teacher", backref=db.backref("permission_rows", cascade="all, delete-orphan"))

    __table_args__ = (
        UniqueConstraint("teacher_id", "permission", name="uq_teacher_permission"),
    )


class TeacherActivity(db.Model):
    __tablename__ = "teacher_activities"

    id = db.Column(db.Integer, primary_key=True)
    teacher_id = db.Column(db.Integer, db.ForeignKey("teachers.id", ondelete="CASCADE"), nullable=False, index=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False, index=True)
    action = db.Column(db.String(120), nullable=False)
    details = db.Column(db.Text)
    ip_address = db.Column(db.String(80))

    teacher = db.relationship("Teacher", backref=db.backref("activities", cascade="all, delete-orphan", order_by="TeacherActivity.created_at.desc()"))


class TeacherCodeSequence(db.Model):
    __tablename__ = "teacher_code_sequences"

    id = db.Column(db.Integer, primary_key=True)
    prefix = db.Column(db.String(40), unique=True, nullable=False)
    last_number = db.Column(db.Integer, default=0, nullable=False)


class IncidentCategory(TimestampMixin, db.Model):
    __tablename__ = "incident_categories"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(120), unique=True, nullable=False)
    description = db.Column(db.String(255))
    is_active = db.Column(db.Boolean, default=True, nullable=False)
    sort_order = db.Column(db.Integer, default=0, nullable=False)


class SeverityLevel(TimestampMixin, db.Model):
    __tablename__ = "severity_levels"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), unique=True, nullable=False)
    color = db.Column(db.String(20), default="#64748b", nullable=False)
    description = db.Column(db.String(255))
    is_active = db.Column(db.Boolean, default=True, nullable=False)
    sort_order = db.Column(db.Integer, default=0, nullable=False)


class IncidentAction(TimestampMixin, db.Model):
    __tablename__ = "incident_actions"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(120), unique=True, nullable=False)
    description = db.Column(db.String(255))
    is_active = db.Column(db.Boolean, default=True, nullable=False)
    sort_order = db.Column(db.Integer, default=0, nullable=False)


class IncidentReport(TimestampMixin, db.Model):
    __tablename__ = "incident_reports"

    id = db.Column(db.Integer, primary_key=True)
    report_number = db.Column(db.String(50), unique=True, nullable=False, index=True)
    
    student_id = db.Column(db.Integer, db.ForeignKey("students.id", ondelete="CASCADE"), nullable=False, index=True)
    teacher_id = db.Column(db.Integer, db.ForeignKey("teachers.id", ondelete="SET NULL"), nullable=True, index=True)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    
    exam_id = db.Column(db.Integer, db.ForeignKey("exams.id", ondelete="SET NULL"), nullable=True)
    subject_id = db.Column(db.Integer, db.ForeignKey("subjects.id", ondelete="SET NULL"), nullable=True)
    
    category_id = db.Column(db.Integer, db.ForeignKey("incident_categories.id", ondelete="SET NULL"), nullable=False)
    severity_id = db.Column(db.Integer, db.ForeignKey("severity_levels.id", ondelete="SET NULL"), nullable=False)
    
    exam_room = db.Column(db.String(120))
    incident_date = db.Column(db.Date, nullable=False, index=True)
    incident_time = db.Column(db.Time, nullable=False)
    
    description = db.Column(db.Text, nullable=False)
    actions_taken = db.Column(db.Text)
    
    status = db.Column(
        db.Enum("Pending Review", "Under Investigation", "Resolved", "Rejected"),
        default="Pending Review",
        nullable=False,
        index=True
    )
    
    reviewed_by_id = db.Column(db.Integer, db.ForeignKey("users.id", ondelete="SET NULL"))
    reviewed_at = db.Column(db.DateTime)
    review_notes = db.Column(db.Text)
    
    student = db.relationship("Student", backref=db.backref("incident_reports", lazy="dynamic"))
    teacher = db.relationship("Teacher", backref=db.backref("incident_reports", lazy="dynamic"))
    user = db.relationship("User", foreign_keys=[user_id], backref=db.backref("submitted_reports", lazy="dynamic"))
    reviewed_by = db.relationship("User", foreign_keys=[reviewed_by_id], backref=db.backref("reviewed_reports", lazy="dynamic"))
    exam = db.relationship("Exam")
    subject = db.relationship("Subject")
    category = db.relationship("IncidentCategory")
    severity = db.relationship("SeverityLevel")


class IncidentAttachment(TimestampMixin, db.Model):
    __tablename__ = "incident_attachments"

    id = db.Column(db.Integer, primary_key=True)
    report_id = db.Column(db.Integer, db.ForeignKey("incident_reports.id", ondelete="CASCADE"), nullable=False, index=True)
    file_path = db.Column(db.String(255), nullable=False)
    file_name = db.Column(db.String(255), nullable=False)
    file_type = db.Column(db.String(50), nullable=False)
    file_size = db.Column(db.Integer, nullable=False)
    uploaded_by_id = db.Column(db.Integer, db.ForeignKey("users.id", ondelete="SET NULL"))

    report = db.relationship("IncidentReport", backref=db.backref("attachments", cascade="all, delete-orphan"))
    uploaded_by = db.relationship("User")
