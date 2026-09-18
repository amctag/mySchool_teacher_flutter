import 'package:equatable/equatable.dart';

class TeacherClassSummary extends Equatable {
  const TeacherClassSummary({
    required this.id,
    required this.className,
    required this.sectionTitle,
    required this.yearTitle,
    required this.stage,
    required this.primaryCourseTitle,
    this.courseTitles = const [],
    required this.isAssignedToCurrentTeacher,
  });

  factory TeacherClassSummary.fromJson(Map<String, dynamic> json) {
    final titles = ((json['course_titles'] ?? json['courseTitles']) as List<dynamic>?)
            ?.map((item) => item.toString())
            .where((item) => item.isNotEmpty)
            .toList(growable: false) ??
        const <String>[];
    final primary =
        (json['primary_course_title'] ?? json['primaryCourseTitle'] ?? '')
            as String;
    return TeacherClassSummary(
      id: json['id'] as int,
      className: (json['class_name'] ?? json['className']) as String,
      sectionTitle: (json['section_title'] ?? json['sectionTitle']) as String,
      yearTitle: (json['year_title'] ?? json['yearTitle']) as String,
      stage: json['stage'] as String,
      primaryCourseTitle: primary,
      courseTitles: titles.isNotEmpty
          ? titles
          : (primary.isEmpty
                ? const <String>[]
                : primary
                      .split(',')
                      .map((item) => item.trim())
                      .where((item) => item.isNotEmpty)
                      .toList(growable: false)),
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
  final List<String> courseTitles;
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
    courseTitles,
    isAssignedToCurrentTeacher,
  ];
}
