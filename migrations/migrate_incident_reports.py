"""
Migration script for Incident Reports system
Creates tables for incident categories, severity levels, actions, reports, and attachments
"""
from datetime import datetime
from app import create_app, db
from app.models import IncidentCategory, SeverityLevel, IncidentAction


def migrate():
    """Create incident report tables and seed default data"""
    app = create_app()
    
    with app.app_context():
        # Create tables
        db.create_all()
        
        # Seed default severity levels
        if not SeverityLevel.query.first():
            severities = [
                {"name": "Minor", "color": "#22c55e", "description": "Minor incident with minimal impact", "sort_order": 1},
                {"name": "Moderate", "color": "#eab308", "description": "Moderate incident requiring attention", "sort_order": 2},
                {"name": "Serious", "color": "#f97316", "description": "Serious incident with significant impact", "sort_order": 3},
                {"name": "Critical", "color": "#ef4444", "description": "Critical incident requiring immediate action", "sort_order": 4},
            ]
            for s in severities:
                db.session.add(SeverityLevel(**s))
        
        # Seed default incident categories
        if not IncidentCategory.query.first():
            categories = [
                {"name": "Talking During Exam", "description": "Student was talking during examination", "sort_order": 1},
                {"name": "Cheating Attempt", "description": "Attempted to cheat during exam", "sort_order": 2},
                {"name": "Using Mobile Phone", "description": "Used mobile phone during examination", "sort_order": 3},
                {"name": "Possession of Unauthorized Materials", "description": "Had unauthorized materials during exam", "sort_order": 4},
                {"name": "Disturbing Other Students", "description": "Disturbed other students during exam", "sort_order": 5},
                {"name": "Disrespecting Invigilator", "description": "Showed disrespect to exam invigilator", "sort_order": 6},
                {"name": "Late Arrival", "description": "Arrived late to examination", "sort_order": 7},
                {"name": "Seat Switching", "description": "Switched seats without permission", "sort_order": 8},
                {"name": "Impersonation", "description": "Attempted to impersonate another student", "sort_order": 9},
                {"name": "Other", "description": "Other type of incident", "sort_order": 10},
            ]
            for c in categories:
                db.session.add(IncidentCategory(**c))
        
        # Seed default incident actions
        if not IncidentAction.query.first():
            actions = [
                {"name": "Warning Given", "description": "Verbal or written warning issued", "sort_order": 1},
                {"name": "Seat Changed", "description": "Student moved to different seat", "sort_order": 2},
                {"name": "Answer Sheet Collected", "description": "Answer sheet was collected", "sort_order": 3},
                {"name": "Mobile Phone Confiscated", "description": "Mobile phone was confiscated", "sort_order": 4},
                {"name": "Student Removed From Exam", "description": "Student was removed from examination", "sort_order": 5},
                {"name": "Sent to Administration", "description": "Student sent to administration office", "sort_order": 6},
                {"name": "Exam Cancelled", "description": "Examination was cancelled", "sort_order": 7},
                {"name": "Other", "description": "Other action taken", "sort_order": 8},
            ]
            for a in actions:
                db.session.add(IncidentAction(**a))
        
        db.session.commit()
        print("Incident Reports migration completed successfully")
        print("Created tables: incident_categories, severity_levels, incident_actions, incident_reports, incident_attachments")
        print("Seeded default severity levels, categories, and actions")


if __name__ == "__main__":
    migrate()
