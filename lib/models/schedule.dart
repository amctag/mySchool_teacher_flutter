import 'package:equatable/equatable.dart';

class ScheduleSession extends Equatable {
  const ScheduleSession({
    required this.position,
    required this.name,
    required this.course,
    this.note,
  });

  factory ScheduleSession.fromJson(Map<String, dynamic> json) =>
      ScheduleSession(
        position: json['position'] as int,
        name: json['session_name'] as String,
        course: json['course'] as String,
        note: json['note'] as String?,
      );

  final int position;
  final String name;
  final String course;
  final String? note;

  @override
  List<Object?> get props => [position, name, course, note];
}

class ScheduleDay extends Equatable {
  const ScheduleDay({
    required this.name,
    required this.position,
    required this.sessions,
  });

  factory ScheduleDay.fromJson(Map<String, dynamic> json) => ScheduleDay(
    name: json['day_name'] as String,
    position: json['position'] as int,
    sessions: (json['sessions'] as List<dynamic>)
        .map((item) => ScheduleSession.fromJson(item as Map<String, dynamic>))
        .toList(growable: false),
  );

  final String name;
  final int position;
  final List<ScheduleSession> sessions;

  @override
  List<Object?> get props => [name, position, sessions];
}

class WeeklySchedule extends Equatable {
  const WeeklySchedule({
    required this.childId,
    required this.childName,
    required this.days,
  });

  factory WeeklySchedule.fromJson(Map<String, dynamic> json) => WeeklySchedule(
    childId: json['child_id'] as int,
    childName: json['child_name'] as String,
    days: (json['days'] as List<dynamic>)
        .map((item) => ScheduleDay.fromJson(item as Map<String, dynamic>))
        .toList(growable: false),
  );

  final int childId;
  final String childName;
  final List<ScheduleDay> days;

  int get maxSessions =>
      days.expand((day) => day.sessions).fold(0, (maximum, session) {
        return session.position > maximum ? session.position : maximum;
      });

  @override
  List<Object?> get props => [childId, childName, days];
}
