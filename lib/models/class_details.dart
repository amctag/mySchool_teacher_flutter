import 'package:equatable/equatable.dart';
import 'package:my_school_teacher/models/teacher_class_summary.dart';
import 'package:my_school_teacher/models/teacher_schedule.dart';

class StudentSummary extends Equatable {
  const StudentSummary({
    required this.id,
    required this.fullName,
    required this.seatNumber,
  });

  factory StudentSummary.fromJson(Map<String, dynamic> json) {
    return StudentSummary(
      id: json['id'] as int,
      fullName: (json['full_name'] ?? json['fullName']) as String,
      seatNumber: (json['seat_number'] ?? json['seatNumber']) as int,
    );
  }

  final int id;
  final String fullName;
  final int seatNumber;

  String get initials => fullName
      .split(' ')
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part[0].toUpperCase())
      .join();

  @override
  List<Object?> get props => [id, fullName, seatNumber];
}

class ClassTeacherRosterEntry extends Equatable {
  const ClassTeacherRosterEntry({
    required this.teacherName,
    required this.courseTitle,
    required this.isCurrentTeacher,
  });

  factory ClassTeacherRosterEntry.fromJson(Map<String, dynamic> json) {
    return ClassTeacherRosterEntry(
      teacherName: (json['teacher_name'] ?? json['teacherName']) as String,
      courseTitle: (json['course_title'] ?? json['courseTitle']) as String,
      isCurrentTeacher:
          (json['is_current_teacher'] ?? json['isCurrentTeacher'] ?? false)
              as bool,
    );
  }

  final String teacherName;
  final String courseTitle;
  final bool isCurrentTeacher;

  @override
  List<Object?> get props => [teacherName, courseTitle, isCurrentTeacher];
}

class ClassDetails extends Equatable {
  const ClassDetails({
    required this.summary,
    required this.students,
    required this.schedule,
    required this.roster,
  });

  factory ClassDetails.fromJson(Map<String, dynamic> json) {
    return ClassDetails(
      summary: TeacherClassSummary.fromJson(
        json['summary'] as Map<String, dynamic>,
      ),
      students: (json['students'] as List<dynamic>)
          .map((item) => StudentSummary.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
      schedule: TeacherSchedule.fromJson(json['schedule'] as Map<String, dynamic>),
      roster: (json['roster'] as List<dynamic>)
          .map(
            (item) =>
                ClassTeacherRosterEntry.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
    );
  }

  final TeacherClassSummary summary;
  final List<StudentSummary> students;
  final TeacherSchedule schedule;
  final List<ClassTeacherRosterEntry> roster;

  @override
  List<Object?> get props => [summary, students, schedule, roster];
}
