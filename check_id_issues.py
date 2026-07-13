from app import create_app, db
from app.models import IdCardIssue, Student

app = create_app()

with app.app_context():
    issues = IdCardIssue.query.limit(5).all()
    print(f'Found {len(issues)} ID card issues')
    for issue in issues:
        print(f'  Token: {issue.token[:20]}... Student: {issue.student.full_name if issue.student else "N/A"}')
    
    if not issues:
        print('No ID card issues found. Creating a test issue...')
        student = Student.query.first()
        if student:
            import secrets
            from datetime import date
            from app.models import AcademicYear
            
            academic_year = AcademicYear.query.first()
            if not academic_year:
                academic_year = AcademicYear(name="2025-2026")
                db.session.add(academic_year)
                db.session.flush()
            
            issue = IdCardIssue(
                token=secrets.token_urlsafe(32),
                student_id=student.id,
                academic_year_id=academic_year.id,
                issue_date=date.today(),
                expiry_date=date(2026, 12, 31),
                status="Active"
            )
            db.session.add(issue)
            db.session.commit()
            print(f'Created test issue with token: {issue.token}')
            print(f'Verification URL: /verify-id/{issue.token}')
        else:
            print('No students found in database')
