"""Test script to verify incident report submission with invigilator_id"""
import sys
sys.path.insert(0, '.')

from app import create_app, db
from app.models import IncidentReport, Student, ExamInvigilator, IncidentCategory, SeverityLevel
from datetime import date, time

app = create_app()

with app.app_context():
    print("Testing Incident Report Submission with invigilator_id...")
    print("=" * 60)
    
    # Get test data
    student = Student.query.first()
    invigilator = ExamInvigilator.query.first()
    category = IncidentCategory.query.first()
    severity = SeverityLevel.query.first()
    
    if not all([student, invigilator, category, severity]):
        print("Missing test data. Creating test records...")
        
        if not category:
            category = IncidentCategory(name="Test Category", description="Test")
            db.session.add(category)
        
        if not severity:
            severity = SeverityLevel(name="Low", level=1, color="green")
            db.session.add(severity)
        
        if not invigilator:
            from werkzeug.security import generate_password_hash
            invigilator = ExamInvigilator(
                invigilator_id="TEST001",
                username="test_invigilator",
                password_hash=generate_password_hash("test123"),
                full_name="Test Invigilator",
                role="Invigilator"
            )
            db.session.add(invigilator)
        
        db.session.commit()
        
        # Refresh
        invigilator = ExamInvigilator.query.first()
        category = IncidentCategory.query.first()
        severity = SeverityLevel.query.first()
    
    print(f"Student: {student.student_id if student else 'None'}")
    print(f"Invigilator: {invigilator.username if invigilator else 'None'}")
    print(f"Category: {category.name if category else 'None'}")
    print(f"Severity: {severity.name if severity else 'None'}")
    
    # Test creating incident report with invigilator_id
    try:
        import random
        import string
        
        report_num = f"INC-{date.today().strftime('%Y%m%d')}-{''.join(random.choices(string.digits, k=4))}"
        
        report = IncidentReport(
            report_number=report_num,
            student_id=student.id if student else 1,
            invigilator_id=invigilator.id if invigilator else None,
            teacher_id=None,
            user_id=None,
            category_id=category.id if category else 1,
            severity_id=severity.id if severity else 1,
            exam_id=None,
            subject_id=None,
            exam_room="Room 101",
            incident_date=date.today(),
            incident_time=time(10, 30),
            description="Test incident report with invigilator",
            actions_taken="Test action",
            status="Pending Review"
        )
        
        db.session.add(report)
        db.session.commit()
        
        print(f"\n[OK] Incident report created successfully")
        print(f"  Report Number: {report.report_number}")
        print(f"  Invigilator ID: {report.invigilator_id}")
        print(f"  Status: {report.status}")
        
        # Verify the report was saved with invigilator_id
        saved_report = IncidentReport.query.filter_by(report_number=report_num).first()
        if saved_report and saved_report.invigilator_id == invigilator.id:
            print(f"[OK] Report saved with correct invigilator_id: {saved_report.invigilator_id}")
        else:
            print(f"[ERROR] Report invigilator_id mismatch")
        
        # Test relationship access
        if saved_report:
            invigilator_from_report = saved_report.invigilator
            if invigilator_from_report:
                print(f"[OK] Relationship access works: {invigilator_from_report.username}")
            else:
                print(f"[OK] Relationship returns None (expected if no invigilator)")
        
        # Clean up test report
        db.session.delete(saved_report)
        db.session.commit()
        print(f"[OK] Test report cleaned up")
        
    except Exception as e:
        db.session.rollback()
        print(f"[ERROR] Failed to create incident report: {e}")
        import traceback
        traceback.print_exc()
    
    print("\n" + "=" * 60)
    print("Incident Report Submission Test Completed!")
    print("=" * 60)
