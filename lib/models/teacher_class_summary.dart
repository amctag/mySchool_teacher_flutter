import 'package:equatable/equatable.dart';

class TeacherClassSummary extends Equatable {
  const TeacherClassSummary({
    required this.id,
    required this.className,
    required this.sectionTitle,
    required this.yearTitle,
    required this.stage,
    required this.primaryCourseTitle,
    required this.isAssignedToCurrentTeacher,
  });

  factory TeacherClassSummary.fromJson(Map<String, dynamic> json) {
    return TeacherClassSummary(
      id: json['id'] as int,
      className: (json['class_name'] ?? json['className']) as String,
      sectionTitle: (json['section_title'] ?? json['sectionTitle']) as String,
      yearTitle: (json['year_title'] ?? json['yearTitle']) as String,
      stage: json['stage'] as String,
      primaryCourseTitle:
          (json['primary_course_title'] ?? json['primaryCourseTitle'] ?? '')
              as String,
      isAssignedToCurrentTeacher:
          (json['is_assigned_to_current_teacher'] ??
                  json['isAssignedToCurrentTeacher'] ??
                  false)
              as bool,
    );
  }

  final int id;
  final String className;
  final String sectionTitle;
  final String yearTitle;
  final String stage;
  final String primaryCourseTitle;
  final bool isAssignedToCurrentTeacher;

  String get label => '$className - Section $sectionTitle';

  @override
  List<Object?> get props => [
    id,
    className,
    sectionTitle,
    yearTitle,
    stage,
    primaryCourseTitle,
    isAssignedToCurrentTeacher,
  ];
}
