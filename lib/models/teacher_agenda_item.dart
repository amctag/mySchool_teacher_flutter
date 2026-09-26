import 'package:equatable/equatable.dart';

enum AgendaPublishStatus { draft, saved, published }

class TeacherAgendaItem extends Equatable {
  const TeacherAgendaItem({
    required this.id,
    required this.assignmentId,
    required this.classId,
    required this.classLabel,
    required this.courseTitle,
    required this.title,
    required this.description,
    required this.date,
    required this.publishDate,
    required this.time,
    this.imageLink,
    this.fileLink,
    this.status = AgendaPublishStatus.draft,
    this.isOwn = true,
    this.canPublish = true,
  });

  factory TeacherAgendaItem.fromJson(Map<String, dynamic> json) {
    return TeacherAgendaItem(
      id: json['id'] as int,
      assignmentId: (json['assignment_id'] ?? json['assignmentId'] ?? 0) as int,
      classId: (json['class_id'] ?? json['classId']) as int,
      classLabel: (json['class_label'] ?? json['classLabel'] ?? '') as String,
      courseTitle: (json['course_title'] ?? json['courseTitle'] ?? '') as String,
      title: (json['title'] ?? json['course_title'] ?? json['courseTitle'] ?? '')
          as String,
      description: (json['description'] ?? '') as String,
      date: DateTime.parse(json['date'] as String),
      publishDate: DateTime.parse(
        (json['publish_date'] ?? json['publishDate'] ?? json['date']) as String,
      ),
      time: (json['time'] ?? '') as String,
      imageLink: _optionalLink(json['image_link'] ?? json['imageLink']),
      fileLink: _optionalLink(
        json['file_link'] ??
            json['fileLink'] ??
            json['attachment_url'] ??
            json['attachmentUrl'],
      ),
      status: _parseStatus(json),
      isOwn: json['is_own'] == true ||
          json['isOwn'] == true ||
          (json['is_own'] == null && json['isOwn'] == null),
      canPublish: json['can_publish'] != false &&
          json['canPublish'] != false,
    );
  }

  final int id;
  final int assignmentId;
  final int classId;
  final String classLabel;
  final String courseTitle;
  final String title;
  final String description;
  final DateTime date;
  final DateTime publishDate;
  final String time;
  final String? imageLink;
  final String? fileLink;
  final AgendaPublishStatus status;
  final bool isOwn;
  final bool canPublish;

  bool get published => status == AgendaPublishStatus.published;
  bool get isDraft => status == AgendaPublishStatus.draft;
  bool get isSaved => status == AgendaPublishStatus.saved;

  TeacherAgendaItem copyWith({
    AgendaPublishStatus? status,
    bool? published,
    bool? canPublish,
  }) {
    var nextStatus = status ?? this.status;
    if (published == true) {
      nextStatus = AgendaPublishStatus.published;
    } else if (published == false && status == null) {
      nextStatus = AgendaPublishStatus.saved;
    }
    return TeacherAgendaItem(
      id: id,
      assignmentId: assignmentId,
      classId: classId,
      classLabel: classLabel,
      courseTitle: courseTitle,
      title: title,
      description: description,
      date: date,
      publishDate: publishDate,
      time: time,
      imageLink: imageLink,
      fileLink: fileLink,
      status: nextStatus,
      isOwn: isOwn,
      canPublish: canPublish ?? this.canPublish,
    );
  }

  static AgendaPublishStatus _parseStatus(Map<String, dynamic> json) {
    final raw = json['status'];
    if (raw is String) {
      switch (raw.toLowerCase()) {
        case 'published':
          return AgendaPublishStatus.published;
        case 'saved':
          return AgendaPublishStatus.saved;
        case 'draft':
          return AgendaPublishStatus.draft;
      }
    }
    if (raw == 1 || json['published'] == true) {
      return AgendaPublishStatus.published;
    }
    if (raw == 2) {
      return AgendaPublishStatus.saved;
    }
    return AgendaPublishStatus.draft;
  }

  static String? _optionalLink(dynamic value) {
    if (value is! String) {
      return null;
    }
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  @override
  List<Object?> get props => [
    id,
    assignmentId,
    classId,
    classLabel,
    courseTitle,
    title,
    description,
    date,
    publishDate,
    time,
    imageLink,
    fileLink,
    status,
    isOwn,
    canPublish,
  ];
}
