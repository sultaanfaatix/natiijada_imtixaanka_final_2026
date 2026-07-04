import fs from "node:fs";
import vm from "node:vm";

const source = fs.readFileSync(new URL("../../legacy/sample.html", import.meta.url), "utf8");
const commentsMatch = source.match(/const\s+studentComments\s*=\s*(\{[\s\S]*?\});\s*const\s+students/);
const studentsMatch = source.match(/const\s+students\s*=\s*(\[[\s\S]*?\]);\s*function\s+getLetterGrade/);

if (!studentsMatch) {
  throw new Error("Could not find legacy students array.");
}

const context = {};
vm.createContext(context);
vm.runInContext(`students = ${studentsMatch[1]}; studentComments = ${commentsMatch ? commentsMatch[1] : "{}"};`, context);

const students = context.students;
const studentComments = context.studentComments || {};
const classes = [...new Set(students.map((student) => student.class))].sort();
const years = [...new Set(students.map((student) => student.year))].sort();
const subjects = [...new Set(students.flatMap((student) => Object.keys(student.results).map((name) => name.trim())))].sort();

const esc = (value) => String(value ?? "").replaceAll("\\", "\\\\").replaceAll("'", "''");
const q = (value) => `'${esc(value)}'`;

const lines = [
  "USE exam_results;",
  "",
  ...years.map((year, index) => `INSERT INTO academic_years (name, is_current) VALUES (${q(year)}, ${index === years.length - 1 ? "TRUE" : "FALSE"}) ON DUPLICATE KEY UPDATE name = VALUES(name);`),
  "",
  ...classes.map((name) => `INSERT INTO school_classes (name) VALUES (${q(name)}) ON DUPLICATE KEY UPDATE name = VALUES(name);`),
  "",
  ...subjects.map((name, index) => `INSERT INTO subjects (name, max_score, sort_order) VALUES (${q(name)}, 100, ${index + 1}) ON DUPLICATE KEY UPDATE max_score = VALUES(max_score), sort_order = VALUES(sort_order);`),
  "",
  "INSERT INTO exams (name, academic_year_id, is_published)",
  `SELECT 'Second Monthly Exam', id, TRUE FROM academic_years WHERE name = ${q(years.at(-1) || "2024-2025")}`,
  "ON DUPLICATE KEY UPDATE is_published = TRUE;",
  "",
];

for (const student of students) {
  lines.push(
    "INSERT INTO students (student_code, full_name, mother_name, class_id, academic_year_id, note, is_active)",
    `SELECT ${q(student.regNo)}, ${q(student.name)}, ${q(student.motherName)}, c.id, y.id, ${q(studentComments[student.regNo] || "")}, TRUE`,
    `FROM school_classes c JOIN academic_years y WHERE c.name = ${q(student.class)} AND y.name = ${q(student.year)}`,
    "ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), mother_name = VALUES(mother_name), class_id = VALUES(class_id), academic_year_id = VALUES(academic_year_id), note = VALUES(note);"
  );
  for (const [subjectName, score] of Object.entries(student.results)) {
    lines.push(
      "INSERT INTO results (student_id, exam_id, subject_id, score, is_published)",
      `SELECT st.id, ex.id, su.id, ${Number(score).toFixed(2)}, TRUE`,
      "FROM students st",
      "JOIN exams ex ON ex.academic_year_id = st.academic_year_id",
      `JOIN subjects su WHERE st.student_code = ${q(student.regNo)} AND ex.name = 'Second Monthly Exam' AND su.name = ${q(subjectName.trim())}`,
      "ON DUPLICATE KEY UPDATE score = VALUES(score), is_published = VALUES(is_published);"
    );
  }
}

fs.writeFileSync(new URL("../database/legacy_seed.sql", import.meta.url), lines.join("\n") + "\n");
console.log(`Wrote ${students.length} students, ${subjects.length} subjects.`);
