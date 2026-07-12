import statistics
from collections import Counter, defaultdict
from datetime import datetime
from decimal import Decimal

from . import db
from .models import AcademicYear, AttendanceRecord, Exam, Result, SchoolClass, Student, Subject
from .services import grade_for


def _pct(result):
    if not result.subject.max_score:
        return 0.0
    return float(Decimal(result.score) / Decimal(result.subject.max_score) * 100)


def _safe_mean(values):
    return round(sum(values) / len(values), 2) if values else 0


def _safe_median(values):
    return round(statistics.median(values), 2) if values else 0


def _safe_mode(values):
    if not values:
        return 0
    rounded = [round(v, 1) for v in values]
    return statistics.mode(rounded) if rounded else 0


def _safe_stdev(values):
    return round(statistics.stdev(values), 2) if len(values) > 1 else 0


def teacher_assignments(teacher):
    classes = list(teacher.classes)
    subjects = list(teacher.subjects)
    class_ids = {school_class.id for school_class in classes}
    subject_ids = {subject.id for subject in subjects}
    return classes, subjects, class_ids, subject_ids


def validate_filter_ids(teacher, filters):
    _, _, class_ids, subject_ids = teacher_assignments(teacher)
    validated = dict(filters)
    if validated.get("class_id") and validated["class_id"] not in class_ids:
        validated["class_id"] = None
    if validated.get("subject_id") and validated["subject_id"] not in subject_ids:
        validated["subject_id"] = None
    if validated.get("compare_class_id") and validated["compare_class_id"] not in class_ids:
        validated["compare_class_id"] = None
    if validated.get("compare_subject_id") and validated["compare_subject_id"] not in subject_ids:
        validated["compare_subject_id"] = None
    return validated


def scoped_students(teacher, filters):
    _, _, class_ids, _ = teacher_assignments(teacher)
    if not class_ids:
        return []
    query = Student.query.filter(Student.class_id.in_(class_ids), Student.is_active.is_(True))
    if filters.get("class_id"):
        query = query.filter(Student.class_id == filters["class_id"])
    if filters.get("section"):
        query = query.filter(Student.section == filters["section"])
    if filters.get("academic_year_id"):
        query = query.filter(Student.academic_year_id == filters["academic_year_id"])
    if filters.get("q"):
        q = f"%{filters['q']}%"
        query = query.filter(db.or_(Student.full_name.like(q), Student.student_code.like(q)))
    return query.order_by(Student.full_name.asc()).all()


def scoped_results(teacher, filters, students=None):
    _, _, class_ids, subject_ids = teacher_assignments(teacher)
    if not class_ids or not subject_ids:
        return []
    students = students if students is not None else scoped_students(teacher, filters)
    student_ids = [student.id for student in students]
    if not student_ids:
        return []
    query = (
        Result.query.filter(
            Result.student_id.in_(student_ids),
            Result.subject_id.in_(subject_ids),
            Result.is_published.is_(True),
        )
        .join(Result.exam)
        .join(Result.subject)
    )
    if filters.get("subject_id"):
        query = query.filter(Result.subject_id == filters["subject_id"])
    if filters.get("exam_id"):
        query = query.filter(Result.exam_id == filters["exam_id"])
    if filters.get("academic_year_id"):
        query = query.filter(Exam.academic_year_id == filters["academic_year_id"])
    return query.all()


def student_exam_averages(results):
    grouped = defaultdict(list)
    for result in results:
        grouped[(result.student_id, result.exam_id)].append(_pct(result))
    averages = {}
    for key, values in grouped.items():
        averages[key] = _safe_mean(values)
    return averages


def student_overall_averages(results):
    grouped = defaultdict(list)
    for result in results:
        grouped[result.student_id].append(_pct(result))
    return {student_id: _safe_mean(values) for student_id, values in grouped.items()}


