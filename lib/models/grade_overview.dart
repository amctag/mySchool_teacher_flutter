import 'package:equatable/equatable.dart';

class GradeOverview extends Equatable {
  const GradeOverview({
    required this.courseTitle,
    required this.gradeTypeTitle,
    required this.score,
    required this.maxGrade,
    required this.publishDate,
    required this.yearTitle,
    this.comment,
  });

  factory GradeOverview.fromJson(Map<String, dynamic> json) => GradeOverview(
    courseTitle: json['course_title'] as String,
    gradeTypeTitle: json['grade_type_title'] as String,
    score: (json['score'] as num).toDouble(),
    maxGrade: (json['max_grade'] as num).toDouble(),
    publishDate: DateTime.parse(json['publish_date'] as String),
    yearTitle: json['year_title'] as String,
    comment: json['comment'] as String?,
  );

  final String courseTitle;
  final String gradeTypeTitle;
  final double score;
  final double maxGrade;
  final DateTime publishDate;
  final String yearTitle;
  final String? comment;

  @override
  List<Object?> get props => [
    courseTitle,
    gradeTypeTitle,
    score,
    maxGrade,
    publishDate,
    yearTitle,
    comment,
  ];
}
