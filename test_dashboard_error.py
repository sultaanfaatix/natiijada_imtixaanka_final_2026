from app import create_app, db
from app.models import Teacher, User
from app.teacher_analytics import dashboard_summary
from app.teacher_portal import parse_teacher_filters

app = create_app()

with app.app_context():
    # Check if any teachers exist
    teachers = Teacher.query.all()
    print(f"Teacher count: {len(teachers)}")
    
    if not teachers:
        print("No teachers in database. Cannot test dashboard.")
    else:
        teacher = teachers[0]
        print(f"Testing with teacher: {teacher.full_name} (ID: {teacher.id})")
        print(f"Teacher user_id: {teacher.user_id}")
        
        # Test dashboard summary
        try:
            filters = parse_teacher_filters({})
            print(f"Filters: {filters}")
            
            summary = dashboard_summary(teacher, filters)
            print("✓ Dashboard summary generated successfully")
            print(f"  Summary keys: {list(summary.keys())}")
            
            # Check each key
            for key in summary:
                value = summary[key]
                print(f"  {key}: {type(value)}")
                if isinstance(value, dict):
                    print(f"    Sub-keys: {list(value.keys())}")
                elif isinstance(value, list):
                    print(f"    List length: {len(value)}")
                    if value and len(value) > 0:
                        print(f"    First item type: {type(value[0])}")
                        if isinstance(value[0], dict):
                            print(f"    First item keys: {list(value[0].keys())}")
                            
        except Exception as e:
            print(f"✗ Error generating dashboard summary: {e}")
            import traceback
            traceback.print_exc()