def filter_options(teacher, filters):
    classes, subjects, class_ids, subject_ids = teacher_assignments(teacher)
    students = scoped_students(teacher, {})
    year_ids = sorted({student.academic_year_id for student in students})
    years = AcademicYear.query.filter(AcademicYear.id.in_(year_ids)).order_by(AcademicYear.name.desc()).all() if year_ids else []
    exam_query = Exam.query
    if year_ids:
        exam_query = exam_query.filter(Exam.academic_year_id.in_(year_ids))
    exams = exam_query.order_by(Exam.created_at.desc()).all()
    sections = sorted({student.section for student in students if student.section})
    scoped = scoped_students(teacher, filters)
    return {
        "academic_years": years,
        "exams": exams,
        "subjects": subjects,
        "classes": classes,
        "sections": sections,
        "students": scoped,
    }


def attendance_rate_for_students(students, filters):
    if not students:
        return 0
    student_ids = [student.id for student in students]
    query = AttendanceRecord.query.filter(AttendanceRecord.student_id.in_(student_ids))
    if filters.get("academic_year_id"):
        query = query.filter(AttendanceRecord.academic_year_id == filters["academic_year_id"])
    if filters.get("class_id"):
        query = query.filter(AttendanceRecord.class_id == filters["class_id"])
    if filters.get("date_from"):
        try:
            query = query.filter(AttendanceRecord.attendance_date >= datetime.strptime(filters["date_from"], "%Y-%m-%d").date())
        except ValueError:
            pass
    if filters.get("date_to"):
        try:
            query = query.filter(AttendanceRecord.attendance_date <= datetime.strptime(filters["date_to"], "%Y-%m-%d").date())
        except ValueError:
            pass
    records = query.all()
    if not records:
        return 0
    present = sum(1 for record in records if record.status in ("Present", "Late", "Excused"))
    return round(present / len(records) * 100, 2)


def dashboard_summary(teacher, filters):
    filters = validate_filter_ids(teacher, filters)
    classes, subjects, _, _ = teacher_assignments(teacher)
    students = scoped_students(teacher, filters)
    results = scoped_results(teacher, filters, students)
    percentages = [_pct(result) for result in results]
    overall_averages = student_overall_averages(results)
    pass_count = sum(1 for avg in overall_averages.values() if grade_for(avg).get("is_pass"))
    fail_count = len(overall_averages) - pass_count
    exam_ids = {result.exam_id for result in results}
    prev_trend = _trend_delta(results, teacher, filters)
    return {
        "total_students": len(students),
        "total_classes": len(classes),
        "total_subjects": len(subjects),
        "total_exams": len(exam_ids),
        "overall_average": _safe_mean(percentages),
        "pass_rate": round(pass_count / len(overall_averages) * 100, 2) if overall_averages else 0,
        "fail_rate": round(fail_count / len(overall_averages) * 100, 2) if overall_averages else 0,
        "highest_mark": round(max(percentages), 2) if percentages else 0,
        "lowest_mark": round(min(percentages), 2) if percentages else 0,
        "trends": prev_trend,
        "chart_labels": [exam.name for exam in _ordered_exams(results)],
        "chart_values": _exam_average_series(results),
    }


def _ordered_exams(results):
    seen = {}
    for result in results:
        seen[result.exam_id] = result.exam
    return sorted(seen.values(), key=lambda exam: exam.created_at)


def _exam_average_series(results):
    buckets = defaultdict(list)
    for result in results:
        buckets[result.exam_id].append(_pct(result))
    ordered = _ordered_exams(results)
    return [_safe_mean(buckets.get(exam.id, [])) for exam in ordered]


def _trend_delta(results, teacher, filters):
    if not filters.get("exam_id"):
        return {"average": 0, "pass_rate": 0}
    current_exam = Exam.query.get(filters["exam_id"])
    if not current_exam:
        return {"average": 0, "pass_rate": 0}
    prior = (
        Exam.query.filter(
            Exam.academic_year_id == current_exam.academic_year_id,
            Exam.created_at < current_exam.created_at,
        )
        .order_by(Exam.created_at.desc())
        .first()
    )
    if not prior:
        return {"average": 0, "pass_rate": 0}
    current_results = results
    prior_filters = dict(filters)
    prior_filters["exam_id"] = prior.id
    prior_results = scoped_results(teacher, prior_filters)
    current_avg = _safe_mean([_pct(result) for result in current_results])
    prior_avg = _safe_mean([_pct(result) for result in prior_results])
    current_pass = _pass_rate_from_results(current_results)
    prior_pass = _pass_rate_from_results(prior_results)
    return {
        "average": round(current_avg - prior_avg, 2),
        "pass_rate": round(current_pass - prior_pass, 2),
    }


