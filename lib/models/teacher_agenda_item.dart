import 'package:equatable/equatable.dart';

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
    this.published = false,
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
      published: json['published'] == true || json['status'] == 1,
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
  final bool published;

  TeacherAgendaItem copyWith({bool? published}) {
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
      published: published ?? this.published,
    );
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
    published,
  ];
}
