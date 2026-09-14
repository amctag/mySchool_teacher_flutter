import 'package:equatable/equatable.dart';

class TeacherAssignment extends Equatable {
  const TeacherAssignment({
    required this.id,
    required this.classId,
    required this.className,
    required this.sectionTitle,
    required this.yearTitle,
    required this.stage,
    required this.courseTitle,
    required this.dayName,
    required this.periodNumber,
    required this.periodLabel,
    required this.startTime,
    required this.endTime,
    required this.room,
  });

  factory TeacherAssignment.fromJson(Map<String, dynamic> json) {
    return TeacherAssignment(
      id: json['id'] as int,
      classId: json['class_id'] as int,
      className: json['class_name'] as String,
      sectionTitle: json['section_title'] as String,
      yearTitle: json['year_title'] as String,
      stage: json['stage'] as String,
      courseTitle: json['course_title'] as String,
      dayName: json['day_name'] as String,
      periodNumber: json['period_number'] as int,
      periodLabel: json['period_label'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      room: json['room'] as String,
    );
  }

  final int id;
  final int classId;
  final String className;
  final String sectionTitle;
  final String yearTitle;
  final String stage;
  final String courseTitle;
  final String dayName;
  final int periodNumber;
  final String periodLabel;
  final String startTime;
  final String endTime;
  final String room;

  String get classLabel => '$className - Section $sectionTitle';

  @override
  List<Object?> get props => [
    id,
    classId,
    className,
    sectionTitle,
    yearTitle,
    stage,
    courseTitle,
    dayName,
    periodNumber,
    periodLabel,
    startTime,
    endTime,
    room,
  ];
}