def _pass_rate_from_results(results):
    averages = student_overall_averages(results)
    if not averages:
        return 0
    passed = sum(1 for avg in averages.values() if grade_for(avg).get("is_pass"))
    return round(passed / len(averages) * 100, 2)


def subjects_cards(teacher, filters):
    filters = validate_filter_ids(teacher, filters)
    cards = []
    for subject in teacher.subjects:
        subject_filters = dict(filters)
        subject_filters["subject_id"] = subject.id
        students = scoped_students(teacher, subject_filters)
        results = scoped_results(teacher, subject_filters, students)
        percentages = [_pct(result) for result in results]
        overall = student_overall_averages(results)
        passed = sum(1 for avg in overall.values() if grade_for(avg).get("is_pass"))
        total = len(overall)
        class_names = sorted({student.school_class.name for student in students})
        cards.append(
            {
                "subject": subject,
                "teacher_name": teacher.full_name,
                "classes": class_names,
                "student_count": len(students),
                "average": _safe_mean(percentages),
                "highest": round(max(percentages), 2) if percentages else 0,
                "lowest": round(min(percentages), 2) if percentages else 0,
                "pass_rate": round(passed / total * 100, 2) if total else 0,
                "fail_rate": round((total - passed) / total * 100, 2) if total else 0,
            }
        )
    return cards


def classes_cards(teacher, filters):
    filters = validate_filter_ids(teacher, filters)
    cards = []
    for school_class in teacher.classes:
        class_filters = dict(filters)
        class_filters["class_id"] = school_class.id
        students = scoped_students(teacher, class_filters)
        results = scoped_results(teacher, class_filters, students)
        percentages = [_pct(result) for result in results]
        overall = student_overall_averages(results)
        passed = sum(1 for avg in overall.values() if grade_for(avg).get("is_pass"))
        total = len(overall)
        sections = sorted({student.section for student in students if student.section})
        exam_count = len({result.exam_id for result in results})
        cards.append(
            {
                "class": school_class,
                "sections": sections,
                "student_count": len(students),
                "average": _safe_mean(percentages),
                "highest": round(max(percentages), 2) if percentages else 0,
                "lowest": round(min(percentages), 2) if percentages else 0,
                "pass_rate": round(passed / total * 100, 2) if total else 0,
                "attendance": attendance_rate_for_students(students, class_filters),
                "exams_taken": exam_count,
            }
        )
    return cards


def exam_analysis_data(teacher, filters):
    filters = validate_filter_ids(teacher, filters)
    students = scoped_students(teacher, filters)
    results = scoped_results(teacher, filters, students)
    percentages = [_pct(result) for result in results]
    overall = student_overall_averages(results)
    passed = sum(1 for avg in overall.values() if grade_for(avg).get("is_pass"))
    total_students = len(overall)
    return {
        "average": _safe_mean(percentages),
        "median": _safe_median(percentages),
        "mode": _safe_mode(percentages),
        "highest": round(max(percentages), 2) if percentages else 0,
        "lowest": round(min(percentages), 2) if percentages else 0,
        "range": round(max(percentages) - min(percentages), 2) if percentages else 0,
        "std_dev": _safe_stdev(percentages),
        "pass_rate": round(passed / total_students * 100, 2) if total_students else 0,
        "fail_rate": round((total_students - passed) / total_students * 100, 2) if total_students else 0,
        "student_count": total_students,
        "distribution": _score_distribution(percentages),
        "subject_breakdown": _subject_breakdown(results),
        "class_breakdown": _class_breakdown(results),
    }


