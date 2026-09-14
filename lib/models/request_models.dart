import 'package:equatable/equatable.dart';
import 'package:my_school_teacher/models/grade_assessment.dart';
import 'package:my_school_teacher/models/teacher_notice.dart';

class UpsertAgendaRequest extends Equatable {
  const UpsertAgendaRequest({
    required this.assignmentId,
    required this.classId,
    required this.title,
    required this.description,
    required this.date,
    this.imageLink,
    this.fileLink,
    this.published = false,
  });

  final int assignmentId;
  final int classId;
  final String title;
  final String description;
  final DateTime date;
  final String? imageLink;
  final String? fileLink;
  final bool published;

  Map<String, dynamic> toJson() => {
    'assignment_id': assignmentId,
    'class_id': classId,
    'title': title,
    'description': description,
    'date': date.toIso8601String(),
    'image_link': imageLink,
    'file_link': fileLink,
    'published': published,
  };

  @override
  List<Object?> get props => [
    assignmentId,
    classId,
    title,
    description,
    date,
    imageLink,
    fileLink,
    published,
  ];
}

class SaveTeacherGradesRequest extends Equatable {
  const SaveTeacherGradesRequest({
    required this.sectionId,
    required this.courseId,
    required this.gradeTypeId,
    required this.maxGrade,
    required this.publishDate,
    required this.entries,
  });

  final int sectionId;
  final int courseId;
  final int gradeTypeId;
  final double maxGrade;
  final DateTime publishDate;
  final List<StudentGradeInput> entries;

  Map<String, dynamic> toJson() => {
    'sectionId': sectionId,
    'courseId': courseId,
    'gradeTypeId': gradeTypeId,
    'maxGrade': maxGrade,
    'publishDate':
        '${publishDate.year.toString().padLeft(4, '0')}-${publishDate.month.toString().padLeft(2, '0')}-${publishDate.day.toString().padLeft(2, '0')}',
    'entries': entries.map((entry) => entry.toJson()).toList(growable: false),
  };

  @override
  List<Object?> get props => [
    sectionId,
    courseId,
    gradeTypeId,
    maxGrade,
    publishDate,
    entries,
  ];
}

class UpsertNoticeRequest extends Equatable {
  const UpsertNoticeRequest({
    required this.classId,
    required this.targetType,
    required this.targetId,
    required this.title,
    required this.content,
    required this.publishDate,
    this.assignmentId,
  });

  final int classId;
  final NoticeTargetType targetType;
  final int targetId;
  final String title;
  final String content;
  final DateTime publishDate;
  final int? assignmentId;

  Map<String, dynamic> toJson() => {
    'class_id': classId,
    'target_type': targetType.name,
    'target_id': targetId,
    'title': title,
    'content': content,
    'publish_date': publishDate.toIso8601String(),
    'assignment_id': assignmentId,
  };

  @override
  List<Object?> get props => [
    classId,
    targetType,
    targetId,
    title,
    content,
    publishDate,
    assignmentId,
  ];
}
