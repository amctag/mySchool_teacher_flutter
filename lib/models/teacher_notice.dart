import 'package:equatable/equatable.dart';

enum NoticeTargetType { student, section }

NoticeTargetType noticeTargetTypeFromJson(String value) {
  return switch (value) {
    'student' => NoticeTargetType.student,
    'section' => NoticeTargetType.section,
    _ => NoticeTargetType.section,
  };
}

class TeacherNotice extends Equatable {
  const TeacherNotice({
    required this.id,
    required this.assignmentId,
    required this.classId,
    required this.targetType,
    required this.targetId,
    required this.targetLabel,
    required this.classLabel,
    required this.title,
    required this.content,
    required this.creator,
    required this.publishDate,
  });

  factory TeacherNotice.fromJson(Map<String, dynamic> json) {
    return TeacherNotice(
      id: json['id'] as int,
      assignmentId: (json['assignment_id'] ?? json['assignmentId']) as int?,
      classId: (json['class_id'] ?? json['classId']) as int,
      targetType: noticeTargetTypeFromJson(
        (json['target_type'] ?? json['targetType'] ?? 'section') as String,
      ),
      targetId: (json['target_id'] ?? json['targetId']) as int,
      targetLabel: (json['target_label'] ?? json['targetLabel'] ?? '') as String,
      classLabel: (json['class_label'] ?? json['classLabel'] ?? '') as String,
      title: json['title'] as String,
      content: (json['content'] ?? json['description'] ?? '') as String,
      creator: json['creator'] as String,
      publishDate: DateTime.parse(
        (json['publish_date'] ?? json['publishDate']) as String,
      ),
    );
  }

  final int id;
  final int? assignmentId;
  final int classId;
  final NoticeTargetType targetType;
  final int targetId;
  final String targetLabel;
  final String classLabel;
  final String title;
  final String content;
  final String creator;
  final DateTime publishDate;

  @override
  List<Object?> get props => [
    id,
    assignmentId,
    classId,
    targetType,
    targetId,
    targetLabel,
    classLabel,
    title,
    content,
    creator,
    publishDate,
  ];
}