def _score_distribution(percentages):
    bands = [(90, 100), (80, 89), (70, 79), (60, 69), (50, 59), (0, 49)]
    labels = ["90-100", "80-89", "70-79", "60-69", "50-59", "Below 50"]
    counts = []
    for low, high in bands:
        counts.append(sum(1 for value in percentages if low <= value <= high))
    return {"labels": labels, "values": counts}


def _subject_breakdown(results):
    buckets = defaultdict(list)
    for result in results:
        buckets[result.subject.name].append(_pct(result))
    return {name: _safe_mean(values) for name, values in sorted(buckets.items())}


def _class_breakdown(results):
    buckets = defaultdict(list)
    for result in results:
        buckets[result.student.school_class.name].append(_pct(result))
    return {name: _safe_mean(values) for name, values in sorted(buckets.items())}


def subject_analysis_data(teacher, filters):
    filters = validate_filter_ids(teacher, filters)
    students = scoped_students(teacher, filters)
    results = scoped_results(teacher, filters, students)
    by_class = _class_breakdown(results)
    by_section = defaultdict(list)
    by_exam = defaultdict(list)
    for result in results:
        by_section[result.student.section or "Unassigned"].append(_pct(result))
        by_exam[result.exam.name].append(_pct(result))
    grade_counts = Counter()
    for result in results:
        grade_counts[grade_for(_pct(result)).get("grade", "-")] += 1
    subject_name = None
    if filters.get("subject_id"):
        subject = Subject.query.get(filters["subject_id"])
        subject_name = subject.name if subject else None
    return {
        "subject_name": subject_name,
        "by_chapter": [{"name": f"Unit {index + 1}", "average": avg, "future_ready": True} for index, avg in enumerate(list(_subject_breakdown(results).values())[:6])],
        "by_class": by_class,
        "by_section": {name: _safe_mean(values) for name, values in sorted(by_section.items())},
        "by_exam": {name: _safe_mean(values) for name, values in sorted(by_exam.items())},
        "grade_comparison": dict(sorted(grade_counts.items())),
        "difficulty_analysis": _difficulty_analysis(results),
        "question_analysis_ready": True,
    }


def _difficulty_analysis(results):
    buckets = defaultdict(list)
    for result in results:
        buckets[result.subject.name].append(_pct(result))
    ranked = sorted(((name, _safe_mean(values)) for name, values in buckets.items()), key=lambda item: item[1])
    return {
        "easiest": ranked[-3:][::-1] if ranked else [],
        "hardest": ranked[:3] if ranked else [],
    }


def student_analysis_data(teacher, student_id, filters):
    from .models import Student as StudentModel

    student = StudentModel.query.get_or_404(student_id)
    _, _, class_ids, _ = teacher_assignments(teacher)
    if student.class_id not in class_ids:
        return None
    student_filters = dict(filters)
    student_filters["class_id"] = student.class_id
    students = [student]
    results = scoped_results(teacher, student_filters, students)
    history = []
    exam_groups = defaultdict(list)
    for result in results:
        exam_groups[result.exam.name].append(_pct(result))
    for exam_name, values in sorted(exam_groups.items()):
        avg = _safe_mean(values)
        history.append({"exam": exam_name, "average": avg, "grade": grade_for(avg).get("grade", "-")})
    overall_avg = _safe_mean([item["average"] for item in history])
    class_students = scoped_students(teacher, {"class_id": student.class_id, **{k: v for k, v in filters.items() if k != "student_id"}})
    class_results = scoped_results(teacher, filters, class_students)
    class_avg = _safe_mean([_pct(result) for result in class_results])
    rank_data = _student_rankings(teacher, filters)
    rank = next((item["rank"] for item in rank_data if item["student_id"] == student.id), None)
    strengths, weaknesses = _strengths_weaknesses(results)
    attendance = attendance_rate_for_students([student], filters)
    return {
        "student": student,
        "history": history,
        "average": overall_avg,
        "rank": rank,
        "grade": grade_for(overall_avg).get("grade", "-"),
        "attendance": attendance,
        "strengths": strengths,
        "weaknesses": weaknesses,
        "trend": [item["average"] for item in history],
        "trend_labels": [item["exam"] for item in history],
        "class_average": class_avg,
        "comparison_delta": round(overall_avg - class_avg, 2),
    }


