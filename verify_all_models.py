"""Script to verify all models are synchronized with database"""
import sqlite3
import os
from app import create_app, db
from app.models import *

db_path = os.path.join(os.path.dirname(__file__), 'instance', 'visual_review.db')

app = create_app()

with app.app_context():
    # Get all model classes
    models = [
        User, AcademicYear, AcademicLevel, AcademicClass, AcademicSection,
        Subject, Exam, Student, Result, GradeScale, Setting, LabelTranslation,
        IncidentReport, IncidentCategory, SeverityLevel, IncidentAction, ExamInvigilator,
        SchoolClass, Teacher, TeacherPermission, TeacherActivity, TeacherCodeSequence,
        AttendanceRecord, IdCardIssue, AuditLog, ReportVerification
    ]
    
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    all_synced = True
    
    for model in models:
        table_name = model.__tablename__
        
        # Get database schema
        cursor.execute(f"PRAGMA table_info({table_name})")
        db_columns = {col[1]: col[2] for col in cursor.fetchall()}
        
        # Get model columns
        model_columns = {}
        for column in model.__table__.columns:
            col_type = str(column.type)
            model_columns[column.name] = col_type
        
        # Compare
        missing_in_db = set(model_columns.keys()) - set(db_columns.keys())
        extra_in_db = set(db_columns.keys()) - set(model_columns.keys())
        
        if missing_in_db or extra_in_db:
            print(f"\n{'='*60}")
            print(f"Table: {table_name}")
            print(f"{'='*60}")
            
            if missing_in_db:
                print(f"Missing in database: {', '.join(missing_in_db)}")
                all_synced = False
            
            if extra_in_db:
                print(f"Extra in database: {', '.join(extra_in_db)}")
                all_synced = False
        else:
            print(f"[OK] {table_name}: OK")
    
    conn.close()
    
    print(f"\n{'='*60}")
    if all_synced:
        print("[OK] All models are synchronized with database!")
    else:
        print("[ERROR] Some models are not synchronized!")
    print(f"{'='*60}")
