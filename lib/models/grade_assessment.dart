import 'package:equatable/equatable.dart';

class GradeAssessmentSummary extends Equatable {
  const GradeAssessmentSummary({
    required this.id,
    required this.classId,
    required this.className,
    required this.sectionId,
    required this.sectionTitle,
    required this.classLabel,
    required this.courseId,
    required this.courseTitle,
    required this.gradeTypeId,
    required this.gradeTypeTitle,
    required this.maxGrade,
    required this.coefficient,
    required this.publishDate,
    required this.entriesCount,
  });

  factory GradeAssessmentSummary.fromJson(Map<String, dynamic> json) {
    final className = (json['className'] ?? json['class_name'] ?? '') as String;
    final sectionTitle =
        (json['sectionTitle'] ?? json['section_title'] ?? '') as String;
    return GradeAssessmentSummary(
      id: json['id'] as int,
      classId: (json['classId'] ?? json['class_id'] ?? 0) as int,
      className: className,
      sectionId: (json['sectionId'] ?? json['section_id'] ?? json['class_id'] ?? 0)
          as int,
      sectionTitle: sectionTitle,
      classLabel:
          (json['classLabel'] ??
                  json['class_label'] ??
                  '$className - Section $sectionTitle')
              as String,
      courseId: (json['courseId'] ?? json['course_id'] ?? 0) as int,
      courseTitle: (json['courseTitle'] ?? json['course_title'] ?? '') as String,
      gradeTypeId: (json['gradeTypeId'] ?? json['grade_type_id'] ?? 0) as int,
      gradeTypeTitle:
          (json['gradeTypeTitle'] ?? json['grade_type_title'] ?? '') as String,
      maxGrade: ((json['maxGrade'] ?? json['max_grade'] ?? 0) as num).toDouble(),
      coefficient: ((json['coefficient'] ?? 1) as num).toDouble(),
      publishDate: DateTime.parse(
        (json['publishDate'] ??
            json['publish_date'] ??
            DateTime.now().toIso8601String()) as String,
      ),
      entriesCount: (json['entriesCount'] ?? json['entries_count'] ?? 0) as int,
    );
  }

  final int id;
  final int classId;
  final String className;
  final int sectionId;
  final String sectionTitle;
  final String classLabel;
  final int courseId;
  final String courseTitle;
  final int gradeTypeId;
  final String gradeTypeTitle;
  final double maxGrade;
  final double coefficient;
  final DateTime publishDate;
  final int entriesCount;

  @override
  List<Object?> get props => [
    id,
    classId,
    className,
    sectionId,
    sectionTitle,
    classLabel,
    courseId,
    courseTitle,
    gradeTypeId,
    gradeTypeTitle,
    maxGrade,
    coefficient,
    publishDate,
    entriesCount,
  ];
}

class StudentGradeInput extends Equatable {
  const StudentGradeInput({
    required this.registrationId,
    required this.studentId,
    this.score,
    this.comment,
  });

  factory StudentGradeInput.fromJson(Map<String, dynamic> json) {
    return StudentGradeInput(
      registrationId:
          (json['registrationId'] ?? json['registration_id'] ?? 0) as int,
      studentId: (json['studentId'] ?? json['student_id'] ?? 0) as int,
      score: (json['score'] ?? json['grade']) == null
          ? null
          : ((json['score'] ?? json['grade']) as num).toDouble(),
      comment: json['comment'] as String?,
    );
  }

  final int registrationId;
  final int studentId;
  final double? score;
  final String? comment;

  Map<String, dynamic> toJson() => {
    'registrationId': registrationId,
    if (score != null) 'score': score,
    if (comment != null && comment!.isNotEmpty) 'comment': comment,
  };

  @override
  List<Object?> get props => [registrationId, studentId, score, comment];
}
