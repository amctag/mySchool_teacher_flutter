import 'package:equatable/equatable.dart';

class TeacherAssignment extends Equatable {
  const TeacherAssignment({
    required this.id,
    required this.classId,
    required this.schoolClassId,
    required this.className,
    required this.sectionTitle,
    required this.yearTitle,
    required this.stageId,
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
      id: _asInt(json['id']),
      classId: _asInt(json['class_id']),
      schoolClassId: _asInt(
        json['school_class_id'],
        fallback: _asInt(json['class_id']),
      ),
      className: (json['class_name'] as String?) ?? '',
      sectionTitle: (json['section_title'] as String?) ?? '',
      yearTitle: (json['year_title'] as String?) ?? '',
      stageId: _asInt(json['stage_id']),
      stage: (json['stage'] as String?) ?? '',
      courseTitle: (json['course_title'] as String?) ?? '',
      dayName: (json['day_name'] as String?) ?? '',
      periodNumber: _asInt(json['period_number']),
      periodLabel: (json['period_label'] as String?) ?? '',
      startTime: (json['start_time'] as String?) ?? '',
      endTime: (json['end_time'] as String?) ?? '',
      room: (json['room'] as String?) ?? '',
    );
  }

  static int _asInt(dynamic value, {int fallback = 0}) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? fallback;
    }
    return fallback;
  }

  final int id;
  final int classId;
  final int schoolClassId;
  final String className;
  final String sectionTitle;
  final String yearTitle;
  final int stageId;
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
    schoolClassId,
    className,
    sectionTitle,
    yearTitle,
    stageId,
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