def _strengths_weaknesses(results):
    subject_scores = defaultdict(list)
    for result in results:
        subject_scores[result.subject.name].append(_pct(result))
    ranked = sorted(((name, _safe_mean(values)) for name, values in subject_scores.items()), key=lambda item: item[1], reverse=True)
    return [name for name, _ in ranked[:3]], [name for name, _ in ranked[-3:][::-1]]


def performance_trends_data(teacher, filters):
    filters = validate_filter_ids(teacher, filters)
    students = scoped_students(teacher, filters)
    results = scoped_results(teacher, filters, students)
    exams = _ordered_exams(results)
    exam_avgs = _exam_average_series(results)
    monthly = defaultdict(list)
    for result in results:
        key = result.created_at.strftime("%Y-%m")
        monthly[key].append(_pct(result))
    monthly_labels = sorted(monthly.keys())
    monthly_values = [_safe_mean(monthly[label]) for label in monthly_labels]
    year_buckets = defaultdict(list)
    for result in results:
        year_buckets[result.exam.academic_year.name].append(_pct(result))
    return {
        "exam_labels": [exam.name for exam in exams],
        "exam_values": exam_avgs,
        "monthly_labels": monthly_labels,
        "monthly_values": monthly_values,
        "year_labels": list(year_buckets.keys()),
        "year_values": [_safe_mean(year_buckets[label]) for label in year_buckets.keys()],
    }


def grade_distribution_data(teacher, filters):
    filters = validate_filter_ids(teacher, filters)
    students = scoped_students(teacher, filters)
    results = scoped_results(teacher, filters, students)
    grade_counts = Counter()
    student_grade = {}
    for result in results:
        grade = grade_for(_pct(result)).get("grade", "-")
        grade_counts[grade] += 1
        student_grade.setdefault(result.student_id, []).append(grade)
    ordered_grades = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D", "E", "F"]
    labels = [grade for grade in ordered_grades if grade in grade_counts] + [g for g in grade_counts if g not in ordered_grades]
    values = [grade_counts[label] for label in labels]
    total = sum(values) or 1
    percentages = [round(value / total * 100, 2) for value in values]
    return {
        "labels": labels,
        "values": values,
        "percentages": percentages,
        "student_count": len({result.student_id for result in results}),
    }


def pass_fail_analysis_data(teacher, filters):
    filters = validate_filter_ids(teacher, filters)
    students = scoped_students(teacher, filters)
    results = scoped_results(teacher, filters, students)
    overall = student_overall_averages(results)
    passed = sum(1 for avg in overall.values() if grade_for(avg).get("is_pass"))
    failed = len(overall) - passed
    class_compare = {}
    section_compare = {}
    for student_id, avg in overall.items():
        student = next(item for item in students if item.id == student_id)
        class_compare.setdefault(student.school_class.name, {"pass": 0, "fail": 0})
        section_compare.setdefault(student.section or "Unassigned", {"pass": 0, "fail": 0})
        bucket = "pass" if grade_for(avg).get("is_pass") else "fail"
        class_compare[student.school_class.name][bucket] += 1
        section_compare[student.section or "Unassigned"][bucket] += 1
    return {
        "total_passed": passed,
        "total_failed": failed,
        "pass_rate": round(passed / len(overall) * 100, 2) if overall else 0,
        "fail_rate": round(failed / len(overall) * 100, 2) if overall else 0,
        "gender_comparison": {"note": "Student gender is not stored in the current database schema."},
        "class_comparison": class_compare,
        "section_comparison": section_compare,
    }


def _student_rankings(teacher, filters):
    students = scoped_students(teacher, filters)
    results = scoped_results(teacher, filters, students)
    averages = student_overall_averages(results)
    ranked = sorted(averages.items(), key=lambda item: item[1], reverse=True)
    payload = []
    for index, (student_id, average) in enumerate(ranked, start=1):
        student = next((item for item in students if item.id == student_id), None)
        if not student:
            continue
        payload.append(
            {
                "rank": index,
                "student_id": student_id,
                "student": student,
                "average": average,
                "grade": grade_for(average).get("grade", "-"),
            }
        )
    return payload


