import 'package:equatable/equatable.dart';

class TeacherScheduleEntry extends Equatable {
  const TeacherScheduleEntry({
    required this.assignmentId,
    required this.classId,
    required this.classLabel,
    required this.courseTitle,
    required this.periodNumber,
    required this.periodLabel,
    required this.startTime,
    required this.endTime,
    required this.room,
  });

  factory TeacherScheduleEntry.fromJson(Map<String, dynamic> json) {
    return TeacherScheduleEntry(
      assignmentId: (json['assignment_id'] as num).toInt(),
      classId: (json['class_id'] as num).toInt(),
      classLabel: json['class_label'] as String,
      courseTitle: json['course_title'] as String,
      periodNumber: (json['period_number'] as num).toInt(),
      periodLabel: json['period_label'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      room: json['room'] as String,
    );
  }

  final int assignmentId;
  final int classId;
  final String classLabel;
  final String courseTitle;
  final int periodNumber;
  final String periodLabel;
  final String startTime;
  final String endTime;
  final String room;

  @override
  List<Object?> get props => [
    assignmentId,
    classId,
    classLabel,
    courseTitle,
    periodNumber,
    periodLabel,
    startTime,
    endTime,
    room,
  ];
}

class TeacherScheduleDay extends Equatable {
  const TeacherScheduleDay({
    required this.dayName,
    required this.position,
    required this.entries,
  });

  factory TeacherScheduleDay.fromJson(Map<String, dynamic> json) {
    return TeacherScheduleDay(
      dayName: json['day_name'] as String,
      position: (json['position'] as num).toInt(),
      entries: (json['entries'] as List<dynamic>)
          .map(
            (item) => TeacherScheduleEntry.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(growable: false),
    );
  }

  final String dayName;
  final int position;
  final List<TeacherScheduleEntry> entries;

  @override
  List<Object?> get props => [dayName, position, entries];
}

class TeacherSchedule extends Equatable {
  const TeacherSchedule({
    required this.ownerLabel,
    required this.days,
  });

  factory TeacherSchedule.fromJson(Map<String, dynamic> json) {
    return TeacherSchedule(
      ownerLabel: json['owner_label'] as String,
      days: (json['days'] as List<dynamic>)
          .map(
            (item) => TeacherScheduleDay.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
    );
  }

  final String ownerLabel;
  final List<TeacherScheduleDay> days;

  @override
  List<Object?> get props => [ownerLabel, days];
}
