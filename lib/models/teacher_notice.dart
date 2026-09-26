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
    this.targetIds = const [],
    required this.targetLabel,
    required this.classLabel,
    required this.title,
    required this.content,
    required this.creator,
    required this.publishDate,
  });

  factory TeacherNotice.fromJson(Map<String, dynamic> json) {
    final rawIds = json['target_ids'] ?? json['targetIds'];
    final parsedIds = rawIds is List
        ? rawIds.map((item) => item as int).toList(growable: false)
        : const <int>[];
    final targetId = (json['target_id'] ?? json['targetId']) as int;
    return TeacherNotice(
      id: json['id'] as int,
      assignmentId: (json['assignment_id'] ?? json['assignmentId']) as int?,
      classId: (json['class_id'] ?? json['classId']) as int,
      targetType: noticeTargetTypeFromJson(
        (json['target_type'] ?? json['targetType'] ?? 'section') as String,
      ),
      targetId: targetId,
      targetIds: parsedIds.isNotEmpty ? parsedIds : [targetId],
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
  final List<int> targetIds;
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
    targetIds,
    targetLabel,
    classLabel,
    title,
    content,
    creator,
    publishDate,
  ];
}
