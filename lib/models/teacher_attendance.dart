import 'package:equatable/equatable.dart';
import 'package:my_school_teacher/models/attendance.dart';
import 'package:my_school_teacher/models/grade_options.dart';

int parseJsonInt(Object? value, [int fallback = 0]) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return fallback;
}

String formatDateOnly(DateTime value) {
  return '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}

DateTime parseDateOnly(String value) {
  return DateTime.parse('${value.substring(0, 10)}T00:00:00.000');
}

class AttendanceReasonOption extends Equatable {
  const AttendanceReasonOption({required this.id, required this.title});

  factory AttendanceReasonOption.fromJson(Map<String, dynamic> json) {
    return AttendanceReasonOption(
      id: parseJsonInt(json['id']),
      title: (json['title'] ?? '') as String,
    );
  }

  final int id;
  final String title;

  @override
  List<Object?> get props => [id, title];
}

class AttendanceCourseOption extends Equatable {
  const AttendanceCourseOption({required this.id, required this.title});

  factory AttendanceCourseOption.fromJson(Map<String, dynamic> json) {
    return AttendanceCourseOption(
      id: parseJsonInt(json['id']),
      title: (json['title'] ?? '') as String,
    );
  }

  final int id;
  final String title;

  @override
  List<Object?> get props => [id, title];
}

class AttendanceSectionOption extends Equatable {
  const AttendanceSectionOption({
    required this.id,
    required this.title,
    required this.courses,
  });

  factory AttendanceSectionOption.fromJson(Map<String, dynamic> json) {
    return AttendanceSectionOption(
      id: parseJsonInt(json['id']),
      title: (json['title'] ?? '') as String,
      courses: ((json['courses'] as List<dynamic>?) ?? const [])
          .map(
            (item) => AttendanceCourseOption.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(growable: false),
    );
  }

  final int id;
  final String title;
  final List<AttendanceCourseOption> courses;

  @override
  List<Object?> get props => [id, title, courses];
}

class AttendanceClassOption extends Equatable {
  const AttendanceClassOption({
    required this.id,
    required this.name,
    required this.sections,
  });

  factory AttendanceClassOption.fromJson(Map<String, dynamic> json) {
    return AttendanceClassOption(
      id: parseJsonInt(json['id']),
      name: (json['name'] ?? '') as String,
      sections: ((json['sections'] as List<dynamic>?) ?? const [])
          .map(
            (item) => AttendanceSectionOption.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(growable: false),
    );
  }

  final int id;
  final String name;
  final List<AttendanceSectionOption> sections;

  @override
  List<Object?> get props => [id, name, sections];
}

class TeacherAttendanceOptions extends Equatable {
  const TeacherAttendanceOptions({
    required this.attendancePerCourse,
    this.canTakeAttendance = false,
    required this.classes,
    required this.reasons,
  });

  factory TeacherAttendanceOptions.fromJson(Map<String, dynamic> json) {
    final attendancePerCourse = parseJsonBool(
      json['attendancePerCourse'] ?? json['attendance_per_course'],
    );
    final canTake = json['canTakeAttendance'] ?? json['can_take_attendance'];
    return TeacherAttendanceOptions(
      attendancePerCourse: attendancePerCourse,
      canTakeAttendance: canTake == null
          ? attendancePerCourse
          : parseJsonBool(canTake),
      classes: ((json['classes'] as List<dynamic>?) ?? const [])
          .map(
            (item) => AttendanceClassOption.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(growable: false),
      reasons: ((json['reasons'] as List<dynamic>?) ?? const [])
          .map(
            (item) => AttendanceReasonOption.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(growable: false),
    );
  }

  static const empty = TeacherAttendanceOptions(
    attendancePerCourse: false,
    canTakeAttendance: false,
    classes: [],
    reasons: [],
  );

  final bool attendancePerCourse;
  final bool canTakeAttendance;
  final List<AttendanceClassOption> classes;
  final List<AttendanceReasonOption> reasons;

  @override
  List<Object?> get props => [
    attendancePerCourse,
    canTakeAttendance,
    classes,
    reasons,
  ];
}

class TeacherAttendanceListItem extends Equatable {
  const TeacherAttendanceListItem({
    required this.id,
    required this.date,
    required this.sectionId,
    required this.classLabel,
    this.courseId,
    this.courseTitle,
    required this.studentCount,
    required this.absentCount,
  });

  factory TeacherAttendanceListItem.fromJson(Map<String, dynamic> json) {
    final dateValue = json['date'] as String;
    return TeacherAttendanceListItem(
      id: parseJsonInt(json['id']),
      date: parseDateOnly(dateValue),
      sectionId: parseJsonInt(json['sectionId'] ?? json['section_id']),
      classLabel: (json['classLabel'] ?? json['class_label'] ?? '') as String,
      courseId: json['courseId'] == null && json['course_id'] == null
          ? null
          : parseJsonInt(json['courseId'] ?? json['course_id']),
      courseTitle: (json['courseTitle'] ?? json['course_title']) as String?,
      studentCount: parseJsonInt(json['studentCount'] ?? json['student_count']),
      absentCount: parseJsonInt(json['absentCount'] ?? json['absent_count']),
    );
  }

  final int id;
  final DateTime date;
  final int sectionId;
  final String classLabel;
  final int? courseId;
  final String? courseTitle;
  final int studentCount;
  final int absentCount;

  @override
  List<Object?> get props => [
    id,
    date,
    sectionId,
    classLabel,
    courseId,
    courseTitle,
    studentCount,
    absentCount,
  ];
}

class TeacherAttendanceStudent extends Equatable {
  const TeacherAttendanceStudent({
    required this.studentId,
    required this.registrationId,
    required this.studentName,
    required this.status,
    this.attendanceReasonId,
    this.attendanceReasonTitle,
    this.description,
  });

  factory TeacherAttendanceStudent.fromJson(Map<String, dynamic> json) {
    return TeacherAttendanceStudent(
      studentId: parseJsonInt(json['studentId'] ?? json['student_id']),
      registrationId: parseJsonInt(
        json['registrationId'] ?? json['registration_id'],
      ),
      studentName:
          (json['studentName'] ?? json['student_name'] ?? '') as String,
      status: AttendanceStatus.fromJson(
        (json['status'] ?? 'present') as String,
      ),
      attendanceReasonId:
          json['attendanceReasonId'] == null &&
              json['attendance_reason_id'] == null
          ? null
          : parseJsonInt(
              json['attendanceReasonId'] ?? json['attendance_reason_id'],
            ),
      attendanceReasonTitle:
          (json['attendanceReasonTitle'] ?? json['attendance_reason_title'])
              as String?,
      description: json['description'] as String?,
    );
  }

  final int studentId;
  final int registrationId;
  final String studentName;
  final AttendanceStatus status;
  final int? attendanceReasonId;
  final String? attendanceReasonTitle;
  final String? description;

  TeacherAttendanceStudent copyWith({
    AttendanceStatus? status,
    int? attendanceReasonId,
    bool clearReason = false,
    String? description,
    bool clearDescription = false,
  }) {
    return TeacherAttendanceStudent(
      studentId: studentId,
      registrationId: registrationId,
      studentName: studentName,
      status: status ?? this.status,
      attendanceReasonId: clearReason
          ? null
          : (attendanceReasonId ?? this.attendanceReasonId),
      attendanceReasonTitle: clearReason ? null : attendanceReasonTitle,
      description: clearDescription ? null : (description ?? this.description),
    );
  }

  @override
  List<Object?> get props => [
    studentId,
    registrationId,
    studentName,
    status,
    attendanceReasonId,
    attendanceReasonTitle,
    description,
  ];
}

class TeacherAttendanceSheet extends Equatable {
  const TeacherAttendanceSheet({
    required this.attendanceId,
    required this.date,
    required this.sectionId,
    required this.classLabel,
    this.courseId,
    this.courseTitle,
    required this.attendancePerCourse,
    required this.students,
  });

  factory TeacherAttendanceSheet.fromJson(Map<String, dynamic> json) {
    return TeacherAttendanceSheet(
      attendanceId: json['attendanceId'] == null && json['attendance_id'] == null
          ? null
          : parseJsonInt(json['attendanceId'] ?? json['attendance_id']),
      date: parseDateOnly(json['date'] as String),
      sectionId: parseJsonInt(json['sectionId'] ?? json['section_id']),
      classLabel: (json['classLabel'] ?? json['class_label'] ?? '') as String,
      courseId: json['courseId'] == null && json['course_id'] == null
          ? null
          : parseJsonInt(json['courseId'] ?? json['course_id']),
      courseTitle: (json['courseTitle'] ?? json['course_title']) as String?,
      attendancePerCourse: parseJsonBool(
        json['attendancePerCourse'] ?? json['attendance_per_course'],
      ),
      students: ((json['students'] as List<dynamic>?) ?? const [])
          .map(
            (item) => TeacherAttendanceStudent.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(growable: false),
    );
  }

  final int? attendanceId;
  final DateTime date;
  final int sectionId;
  final String classLabel;
  final int? courseId;
  final String? courseTitle;
  final bool attendancePerCourse;
  final List<TeacherAttendanceStudent> students;

  @override
  List<Object?> get props => [
    attendanceId,
    date,
    sectionId,
    classLabel,
    courseId,
    courseTitle,
    attendancePerCourse,
    students,
  ];
}
