import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from config import Config


class ReviewConfig(Config):
    SQLALCHEMY_DATABASE_URI = "sqlite:///visual_review.db"
    WTF_CSRF_ENABLED = False
    TESTING = False
    SECRET_KEY = "visual-review-only"


from app import create_app, db
from app.models import AcademicYear, Exam, GradeScale, Result, SchoolClass, Setting, Student, Subject, User
from app.services import DEFAULT_SETTINGS

app = create_app(ReviewConfig)


def seed():
    with app.app_context():
        db.drop_all()
        db.create_all()
        for key, value in DEFAULT_SETTINGS.items():
            db.session.add(Setting(key=key, value=value))
        year = AcademicYear(name="2025-2026", is_current=True)
        school_class = SchoolClass(name="Form 2", description="Secondary class")
        subjects = [
            Subject(name="Mathematics", max_score=100, sort_order=1),
            Subject(name="English", max_score=100, sort_order=2),
            Subject(name="Somali", max_score=100, sort_order=3),
            Subject(name="Biology", max_score=100, sort_order=4),
            Subject(name="Chemistry", max_score=100, sort_order=5),
            Subject(name="Islamic", max_score=100, sort_order=6),
        ]
        db.session.add_all([year, school_class, *subjects])
        db.session.add_all(
            [
                GradeScale(grade="A", min_score=90, max_score=100, comment="Excellent"),
                GradeScale(grade="B", min_score=75, max_score=89.99, comment="Very Good"),
                GradeScale(grade="C", min_score=50, max_score=74.99, comment="Good"),
                GradeScale(grade="F", min_score=0, max_score=49.99, comment="Needs Support"),
            ]
        )
        db.session.flush()
        exam = Exam(name="Second Monthly Exam", academic_year=year, is_published=True)
        student = Student(student_code="3007", full_name="Sumaya Xasan Maxamad Maxamuud", mother_name="Sawdo Iikar Mire", school_class=school_class, academic_year=year)
        locked = Student(student_code="9001", full_name="Locked Student", mother_name="Parent Name", school_class=school_class, academic_year=year, is_result_locked=True, lock_reason="Outstanding School Fees")
        db.session.add_all([exam, student, locked])
        db.session.flush()
        for subject, score in zip(subjects, [96, 88, 91, 84, 79, 94]):
            db.session.add(Result(student=student, exam=exam, subject=subject, score=score, is_published=True))
        admin = User(username="admin", full_name="System Administrator", role="super_admin", is_active=True)
        admin.set_password("Admin@12345")
        db.session.add(admin)
        db.session.commit()


seed()

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5055, debug=False)