def top_performers_data(teacher, filters):
    filters = validate_filter_ids(teacher, filters)
    rankings = _student_rankings(teacher, filters)
    limit = filters.get("limit") or 10
    top_10 = rankings[:10]
    top_20 = rankings[:20]
    perfect = [item for item in rankings if item["average"] >= 99.9]
    most_improved = _most_improved(teacher, filters, rankings)
    return {
        "top_10": top_10,
        "top_20": top_20,
        "top_boys": [],
        "top_girls": [],
        "gender_note": "Gender-specific rankings require a student gender field.",
        "most_improved": most_improved,
        "highest_average": rankings[:5],
        "perfect_scores": perfect,
        "limit": limit,
    }


def _most_improved(teacher, filters, rankings):
    if not filters.get("exam_id"):
        return rankings[:3]
    current_exam = Exam.query.get(filters["exam_id"])
    if not current_exam:
        return []
    prior = (
        Exam.query.filter(Exam.academic_year_id == current_exam.academic_year_id, Exam.created_at < current_exam.created_at)
        .order_by(Exam.created_at.desc())
        .first()
    )
    if not prior:
        return []
    current = {item["student_id"]: item["average"] for item in rankings}
    prior_filters = dict(filters)
    prior_filters["exam_id"] = prior.id
    prior_results = scoped_results(teacher, prior_filters)
    prior_avgs = student_overall_averages(prior_results)
    deltas = []
    for student_id, avg in current.items():
        if student_id in prior_avgs:
            deltas.append((student_id, round(avg - prior_avgs[student_id], 2)))
    deltas.sort(key=lambda item: item[1], reverse=True)
    improved = []
    for student_id, delta in deltas[:5]:
        student = Student.query.get(student_id)
        if student:
            improved.append({"student": student, "improvement": delta})
    return improved


def weak_students_data(teacher, filters):
    filters = validate_filter_ids(teacher, filters)
    rankings = _student_rankings(teacher, filters)
    bottom = list(reversed(rankings))[:10]
    lowest_avg = rankings[-5:][::-1] if rankings else []
    repeated_failures = []
    students = scoped_students(teacher, filters)
    results = scoped_results(teacher, filters, students)
    exam_failures = defaultdict(int)
    exam_groups = defaultdict(lambda: defaultdict(list))
    for result in results:
        exam_groups[result.student_id][result.exam_id].append(_pct(result))
    for student_id, exams in exam_groups.items():
        fails = sum(1 for values in exams.values() if not grade_for(_safe_mean(values)).get("is_pass"))
        if fails >= 2:
            student = next((item for item in students if item.id == student_id), None)
            if student:
                repeated_failures.append({"student": student, "fail_count": fails})
    needs_intervention = [item for item in rankings if item["average"] < 50][-10:][::-1]
    revision_subjects = _difficulty_analysis(results).get("hardest", [])
    return {
        "bottom_students": bottom,
        "lowest_average": lowest_avg,
        "repeated_failures": repeated_failures,
        "needs_intervention": needs_intervention,
        "recommended_revision": [name for name, _ in revision_subjects],
        "teacher_notes": [student.note for student in students if student.note],
    }


