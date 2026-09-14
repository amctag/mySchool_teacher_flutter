import 'package:equatable/equatable.dart';

class ExamScheduleItem extends Equatable {
  const ExamScheduleItem({
    required this.position,
    required this.courseTitle,
    required this.startTime,
    required this.endTime,
    required this.room,
    this.note,
  });

  factory ExamScheduleItem.fromJson(Map<String, dynamic> json) =>
      ExamScheduleItem(
        position: json['position'] as int,
        courseTitle: json['course_title'] as String,
        startTime: json['start_time'] as String,
        endTime: json['end_time'] as String,
        room: json['room'] as String,
        note: json['note'] as String?,
      );

  final int position;
  final String courseTitle;
  final String startTime;
  final String endTime;
  final String room;
  final String? note;

  @override
  List<Object?> get props => [
    position,
    courseTitle,
    startTime,
    endTime,
    room,
    note,
  ];
}

class ExamScheduleDay extends Equatable {
  const ExamScheduleDay({required this.date, required this.items});

  factory ExamScheduleDay.fromJson(Map<String, dynamic> json) =>
      ExamScheduleDay(
        date: DateTime.parse(json['date'] as String),
        items: (json['items'] as List<dynamic>)
            .map(
              (item) => ExamScheduleItem.fromJson(item as Map<String, dynamic>),
            )
            .toList(growable: false),
      );

  final DateTime date;
  final List<ExamScheduleItem> items;

  @override
  List<Object?> get props => [date, items];
}

class ChildExamSchedule extends Equatable {
  const ChildExamSchedule({
    required this.childId,
    required this.yearTitle,
    required this.days,
  });

  factory ChildExamSchedule.fromJson(Map<String, dynamic> json) =>
      ChildExamSchedule(
        childId: json['child_id'] as int,
        yearTitle: json['year_title'] as String,
        days: (json['days'] as List<dynamic>)
            .map(
              (item) => ExamScheduleDay.fromJson(item as Map<String, dynamic>),
            )
            .toList(growable: false),
      );

  final int childId;
  final String yearTitle;
  final List<ExamScheduleDay> days;

  @override
  List<Object?> get props => [childId, yearTitle, days];
}
