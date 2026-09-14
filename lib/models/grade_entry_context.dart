import 'package:equatable/equatable.dart';
import 'package:my_school_teacher/models/grade_assessment.dart';
import 'package:my_school_teacher/models/grade_options.dart';

class GradeEntryStudent extends Equatable {
  const GradeEntryStudent({
    required this.registrationId,
    required this.studentId,
    required this.fullName,
    required this.seatNumber,
    this.score,
    this.comment,
  });

  factory GradeEntryStudent.fromJson(Map<String, dynamic> json) {
    return GradeEntryStudent(
      registrationId:
          (json['registrationId'] ?? json['registration_id'] ?? 0) as int,
      studentId: (json['studentId'] ?? json['student_id'] ?? json['id']) as int,
      fullName: (json['fullName'] ?? json['full_name'] ?? '') as String,
      seatNumber: (json['seatNumber'] ?? json['seat_number'] ?? 0) as int,
      score: json['score'] == null ? null : (json['score'] as num).toDouble(),
      comment: json['comment'] as String?,
    );
  }

  final int registrationId;
  final int studentId;
  final String fullName;
  final int seatNumber;
  final double? score;
  final String? comment;

  int get id => studentId;

  @override
  List<Object?> get props => [
    registrationId,
    studentId,
    fullName,
    seatNumber,
    score,
    comment,
  ];
}

class GradeEntryContext extends Equatable {
  const GradeEntryContext({
    this.gradeSheetId,
    required this.assignmentId,
    required this.classId,
    required this.className,
    required this.sectionId,
    required this.sectionTitle,
    required this.classLabel,
    required this.courseId,
    required this.courseTitle,
    required this.gradeTypeId,
    required this.gradeTypeTitle,
    this.isMain = false,
    required this.coefficient,
    required this.maxGrade,
    this.publishDate,
    required this.students,
  });

  factory GradeEntryContext.fromJson(Map<String, dynamic> json) {
    return GradeEntryContext(
      gradeSheetId:
          (json['gradeSheetId'] ?? json['grade_sheet_id']) as int?,
      assignmentId: (json['assignmentId'] ?? json['assignment_id'] ?? 0) as int,
      classId: (json['classId'] ?? json['class_id'] ?? 0) as int,
      className: (json['className'] ?? json['class_name'] ?? '') as String,
      sectionId: (json['sectionId'] ?? json['section_id'] ?? 0) as int,
      sectionTitle:
          (json['sectionTitle'] ?? json['section_title'] ?? '') as String,
      classLabel: (json['classLabel'] ?? json['class_label'] ?? '') as String,
      courseId: (json['courseId'] ?? json['course_id'] ?? 0) as int,
      courseTitle: (json['courseTitle'] ?? json['course_title'] ?? '') as String,
      gradeTypeId: (json['gradeTypeId'] ?? json['grade_type_id'] ?? 0) as int,
      gradeTypeTitle:
          (json['gradeTypeTitle'] ?? json['grade_type_title'] ?? '') as String,
      isMain: parseJsonBool(json['isMain'] ?? json['is_main']),
      coefficient: ((json['coefficient'] ?? 1) as num).toDouble(),
      maxGrade: ((json['maxGrade'] ?? json['max_grade'] ?? 0) as num).toDouble(),
      publishDate: (json['publishDate'] ?? json['publish_date']) as String?,
      students: ((json['students'] as List<dynamic>?) ?? const [])
          .map((item) => GradeEntryStudent.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  final int? gradeSheetId;
  final int assignmentId;
  final int classId;
  final String className;
  final int sectionId;
  final String sectionTitle;
  final String classLabel;
  final int courseId;
  final String courseTitle;
  final int gradeTypeId;
  final String gradeTypeTitle;
  final bool isMain;
  final double coefficient;
  final double maxGrade;
  final String? publishDate;
  final List<GradeEntryStudent> students;

  List<StudentGradeInput> get seededEntries => [
    for (final student in students)
      StudentGradeInput(
        registrationId: student.registrationId,
        studentId: student.studentId,
        score: student.score,
        comment: student.comment,
      ),
  ];

  @override
  List<Object?> get props => [
    gradeSheetId,
    assignmentId,
    classId,
    className,
    sectionId,
    sectionTitle,
    classLabel,
    courseId,
    courseTitle,
    gradeTypeId,
    gradeTypeTitle,
    isMain,
    coefficient,
    maxGrade,
    publishDate,
    students,
  ];
}
