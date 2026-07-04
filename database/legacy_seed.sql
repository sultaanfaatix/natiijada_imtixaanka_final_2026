USE exam_results;

INSERT INTO academic_years (name, is_current) VALUES ('2024-2025', TRUE) ON DUPLICATE KEY UPDATE name = VALUES(name);

INSERT INTO school_classes (name) VALUES ('5aad') ON DUPLICATE KEY UPDATE name = VALUES(name);
INSERT INTO school_classes (name) VALUES ('6aad') ON DUPLICATE KEY UPDATE name = VALUES(name);
INSERT INTO school_classes (name) VALUES ('6aad A') ON DUPLICATE KEY UPDATE name = VALUES(name);
INSERT INTO school_classes (name) VALUES ('7aad') ON DUPLICATE KEY UPDATE name = VALUES(name);
INSERT INTO school_classes (name) VALUES ('8aad') ON DUPLICATE KEY UPDATE name = VALUES(name);
INSERT INTO school_classes (name) VALUES ('Form 0') ON DUPLICATE KEY UPDATE name = VALUES(name);
INSERT INTO school_classes (name) VALUES ('Form 1') ON DUPLICATE KEY UPDATE name = VALUES(name);
INSERT INTO school_classes (name) VALUES ('Form 2') ON DUPLICATE KEY UPDATE name = VALUES(name);

INSERT INTO subjects (name, max_score, sort_order) VALUES ('Af-Soomaali', 100, 1) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Arabic', 100, 2) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Bayooliji', 100, 3) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Biology', 100, 4) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Business', 100, 5) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Carabi', 100, 6) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Chemistry', 100, 7) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Cilmi_Bulsho', 100, 8) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('English', 100, 9) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Fisigis', 100, 10) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Ganacsi', 100, 11) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Geography', 100, 12) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('History', 100, 13) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Ingiriisi', 100, 14) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Islamic', 100, 15) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Juqraafi', 100, 16) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Kimistari', 100, 17) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Math', 100, 18) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Physics', 100, 19) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Saynis', 100, 20) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Seynis', 100, 21) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Somali', 100, 22) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Soomaali', 100, 23) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Taariikh', 100, 24) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Tarbiya', 100, 25) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Tarbiyo', 100, 26) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Technology', 100, 27) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Teknooloji', 100, 28) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);
INSERT INTO subjects (name, max_score, sort_order) VALUES ('Xisaab', 100, 29) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);

INSERT INTO exams (name, academic_year_id, is_published)
SELECT 'Second Monthly Exam', id, TRUE FROM academic_years WHERE name = '2024-2025'
ON DUPLICATE KEY UPDATE is_published = TRUE;

INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '001', 'Sultaan Faatix', 'Hani Cumar Maxamuud', c.id, y.id, 'waxaad muujisay karti iyo dedaal aad u wanaagsan. waxaad ku guulaysatay inaad noqoto ardayda ugu fiican fasalka! 🎉Horumar wanaagsan!', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 0' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 90.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '001' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 89.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '001' AND ex.name = 'Second Monthly Exam' AND su.name = 'Fisigis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 95.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '001' AND ex.name = 'Second Monthly Exam' AND su.name = 'Bayooliji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 80.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '001' AND ex.name = 'Second Monthly Exam' AND su.name = 'Kimistari'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 70.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '001' AND ex.name = 'Second Monthly Exam' AND su.name = 'Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 90.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '001' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '001' AND ex.name = 'Second Monthly Exam' AND su.name = 'Ingiriisi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '001' AND ex.name = 'Second Monthly Exam' AND su.name = 'Juqraafi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '001' AND ex.name = 'Second Monthly Exam' AND su.name = 'Taariikh'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '001' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiya'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '001' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '001' AND ex.name = 'Second Monthly Exam' AND su.name = 'Ganacsi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '002', 'Xayaat Faatix', 'Hani Cumar Maxamuud', c.id, y.id, 'waxaad u baahan tahay inaad sii kobciso maadooyinka Bayoolijiga, Juqraafiga iyo kuwa luuqadaha.', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 0' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 70.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '002' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 75.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '002' AND ex.name = 'Second Monthly Exam' AND su.name = 'Fisigis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 55.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '002' AND ex.name = 'Second Monthly Exam' AND su.name = 'Bayooliji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 80.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '002' AND ex.name = 'Second Monthly Exam' AND su.name = 'Kimistari'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 65.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '002' AND ex.name = 'Second Monthly Exam' AND su.name = 'Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 60.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '002' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 58.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '002' AND ex.name = 'Second Monthly Exam' AND su.name = 'Ingiriisi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 60.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '002' AND ex.name = 'Second Monthly Exam' AND su.name = 'Juqraafi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '002' AND ex.name = 'Second Monthly Exam' AND su.name = 'Taariikh'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '002' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiya'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 84.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '002' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '002' AND ex.name = 'Second Monthly Exam' AND su.name = 'Ganacsi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '003', 'Xanaan Faatix', 'Hani Cumar Maxamuud', c.id, y.id, 'waan ka xumahay si aad u hesho ama aad u aragto natiijadaada imtixaanka, fadlan iska xali xafiiska maaliyadda dugsiga.', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 0' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '003' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '003' AND ex.name = 'Second Monthly Exam' AND su.name = 'Fisigis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '003' AND ex.name = 'Second Monthly Exam' AND su.name = 'Bayooliji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '003' AND ex.name = 'Second Monthly Exam' AND su.name = 'Kimistari'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '003' AND ex.name = 'Second Monthly Exam' AND su.name = 'Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '003' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '003' AND ex.name = 'Second Monthly Exam' AND su.name = 'Ingiriisi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '003' AND ex.name = 'Second Monthly Exam' AND su.name = 'Juqraafi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '003' AND ex.name = 'Second Monthly Exam' AND su.name = 'Taariikh'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '003' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiya'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '003' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '003' AND ex.name = 'Second Monthly Exam' AND su.name = 'Ganacsi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '40', 'Axmed Cabdi Cali', 'Hooyo Maryan Isak Ali', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 2' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 53.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '40' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 70.95, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '40' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 68.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '40' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 60.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '40' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 58.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '40' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 77.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '40' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 82.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '40' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 81.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '40' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 70.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '40' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '40' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 74.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '40' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 59.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '40' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '93', 'Axmed Ibraahim C/Lle', 'Hooyo Madiino Xasan Axmed', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 2' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 71.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '93' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 63.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '93' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 56.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '93' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 63.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '93' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 64.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '93' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 50.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '93' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 81.30, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '93' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 93.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '93' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 72.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '93' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 59.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '93' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 75.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '93' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 79.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '93' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '82', 'Cabdisalaam Muxudiin C/Lle', 'Hooyo Muslimo Muxudiin Cali', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 2' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '82' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 73.90, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '82' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 93.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '82' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 82.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '82' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 76.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '82' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 91.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '82' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 95.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '82' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 97.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '82' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 72.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '82' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 82.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '82' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '82' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '82' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '26', 'Daahir Yuusuf Maxamed', 'Hooyo Carfoon Nuur Wehliye', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 2' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 82.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '26' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 80.70, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '26' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 64.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '26' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 62.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '26' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 72.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '26' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '26' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 91.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '26' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 76.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '26' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 68.90, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '26' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 58.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '26' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 33.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '26' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 78.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '26' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '1', 'Fatxi Cabdi Maxamed', 'Hooyo Shukri Tuuryare Cadaan', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 2' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 84.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '1' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '1' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '1' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 95.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '1' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '1' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 92.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '1' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '1' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 99.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '1' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 95.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '1' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '1' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 96.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '1' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 96.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '1' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '33', 'Maxamed Maxmuud Maxamed', 'Hooyo Saylar Faarax Xaashi', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 2' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 81.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '33' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 81.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '33' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '33' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 72.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '33' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 83.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '33' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 68.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '33' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 92.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '33' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.30, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '33' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 81.90, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '33' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 74.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '33' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '33' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 77.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '33' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '11', 'Sahro Cabdullaahi Cali', 'Naciimo Maxamed Xasan', c.id, y.id, 'Hambalyo! Waxaad muujisay karti iyo dedaal aad u wanaagsan. Waxaad ku guulaysatay inaad kaalinta 3aad u gasho fasalkaaga. Horumar wanaagsan! 🎉🎉', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 2' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 95.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '11' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 93.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '11' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 98.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '11' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 98.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '11' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 97.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '11' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 77.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '11' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '11' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '11' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 91.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '11' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 91.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '11' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '11' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 74.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '11' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '61', 'Shuceyb Cabdi Cabdullaahi', 'Hooyo Xaawo Maxamud Cumar', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 2' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 62.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '61' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 85.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '61' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 31.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '61' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 64.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '61' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 57.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '61' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 79.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '61' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '61' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 79.10, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '61' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 78.10, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '61' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '61' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 55.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '61' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 84.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '61' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '67', 'Shukri Cabdicaziiz Axmed', 'Hooyo Culumo C//lle Calasow', c.id, y.id, 'Hambalyo! Waxaad muujisay karti iyo dedaal aad u wanaagsan. Waxaad ku guulaysatay inaad kaalinta 1aad u gasho fasalkaaga. Horumar wanaagsan! 🎉🎉', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 2' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 96.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '67' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 96.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '67' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 99.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '67' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 99.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '67' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 99.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '67' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 96.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '67' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '67' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '67' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.90, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '67' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 94.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '67' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '67' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '67' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '78', 'Xabiiba Ibraahim Maxamed', 'Hooyo Faadumo Maxamed Abuukar', c.id, y.id, 'Hambalyo! Waxaad muujisay karti iyo dedaal aad u wanaagsan. Waxaad ku guulaysatay inaad kaalinta 2aad u gasho fasalkaaga. Horumar wanaagsan! 🎉🎉', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 2' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 96.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '78' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 98.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '78' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 97.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '78' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 98.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '78' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '78' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 97.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '78' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '78' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 99.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '78' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 94.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '78' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 95.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '78' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 99.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '78' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 97.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '78' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '88', 'Zakariye Axmed C/Lle', 'Hooyo Saynab Wehliye Maxamed', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 2' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 65.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '88' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 62.10, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '88' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 61.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '88' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 65.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '88' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 69.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '88' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 69.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '88' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 79.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '88' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 83.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '88' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 72.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '88' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 57.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '88' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 59.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '88' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 72.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '88' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '115', 'Barwaaqo Axmed Maxamed', 'Hooyo Seynab Maxamed Cabdi Heybi', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 1' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 51.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '115' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 64.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '115' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 54.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '115' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 46.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '115' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 42.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '115' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 62.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '115' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 73.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '115' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 79.10, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '115' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 62.10, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '115' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 66.45, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '115' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 51.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '115' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 56.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '115' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '32', 'Cabdullaahi Ibraahim C/lle', 'Hooyo Madiino Xasan Axmed', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 1' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 79.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '32' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 51.30, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '32' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 63.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '32' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 59.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '32' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 64.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '32' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 60.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '32' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 96.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '32' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 81.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '32' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 70.70, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '32' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 56.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '32' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 63.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '32' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 71.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '32' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '69', 'Cabdixakiin Ibraahim Maxamed', 'Hooyo Faadumo Maxamed Abukar', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 1' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 83.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '69' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 76.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '69' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 70.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '69' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 55.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '69' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 71.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '69' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 79.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '69' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 93.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '69' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '69' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 71.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '69' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 70.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '69' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 72.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '69' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 78.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '69' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '111', 'Iftin Daahir Maxamed', 'Hooyo Meymuun Xuseen Maxmamuud', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 1' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 61.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '111' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 69.85, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '111' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 59.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '111' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 59.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '111' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 55.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '111' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 79.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '111' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 74.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '111' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 75.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '111' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 60.10, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '111' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 57.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '111' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 51.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '111' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 59.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '111' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '138', 'Iqro C/Lle Maxamed', 'Hooyo Bishaaro Axmed Cadaan', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 1' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 68.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '138' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 68.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '138' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 56.90, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '138' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 45.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '138' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 55.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '138' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 82.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '138' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 80.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '138' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 73.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '138' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 59.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '138' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 69.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '138' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 56.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '138' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 59.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '138' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '71', 'Iqro Maxamed Ibraahim', 'Hooyo Daahiro Maxamuud Muuse', c.id, y.id, 'waan ka xumahay si aad u hesho ama aad u aragto natiijadaada imtixaanka, fadlan iska xali xafiiska maaliyadda dugsiga.', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 1' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 85.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '71' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 83.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '71' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 89.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '71' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 89.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '71' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 66.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '71' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 89.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '71' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 98.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '71' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 99.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '71' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 61.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '71' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 78.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '71' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 82.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '71' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 81.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '71' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '14', 'Iqro Xuseen Xasan', 'Hooyo Nuurto Axmed Cali', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 1' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 66.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '14' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 80.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '14' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 75.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '14' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 76.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '14' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 61.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '14' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 80.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '14' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.70, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '14' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 84.90, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '14' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 62.30, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '14' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 85.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '14' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 74.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '14' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 77.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '14' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '47', 'Maryan Abshir Aadan', 'Hooyo Naciimo Maxamed Xasan', c.id, y.id, 'Hambalyo! Waxaad muujisay karti iyo dedaal aad u wanaagsan. Waxaad ku guulaysatay inaad kaalinta 3aad u gasho fasalkaaga. Horumar wanaagsan! 🎉🎉', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 1' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 91.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '47' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 90.30, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '47' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 95.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '47' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '47' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 85.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '47' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '47' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 98.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '47' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 98.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '47' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 90.30, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '47' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 68.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '47' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 91.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '47' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 93.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '47' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '95', 'Nasro Ibraahim Maxamed', 'Hooyo Farxiyo Cumar Xuseen', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 1' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '95' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.85, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '95' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 91.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '95' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 92.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '95' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 75.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '95' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '95' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '95' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 98.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '95' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.90, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '95' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 79.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '95' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 93.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '95' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 91.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '95' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '59', 'Nuux Cabdi Cali', 'Hooyo Nasro Cabdullaahi Ibraahim', c.id, y.id, 'waan ka xumahay si aad u hesho ama aad u aragto natiijadaada imtixaanka, fadlan iska xali xafiiska maaliyadda dugsiga.', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 1' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '59' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '59' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '59' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '59' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '59' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '59' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '59' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '59' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '59' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '59' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '59' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '59' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '5', 'Ruweydo Cabdullaahi Axmed', 'Hooyo Maryan Isaaq Cali', c.id, y.id, 'Hambalyo! Waxaad muujisay karti iyo dedaal aad u wanaagsan. Waxaad ku guulaysatay inaad kaalinta 2aad u gasho fasalkaaga. Horumar wanaagsan! 🎉🎉', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 1' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 89.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '5' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 85.35, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '5' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 97.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '5' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 92.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '5' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 85.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '5' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 92.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '5' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '5' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '5' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.90, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '5' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 96.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '5' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 93.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '5' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 80.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '5' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '36', 'Sacdiyo Sayid Maxamed', 'Hooyo Khadiijo Cabdullaahi Ibraahim', c.id, y.id, 'Hambalyo! Waxaad muujisay karti iyo dedaal aad u wanaagsan. Waxaad ku guulaysatay inaad kaalinta 1aad u gasho fasalkaaga. Horumar wanaagsan! 🎉🎉', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 1' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 93.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '36' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 97.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '36' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 99.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '36' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 99.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '36' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 92.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '36' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 90.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '36' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '36' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '36' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 93.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '36' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 91.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '36' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 99.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '36' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 98.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '36' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '55', 'Sumayo Salad Cabdullaahi', 'Hooyo Leylo Salaad Socdaal', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 1' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 66.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '55' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 80.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '55' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '55' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 90.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '55' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 57.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '55' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '55' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.70, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '55' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 90.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '55' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 61.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '55' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 73.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '55' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 83.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '55' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 74.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '55' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '86', 'Sundus Salad Cabdullaahi', 'Hooyo Leylo Salaad Socdaal', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 1' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 76.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '86' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '86' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '86' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '86' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 55.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '86' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 76.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '86' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '86' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 94.30, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '86' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 80.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '86' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 83.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '86' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 75.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '86' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 83.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '86' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '39', 'Xaliimo Ibraahim Muxudiin', 'Hooyo Xaawo Abuukar Maxamuud', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = 'Form 1' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 77.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '39' AND ex.name = 'Second Monthly Exam' AND su.name = 'Islamic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 75.90, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '39' AND ex.name = 'Second Monthly Exam' AND su.name = 'Somali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 72.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '39' AND ex.name = 'Second Monthly Exam' AND su.name = 'Biology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 59.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '39' AND ex.name = 'Second Monthly Exam' AND su.name = 'Chemistry'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 71.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '39' AND ex.name = 'Second Monthly Exam' AND su.name = 'Arabic'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 74.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '39' AND ex.name = 'Second Monthly Exam' AND su.name = 'Geography'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 97.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '39' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 89.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '39' AND ex.name = 'Second Monthly Exam' AND su.name = 'Business'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 67.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '39' AND ex.name = 'Second Monthly Exam' AND su.name = 'History'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 45.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '39' AND ex.name = 'Second Monthly Exam' AND su.name = 'Technology'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 59.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '39' AND ex.name = 'Second Monthly Exam' AND su.name = 'Physics'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 73.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '39' AND ex.name = 'Second Monthly Exam' AND su.name = 'Math'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '38', 'Cabdullaahi Cabdikariin Maxmuud', 'Hooyo Deeqo Maxamuud Cali', c.id, y.id, 'waan ka xumahay si aad u hesho ama aad u aragto natiijadaada imtixaanka, fadlan iska xali xafiiska maaliyadda dugsiga.', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '8aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '38' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '38' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '38' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '38' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '38' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '38' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '38' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '38' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '136', 'Cadnaan C/lle Mustaf', 'Hooyo Sacdiyo Muxudiin Xasan', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '8aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 58.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '136' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 70.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '136' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 83.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '136' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 63.33, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '136' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 79.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '136' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 61.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '136' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 57.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '136' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 65.10, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '136' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '141', 'Ciise Cali Ciise', 'Hooyo Qamar Muqtaar Qaasim', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '8aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 53.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '141' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 77.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '141' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 74.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '141' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 33.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '141' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 58.85, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '141' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 59.90, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '141' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 68.65, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '141' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 76.90, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '141' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '19', 'Deeqa Maxamed Cali', 'Hooyo Khadiijo Maxamed Xasan', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '8aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 29.10, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '19' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 81.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '19' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 74.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '19' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 32.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '19' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 70.30, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '19' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 63.90, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '19' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 74.95, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '19' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 64.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '19' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '37', 'Deeqo Maxamed Maxmuud', 'Hooyo Hindiyo Cumar Aadan', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '8aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 49.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '37' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 89.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '37' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 82.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '37' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 38.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '37' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 76.90, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '37' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 72.10, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '37' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 56.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '37' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '37' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '113', 'Iqro Cabdullaahi Maxamuud', 'Hooyo Nadiifo Cali C//lle', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '8aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 25.90, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '113' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 67.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '113' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 74.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '113' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 30.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '113' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 49.95, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '113' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 46.30, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '113' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 57.05, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '113' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 65.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '113' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '137', 'Liibaan Xasan Maxamed', 'Hooyo Maryan Maxamed Cali', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '8aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 46.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '137' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 77.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '137' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 74.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '137' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 39.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '137' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 65.95, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '137' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 80.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '137' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 78.30, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '137' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 71.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '137' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '122', 'Maryan Daahir Xuseen', 'Hooyo Zeynab Muuse Maxamed', c.id, y.id, 'Hambalyo! Waxaad muujisay karti iyo dedaal aad u wanaagsan. Waxaad ku guulaysatay inaad kaalinta 3aad u gasho fasalkaaga. Horumar wanaagsan! 🎉🎉', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '8aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 35.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '122' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 99.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '122' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 99.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '122' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 34.10, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '122' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 93.70, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '122' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 95.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '122' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 89.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '122' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 94.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '122' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '128', 'Maryan Maxamed Aadan', 'Hooyo Caa''isho Siidow Cusmaan', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '8aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 57.10, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '128' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '128' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 85.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '128' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 55.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '128' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 77.55, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '128' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 70.90, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '128' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 69.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '128' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 78.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '128' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '109', 'Maxamed Cabdullaahi Yuusuf', 'Hooyo Xakiimo Maxamed Cumar', c.id, y.id, 'Hambalyo! Waxaad muujisay karti iyo dedaal aad u wanaagsan. Waxaad ku guulaysatay inaad kaalinta 1aad u gasho fasalkaaga. Horumar wanaagsan! 🎉🎉', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '8aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 92.30, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '109' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 91.35, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '109' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '109' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 72.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '109' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 84.30, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '109' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 77.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '109' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 80.30, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '109' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 84.70, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '109' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '27', 'Muno Maxamed Cali', 'Hooyo Khadiijo Maxamed Xasan', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '8aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 42.90, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '27' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 89.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '27' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '27' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 46.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '27' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 69.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '27' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 62.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '27' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 67.55, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '27' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 85.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '27' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '60', 'Salmo Shariif Xasan', 'Hooyo Abshiro C/Lle Maxamuud', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '8aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 32.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '60' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 81.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '60' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 84.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '60' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 36.70, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '60' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 63.85, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '60' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 69.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '60' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 67.55, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '60' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 76.30, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '60' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '100', 'Xasan Kaafi Axmed Nuur', 'Hooyo Maryan Jimcaale Nuur', c.id, y.id, 'waan ka xumahay si aad u hesho ama aad u aragto natiijadaada imtixaanka, fadlan iska xali xafiiska maaliyadda dugsiga.', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '8aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 39.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '100' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '100' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '100' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '100' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '100' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '100' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '100' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '100' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '119', 'Xasan Yuusuf Maxamed', 'Hooyo Carfoon Nuur Wehliye', c.id, y.id, 'Hambalyo! Waxaad muujisay karti iyo dedaal aad u wanaagsan. Waxaad ku guulaysatay inaad kaalinta 2aad u gasho fasalkaaga. Horumar wanaagsan! 🎉🎉', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '8aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 75.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '119' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 92.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '119' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 85.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '119' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 69.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '119' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 84.30, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '119' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 90.70, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '119' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 80.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '119' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 73.30, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '119' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '127', 'Cabdinuur C/Lle Maxamed', 'Hooyo Raaxo Yuusuf C/Lle', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 50.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '127' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 58.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '127' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 60.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '127' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 81.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '127' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 57.10, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '127' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 80.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '127' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 56.54, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '127' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 40.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '127' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '120', 'Cabdiqaadir Cusmaan Haaruun', 'Hooyo Xaliimo Cabdi Abshirow', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 78.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '120' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 76.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '120' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 72.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '120' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 83.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '120' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 98.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '120' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 96.90, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '120' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 83.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '120' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 52.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '120' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '85', 'Cabdisalaam Cabdullaahi Maxamed', 'Hooyo Aamino Maxamed Yuusuf', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 67.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '85' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '85' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 91.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '85' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 94.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '85' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 92.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '85' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '85' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 81.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '85' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 63.10, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '85' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '68', 'Cabdiwali Sayid Cali Maxmuud', 'Hooyo Khadiijo C/Laahi Ibraahim', c.id, y.id, 'Hambalyo! Waxaad muujisay karti iyo dedaal aad u wanaagsan. Waxaad ku guulaysatay inaad kaalinta 1aad u gasho fasalkaaga. Horumar wanaagsan! 🎉🎉', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '68' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 98.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '68' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '68' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 97.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '68' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 98.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '68' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '68' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 98.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '68' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '68' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '94', 'Faadumo Ibraahim Cabdi', 'Hooyo Xaliimo Maxamed Bashiir', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 50.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '94' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 78.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '94' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 78.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '94' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 75.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '94' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 92.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '94' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '94' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 75.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '94' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 54.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '94' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '76', 'Farxiyo Daahir Maxamed', 'Hooyo Meymuun Xuseen Maxamuud', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 95.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '76' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 92.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '76' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 96.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '76' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 98.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '76' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '76' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 98.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '76' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 89.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '76' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 68.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '76' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '117', 'Fu''aad Ismaaciil C/Lle', 'Hooyo Fartuun Maxamuud Cabdi', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 70.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '117' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 82.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '117' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 75.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '117' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 48.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '117' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '117' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 89.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '117' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 79.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '117' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 39.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '117' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '63', 'Hodan Cabdullaahi Yuusuf', 'Hooyo Xakiimo Maxamed Cumar', c.id, y.id, 'waan ka xumahay si aad u hesho ama aad u aragto natiijadaada imtixaanka, fadlan iska xali xafiiska maaliyadda dugsiga.', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '63' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '63' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '63' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '63' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '63' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '63' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '63' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '63' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '21', 'Iqlaas Axmed Nuur Ibraahim', 'Hooyo Xafso Maxamed Maxamuud', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '21' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '21' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 94.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '21' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '21' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 91.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '21' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 93.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '21' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '21' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 56.70, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '21' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '126', 'Isxaaq Ibraahim Maxamed', 'Hooyo Xabiibo Cali Xasan', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 90.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '126' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 62.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '126' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 72.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '126' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 52.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '126' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 92.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '126' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 97.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '126' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 69.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '126' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 51.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '126' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '133', 'Khaalid Asad Maxamed', 'Hooyo Xamiido Aadan Cusmaan', c.id, y.id, 'waan ka xumahay si aad u hesho ama aad u aragto natiijadaada imtixaanka, fadlan iska xali xafiiska maaliyadda dugsiga.', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 79.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '133' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 72.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '133' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 76.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '133' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 90.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '133' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 50.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '133' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 97.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '133' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 75.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '133' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 62.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '133' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '112', 'Maaido Cali Yuusuf', 'Hooyo Shukri Tuuryare Cadaan', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 50.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '112' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 77.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '112' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '112' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 90.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '112' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 91.10, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '112' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 80.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '112' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 81.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '112' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 48.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '112' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '91', 'Maariyo Cabdiqaadir Maxamed', 'Hooyo Leylo Ibraahim Xuseen', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 55.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '91' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 80.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '91' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 90.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '91' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '91' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 92.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '91' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 99.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '91' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 81.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '91' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 57.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '91' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '24', 'Maido Yaxye Abuukar', 'Hooyo Sahro Muuse Cali', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 72.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '24' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 78.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '24' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 78.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '24' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 70.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '24' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 82.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '24' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '24' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 68.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '24' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 51.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '24' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '103', 'Maqdis Cabdullaahi Ibraahim', 'Hooyo Culumo Ibraahim Raage', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 75.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '103' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 91.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '103' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 96.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '103' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 98.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '103' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 89.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '103' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 94.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '103' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '103' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 61.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '103' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '51', 'Maslax Axmed Ibraahim', 'Hooyo Meymuun Maxamed Macow', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '51' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 89.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '51' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 92.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '51' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 55.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '51' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 93.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '51' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 95.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '51' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '51' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 68.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '51' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '131', 'Maxamed Daahir Xasan', 'Hooyo Muumino Maxamuud C/Lle', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 57.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '131' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 82.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '131' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 74.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '131' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 81.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '131' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 89.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '131' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.30, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '131' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 78.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '131' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 52.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '131' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '8', 'Qadro Saciid Maxmuud', 'Hooyo Sacdiyo Xasan Maxamed', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 70.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '8' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 71.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '8' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 83.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '8' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 82.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '8' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 83.10, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '8' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 81.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '8' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 75.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '8' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 44.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '8' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '25', 'Rayaan C/Lle Maxamed', 'Hooyo Bishaaro Axmed Cadaan', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 67.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '25' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 84.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '25' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '25' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '25' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 96.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '25' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 94.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '25' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '25' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 39.90, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '25' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '142', 'Salmaan Cabduqaadir Maxamed', 'Hooyo Kaltuumo Aweys Abaadir', c.id, y.id, 'Hambalyo! Waxaad muujisay karti iyo dedaal aad u wanaagsan. Waxaad ku guulaysatay inaad kaalinta 3aad u gasho fasalkaaga. Horumar wanaagsan! 🎉🎉', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 99.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '142' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 95.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '142' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 98.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '142' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 98.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '142' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 97.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '142' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '142' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 94.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '142' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 77.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '142' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '20', 'Samiiro Cabdinuur Maxamed', 'Hooyo Aamino Ibraahim C/Lle', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '20' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 92.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '20' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 97.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '20' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 99.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '20' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 98.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '20' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 95.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '20' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 85.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '20' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 54.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '20' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '97', 'Shaafici Cabdiqaadir Axmed', 'Hooyo Sacdiyo Cabdiqaadir Maxamed', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 55.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '97' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 62.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '97' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 81.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '97' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 84.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '97' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '97' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 93.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '97' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 84.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '97' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 47.90, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '97' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '96', 'Shukri Cali Maxamed', 'Hooyo Aaamino Xuseen Cali', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 96.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '96' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 92.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '96' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 99.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '96' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 98.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '96' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 99.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '96' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 99.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '96' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 92.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '96' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 74.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '96' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '105', 'Suweys Xasan Cabdi', 'Hooyo Fartuun Maxamuud Yarow', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 67.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '105' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 83.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '105' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 75.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '105' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 90.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '105' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '105' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 84.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '105' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 75.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '105' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 49.30, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '105' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '139', 'Xaliimo Abshir Muuse', 'Hooyo Raxmo Maxcamed Yuusuf', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 33.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '139' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 70.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '139' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 78.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '139' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 78.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '139' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 76.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '139' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 94.10, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '139' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 61.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '139' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 36.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '139' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '3', 'Yaasir Asad Maxamed', 'Hooyo Xamiido Aadan Cusmaan', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '3' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '3' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 89.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '3' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 79.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '3' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 93.10, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '3' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 98.90, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '3' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 77.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '3' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 52.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '3' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '65', 'Zakariye Muxudiin Ibraahim', 'Hooyo Casho Xusseen Maxamed', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 68.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '65' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 57.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '65' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 73.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '65' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 90.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '65' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 91.10, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '65' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '65' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 62.30, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '65' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 53.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '65' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '89', 'Zamzam Saciid Maxmuud', 'Hooyo Sacdiyo Xasan Maxamed', c.id, y.id, 'Hambalyo! Waxaad muujisay karti iyo dedaal aad u wanaagsan. Waxaad ku guulaysatay inaad kaalinta 2aad u gasho fasalkaaga. Horumar wanaagsan! 🎉🎉', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '7aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 92.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '89' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 95.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '89' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 98.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '89' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 96.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '89' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 98.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '89' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '89' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 95.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '89' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '89' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '66', 'Abuukar Cabdullaahi C/lle', 'Hooyo Safiyo Cabdullaahi Cusubow', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '6aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 74.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '66' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 75.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '66' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 63.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '66' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 53.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '66' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 79.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '66' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '66' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 73.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '66' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 59.30, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '66' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '107', 'Ayuub Cabdullaahi Salad', 'Hooyo Shariifo C/lle Nuur', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '6aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 82.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '107' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 94.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '107' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 84.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '107' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 66.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '107' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 92.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '107' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '107' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '107' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 55.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '107' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '57', 'Cabdiqafaar Axmed Jimcaale', 'Hooyo Batuulo Aadan C/lle', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '6aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 60.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '57' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 72.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '57' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 76.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '57' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 51.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '57' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 85.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '57' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 94.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '57' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 80.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '57' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 52.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '57' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '49', 'Cabaas Maxamed Aweys', 'Hooyo Ruun Muqtaar Muuse', c.id, y.id, 'Hambalyo! Waxaad muujisay karti iyo dedaal aad u wanaagsan. Waxaad ku guulaysatay inaad kaalinta 1aad u gasho fasalkaaga. Horumar wanaagsan! 🎉🎉', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '6aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '49' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 92.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '49' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 97.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '49' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 85.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '49' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 95.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '49' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 99.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '49' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 97.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '49' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 76.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '49' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '102', 'Cukaash Ibraahim Maxamed', 'Hooyo Sacdiyo Miinshaar Maxamed', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '6aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 49.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '102' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 78.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '102' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 59.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '102' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 47.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '102' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 66.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '102' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 68.90, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '102' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 62.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '102' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 48.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '102' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '48', 'Ibraahim Cabdullaahi maxamed', 'Hooyo Aamino maxamed yuusuf', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '6aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 57.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '48' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 93.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '48' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 77.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '48' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 46.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '48' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 80.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '48' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 91.10, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '48' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 85.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '48' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 68.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '48' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '13', 'Ismaciil Cali Maxamed', 'Hooyo Aamino Xuseen Cali', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '6aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 78.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '13' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 84.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '13' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 85.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '13' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 64.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '13' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '13' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 73.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '13' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 80.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '13' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 62.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '13' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '84', 'Istar Cabdullaahi Maxamed', 'Hooyo Aamino Maxamed Yuusuf', c.id, y.id, 'Hambalyo! Waxaad muujisay karti iyo dedaal aad u wanaagsan. Waxaad ku guulaysatay inaad kaalinta 3aad u gasho fasalkaaga. Horumar wanaagsan! 🎉🎉', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '6aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 77.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '84' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 96.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '84' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '84' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 75.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '84' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '84' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 99.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '84' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 91.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '84' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 57.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '84' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '118', 'Maa''ido Cabdullaahi Xasan Rooble', 'Hooyo Sacdiyo Cali Ibraaim', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '6aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 50.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '118' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 57.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '118' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 53.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '118' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 50.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '118' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 59.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '118' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 57.70, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '118' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 50.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '118' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 50.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '118' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '62', 'Maxamed Cabdiqaadir Cali', 'Hooyo Faadumo Maxamed Abubakar', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '6aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 44.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '62' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 79.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '62' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 67.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '62' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 36.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '62' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 75.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '62' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 60.10, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '62' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 61.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '62' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 49.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '62' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '92', 'Maxamed Ibraahim Axmed', 'Hooyo Baxsan maxamed Axmed', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '6aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 59.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '92' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 81.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '92' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 62.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '92' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 47.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '92' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 78.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '92' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 65.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '92' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 76.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '92' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 49.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '92' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '52', 'Maxamed Shariif Ibraahim', 'Hooyo Sahro maxamed Afrax', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '6aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 59.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '52' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 70.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '52' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 63.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '52' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 35.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '52' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 79.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '52' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 93.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '52' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 81.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '52' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 61.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '52' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '70', 'Nasteexo Ibraahim Maxamed', 'Hooyo Farxiyo maxamed xuseen', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '6aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 50.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '70' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 57.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '70' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 50.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '70' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 50.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '70' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 58.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '70' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 57.90, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '70' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 55.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '70' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 50.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '70' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '35', 'Saciid Cabdikariim Maxamuud', 'Hooyo Deeqo maxamed cali', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '6aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '35' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 66.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '35' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 76.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '35' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 63.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '35' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 95.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '35' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 97.70, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '35' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 83.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '35' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 75.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '35' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '80', 'Salmo Sayid Cali Maxmuud', 'Hooyo Khadiijo Cabdullaahi Ibraahim', c.id, y.id, 'Hambalyo! Waxaad muujisay karti iyo dedaal aad u wanaagsan. Waxaad ku guulaysatay inaad kaalinta 2aad u gasho fasalkaaga. Horumar wanaagsan! 🎉🎉', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '6aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '80' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 93.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '80' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 93.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '80' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 79.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '80' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 96.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '80' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 100.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '80' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 93.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '80' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 71.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '80' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '2', 'Sharma''arke Cabdiqaadir Xasan', 'Hooyo Meymuun Maxamed Macow', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '6aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 43.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '2' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 56.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '2' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 60.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '2' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 36.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '2' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 53.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '2' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 69.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '2' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 57.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '2' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 45.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '2' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '77', 'Shukri Axmed Ibraahim', 'Hooyo Faadumo Cabdi Sheeybow', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '6aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 65.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '77' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 85.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '77' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 81.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '77' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 75.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '77' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 97.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '77' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '77' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 89.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '77' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 75.90, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '77' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '116', 'Zakariye Cabdullaahi Maxmuud', 'Hooyo Xakiimo C/lle Cusmaan', c.id, y.id, 'waan ka xumahay si aad u hesho ama aad u aragto natiijadaada imtixaanka, fadlan iska xali xafiiska maaliyadda dugsiga.', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '6aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '116' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '116' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '116' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '116' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '116' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '116' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '116' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 0.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '116' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '30', 'Ciise Maxamed Aadan', 'Hooyo Xaawo Xuseen Ibraahim', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '5aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 63.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '30' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 75.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '30' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 67.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '30' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 59.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '30' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 78.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '30' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 89.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '30' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 66.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '30' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 57.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '30' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '50', 'Shukri C/lle Maxamed', 'Hooyo Bishaaro Axmed Cadaan', c.id, y.id, 'Hambalyo! Waxaad muujisay karti iyo dedaal aad u wanaagsan. Waxaad ku guulaysatay inaad kaalinta 3aad u gasho fasalkaaga. Horumar wanaagsan! 🎉🎉', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '5aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 67.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '50' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '50' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 84.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '50' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 65.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '50' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 89.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '50' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 95.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '50' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 83.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '50' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 70.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '50' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '135', 'Ra''iis Suudi Maxamed', 'Hooyo Sacdiyo Axmed C/lle', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '5aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 28.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '135' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '135' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 61.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '135' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 41.75, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '135' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 68.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '135' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 92.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '135' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 52.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '135' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 61.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '135' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '46', 'Cabdiraxmaan Ibraahim Xasan', 'Hooyo Saciido Xasan Cumar', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '5aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 36.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '46' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 70.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '46' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 61.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '46' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 46.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '46' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 48.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '46' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 67.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '46' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 48.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '46' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 42.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '46' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '110', 'Mukhtaar Maxmuud Maxamed', 'Hooyo Hidaayo Axmed Abiikar', c.id, y.id, 'Hambalyo! Waxaad muujisay karti iyo dedaal aad u wanaagsan. Waxaad ku guulaysatay inaad kaalinta 2aad u gasho fasalkaaga. Horumar wanaagsan! 🎉🎉', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '5aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 63.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '110' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 94.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '110' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 76.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '110' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 75.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '110' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '110' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 98.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '110' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 85.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '110' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 81.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '110' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '44', 'Nawaal Cabdiraxmaan', 'Hooyo Canab Maxamuud Daa''uud', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '5aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 36.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '44' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 84.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '44' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 73.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '44' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 57.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '44' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 68.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '44' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 84.10, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '44' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 80.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '44' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 70.90, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '44' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '23', 'Iidow Maxamed Maxmuud', 'Hooyo Xaliimo Aamin Axmed', c.id, y.id, 'Hambalyo! Waxaad muujisay karti iyo dedaal aad u wanaagsan. Waxaad ku guulaysatay inaad kaalinta 1aad u gasho fasalkaaga. Horumar wanaagsan! 🎉🎉', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '5aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 67.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '23' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 95.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '23' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 84.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '23' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 71.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '23' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 84.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '23' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.90, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '23' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 93.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '23' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '23' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '125', 'Xaawo Cabdirisaaq Cusmaan', 'Hooyo Raaliyo Mazamed Ooliyaan', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '5aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 64.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '125' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 95.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '125' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 82.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '125' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 76.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '125' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 78.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '125' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 93.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '125' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 78.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '125' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 69.10, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '125' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '101', 'Ruweydo Maxamed Ibraahim', 'Hooyo Daahiro Maxamuud Muuse', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '5aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 32.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '101' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 73.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '101' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 64.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '101' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 36.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '101' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 44.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '101' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 83.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '101' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 50.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '101' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 92.60, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '101' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '123', 'Rayaan Cabdullaahi Axmed', 'Hooyo Maryan isaaq Cali', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '5aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 58.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '123' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '123' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '123' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 64.25, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '123' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '123' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 85.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '123' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 84.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '123' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 35.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '123' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '6', 'Mustaf Cabdirisaaq Cusmaan', 'Hooyo Raaliyo Mazamed Ooliyaan', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '5aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 34.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '6' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 72.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '6' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 65.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '6' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 59.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '6' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 50.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '6' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 68.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '6' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 69.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '6' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 63.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '6' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '108', 'Nasro Xasan Dahir', 'Hooyo Hindiyo Cabdi Cali', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '5aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 52.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '108' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '108' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 74.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '108' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 63.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '108' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '108' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 83.10, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '108' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 87.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '108' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 62.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '108' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '4', 'Maxamud Nuur Cabdullaahi', 'Hooyo Salaado Taakow Cadaan', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '5aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 48.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '4' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 58.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '4' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 74.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '4' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 56.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '4' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 53.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '4' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 84.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '4' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 63.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '4' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 55.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '4' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '73', 'Nacimo Nuur Cabdullaahi', 'Hooyo Salaado Taakow Cadaan', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '5aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 72.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '73' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 75.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '73' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 77.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '73' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 72.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '73' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 73.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '73' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 91.20, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '73' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 81.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '73' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 60.40, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '73' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '114', 'Leylo Cabdullaahi Xasan', 'Hooyo Shamso Maxamed Aadan', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '5aad' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 54.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '114' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiyo'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 88.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '114' AND ex.name = 'Second Monthly Exam' AND su.name = 'Af-Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 76.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '114' AND ex.name = 'Second Monthly Exam' AND su.name = 'Seynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 62.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '114' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 71.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '114' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 89.10, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '114' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 81.50, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '114' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 52.80, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '114' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)
SELECT '3007', 'Sumaya Xasan Maxamad Maxamuud', 'Sawdo Iikar  Mire', c.id, y.id, '', TRUE
FROM school_classes c JOIN academic_years y WHERE c.name = '6aad A' AND y.name = '2024-2025'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 84.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '3007' AND ex.name = 'Second Monthly Exam' AND su.name = 'Tarbiya'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 90.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '3007' AND ex.name = 'Second Monthly Exam' AND su.name = 'Soomaali'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 71.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '3007' AND ex.name = 'Second Monthly Exam' AND su.name = 'Carabi'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 63.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '3007' AND ex.name = 'Second Monthly Exam' AND su.name = 'Xisaab'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 97.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '3007' AND ex.name = 'Second Monthly Exam' AND su.name = 'Saynis'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 96.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '3007' AND ex.name = 'Second Monthly Exam' AND su.name = 'Cilmi_Bulsho'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 70.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '3007' AND ex.name = 'Second Monthly Exam' AND su.name = 'English'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
INSERT INTO results (student_id, exam_id, subject_id, score, is_published)
SELECT st.id, ex.id, su.id, 86.00, TRUE
FROM students st
JOIN exams ex ON ex.academic_year_id = st.academic_year_id
JOIN subjects su WHERE st.student_code = '3007' AND ex.name = 'Second Monthly Exam' AND su.name = 'Teknooloji'
ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);
