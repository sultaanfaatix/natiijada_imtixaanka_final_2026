"""
Production Schema Verification Script
This script verifies that the production database schema matches the SQLAlchemy models
Run this on Render after migration: python verify_production_schema.py
"""
import sys
from app import create_app, db
from sqlalchemy import inspect

app = create_app()

def verify_schema():
    """Verify the database schema matches the models"""
    with app.app_context():
        print("=" * 70)
        print("PRODUCTION SCHEMA VERIFICATION")
        print("=" * 70)
        
        # Check database type
        db_url = db.engine.url
        print(f"\nDatabase URL: {db_url}")
        print(f"Database Type: {db_url.drivername}")
        
        inspector = inspect(db.engine)
        
        print("\n" + "=" * 70)
        print("STEP 1: Verify incident_reports table structure")
        print("=" * 70)
        
        expected_columns = [
            'id', 'report_number', 'student_id', 'teacher_id', 'user_id', 
            'invigilator_id', 'exam_id', 'subject_id', 'category_id', 
            'severity_id', 'exam_room', 'incident_date', 'incident_time', 
            'description', 'actions_taken', 'status', 'reviewed_by_id', 
            'reviewed_at', 'review_notes', 'created_at', 'updated_at'
        ]
        
        if 'incident_reports' not in inspector.get_table_names():
            print("[ERROR] incident_reports table does not exist!")
            return False
        
        actual_columns = [col['name'] for col in inspector.get_columns('incident_reports')]
        
        print("\nExpected columns:")
        for col in expected_columns:
            status = "[OK]" if col in actual_columns else "[MISSING]"
            print(f"  {status} {col}")
        
        print("\nUnexpected columns:")
        for col in actual_columns:
            if col not in expected_columns:
                print(f"  [EXTRA] {col}")
        
        missing_columns = [col for col in expected_columns if col not in actual_columns]
        
        if missing_columns:
            print(f"\n[ERROR] Missing columns: {', '.join(missing_columns)}")
            return False
        else:
            print("\n[OK] All expected columns present")
        
        print("\n" + "=" * 70)
        print("STEP 2: Verify invigilator_id column details")
        print("=" * 70)
        
        if 'invigilator_id' in actual_columns:
            col_info = inspector.get_columns('incident_reports', 'invigilator_id')[0]
            print(f"Column name: {col_info['name']}")
            print(f"Type: {col_info['type']}")
            print(f"Nullable: {col_info['nullable']}")
            print(f"Default: {col_info['default']}")
            
            # Check for foreign key
            foreign_keys = inspector.get_foreign_keys('incident_reports')
            invigilator_fk = [fk for fk in foreign_keys if 'invigilator_id' in fk['constrained_columns']]
            
            if invigilator_fk:
                fk = invigilator_fk[0]
                print(f"\nForeign key: {fk['name']}")
                print(f"References: {fk['referred_table']}.{fk['referred_columns'][0]}")
                print(f"[OK] Foreign key constraint exists")
            else:
                print("\n[WARNING] No foreign key constraint on invigilator_id")
        else:
            print("[ERROR] invigilator_id column is missing!")
            return False
        
        print("\n" + "=" * 70)
        print("STEP 3: Verify invigilator-related tables")
        print("=" * 70)
        
        required_tables = ['exam_invigilators', 'invigilator_login_history', 'incident_report_settings']
        
        for table in required_tables:
            if table in inspector.get_table_names():
                print(f"[OK] {table} table exists")
            else:
                print(f"[MISSING] {table} table does not exist")
        
        print("\n" + "=" * 70)
        print("STEP 4: Test IncidentReport model query")
        print("=" * 70)
        
        try:
            from app.models import IncidentReport
            count = db.session.query(IncidentReport).count()
            print(f"[OK] IncidentReport.query.count() = {count}")
            
            # Test a query that includes invigilator_id
            reports = db.session.query(IncidentReport).limit(1).all()
            if reports:
                report = reports[0]
                print(f"[OK] Can query IncidentReport records")
                print(f"  Sample report ID: {report.id}")
                print(f"  Sample report invigilator_id: {report.invigilator_id}")
            else:
                print("[OK] IncidentReport table is empty (no records to test)")
                
        except Exception as e:
            print(f"[ERROR] Failed to query IncidentReport: {e}")
            import traceback
            traceback.print_exc()
            return False
        
        print("\n" + "=" * 70)
        print("STEP 5: Verify ExamInvigilator model")
        print("=" * 70)
        
        try:
            from app.models import ExamInvigilator
            if 'exam_invigilators' in inspector.get_table_names():
                count = db.session.query(ExamInvigilator).count()
                print(f"[OK] ExamInvigilator.query.count() = {count}")
                
                # Test relationship
                if 'incident_reports' in inspector.get_table_names():
                    reports = db.session.query(IncidentReport).filter(IncidentReport.invigilator_id.isnot(None)).limit(1).all()
                    if reports:
                        report = reports[0]
                        invigilator = report.invigilator
                        print(f"[OK] Relationship access works (report.invigilator)")
            else:
                print("[WARNING] exam_invigilators table does not exist")
                
        except Exception as e:
            print(f"[ERROR] Failed to query ExamInvigilator: {e}")
            import traceback
            traceback.print_exc()
        
        print("\n" + "=" * 70)
        print("VERIFICATION COMPLETED")
        print("=" * 70)
        
        if missing_columns:
            print("\n[RESULT] SCHEMA MISMATCH DETECTED")
            print(f"Missing columns: {', '.join(missing_columns)}")
            return False
        else:
            print("\n[RESULT] SCHEMA VERIFICATION PASSED")
            print("The production database schema matches the SQLAlchemy models.")
            return True

if __name__ == "__main__":
    try:
        success = verify_schema()
        sys.exit(0 if success else 1)
    except Exception as e:
        print(f"\n[FATAL ERROR] Verification failed: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
