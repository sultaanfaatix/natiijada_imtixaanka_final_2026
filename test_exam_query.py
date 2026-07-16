from app import create_app, db
from app.models import Exam

app = create_app()

with app.app_context():
    count = Exam.query.count()
    print(f'Exam count: {count}')
    print('Exam query successful!')