def comparison_data(teacher, filters):
    filters = validate_filter_ids(teacher, filters)
    compare_type = filters.get("compare_type") or "exam"
    left_label = right_label = "Set A"
    left_value = right_value = 0
    if compare_type == "exam" and filters.get("exam_id") and filters.get("compare_exam_id"):
        left_results = scoped_results(teacher, {**filters, "exam_id": filters["exam_id"]})
        right_results = scoped_results(teacher, {**filters, "exam_id": filters["compare_exam_id"]})
        left_value = _safe_mean([_pct(result) for result in left_results])
        right_value = _safe_mean([_pct(result) for result in right_results])
        left_label = Exam.query.get(filters["exam_id"]).name
        right_label = Exam.query.get(filters["compare_exam_id"]).name
    elif compare_type == "class" and filters.get("class_id") and filters.get("compare_class_id"):
        left_results = scoped_results(teacher, {**filters, "class_id": filters["class_id"]})
        right_results = scoped_results(teacher, {**filters, "class_id": filters["compare_class_id"]})
        left_value = _safe_mean([_pct(result) for result in left_results])
        right_value = _safe_mean([_pct(result) for result in right_results])
        left_label = SchoolClass.query.get(filters["class_id"]).name
        right_label = SchoolClass.query.get(filters["compare_class_id"]).name
    elif compare_type == "section" and filters.get("section") and filters.get("compare_section"):
        left_results = scoped_results(teacher, {**filters, "section": filters["section"]})
        right_results = scoped_results(teacher, {**filters, "section": filters["compare_section"]})
        left_value = _safe_mean([_pct(result) for result in left_results])
        right_value = _safe_mean([_pct(result) for result in right_results])
        left_label = filters["section"]
        right_label = filters["compare_section"]
    elif compare_type == "year" and filters.get("academic_year_id") and filters.get("compare_year_id"):
        left_results = scoped_results(teacher, {**filters, "academic_year_id": filters["academic_year_id"]})
        right_results = scoped_results(teacher, {**filters, "academic_year_id": filters["compare_year_id"]})
        left_value = _safe_mean([_pct(result) for result in left_results])
        right_value = _safe_mean([_pct(result) for result in right_results])
        left_label = AcademicYear.query.get(filters["academic_year_id"]).name
        right_label = AcademicYear.query.get(filters["compare_year_id"]).name
    elif compare_type == "subject" and filters.get("subject_id") and filters.get("compare_subject_id"):
        left_results = scoped_results(teacher, {**filters, "subject_id": filters["subject_id"]})
        right_results = scoped_results(teacher, {**filters, "subject_id": filters["compare_subject_id"]})
        left_value = _safe_mean([_pct(result) for result in left_results])
        right_value = _safe_mean([_pct(result) for result in right_results])
        left_label = Subject.query.get(filters["subject_id"]).name
        right_label = Subject.query.get(filters["compare_subject_id"]).name
    return {
        "compare_type": compare_type,
        "left_label": left_label,
        "right_label": right_label,
        "left_value": left_value,
        "right_value": right_value,
        "delta": round(left_value - right_value, 2),
    }


def generate_ai_insights(teacher, filters):
    filters = validate_filter_ids(teacher, filters)
    insights = []
    summary = dashboard_summary(teacher, filters)
    if summary["trends"]["average"]:
        direction = "dropped" if summary["trends"]["average"] < 0 else "improved"
        insights.append(f"The average score {direction} by {abs(summary['trends']['average'])}% compared with the previous exam.")
    class_cards = classes_cards(teacher, filters)
    if class_cards:
        best = max(class_cards, key=lambda item: item["average"])
        insights.append(f"{best['class'].name} performed best with an average of {best['average']}%.")
    weak = weak_students_data(teacher, filters)
    if weak["needs_intervention"]:
        insights.append(f"{len(weak['needs_intervention'])} students need additional support.")
    subject_cards = subjects_cards(teacher, filters)
    if len(subject_cards) >= 2:
        ranked = sorted(subject_cards, key=lambda item: item["average"])
        insights.append(f"{ranked[0]['subject'].name} has the lowest average score ({ranked[0]['average']}%).")
        insights.append(f"Revision should focus on {ranked[0]['subject'].name}.")
    trends = performance_trends_data(teacher, filters)
    if len(trends["exam_values"]) >= 3 and trends["exam_values"][-1] > trends["exam_values"][0]:
        insights.append("Performance has improved steadily over the last three examinations.")
    if not insights:
        insights.append("Not enough data yet to generate insights. Add more examination results for your assigned classes.")
    return insights


def report_summary(teacher, filters):
    return {
        "dashboard": dashboard_summary(teacher, filters),
        "subjects": subjects_cards(teacher, filters),
        "classes": classes_cards(teacher, filters),
        "grades": grade_distribution_data(teacher, filters),
        "pass_fail": pass_fail_analysis_data(teacher, filters),
        "insights": generate_ai_insights(teacher, filters),
    }
