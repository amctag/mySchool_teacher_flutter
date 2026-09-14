import 'package:equatable/equatable.dart';

class TeacherAnnouncement extends Equatable {
  const TeacherAnnouncement({
    required this.id,
    required this.title,
    required this.content,
    required this.isGlobal,
    required this.scopeLabel,
    required this.publishedAt,
  });

  factory TeacherAnnouncement.fromJson(Map<String, dynamic> json) {
    final title = (json['title'] ?? '') as String;
    return TeacherAnnouncement(
      id: json['id'] as int,
      title: title.trim().isEmpty ? 'Announcement' : title,
      content: (json['content'] ?? '') as String,
      isGlobal: json['isGlobal'] == true || json['is_global'] == true,
      scopeLabel:
          (json['scopeLabel'] ?? json['scope_label'] ?? '') as String,
      publishedAt: DateTime.parse(
        (json['publishedAt'] ??
            json['published_at'] ??
            json['publishDate'] ??
            json['publish_date']) as String,
      ),
    );
  }

  final int id;
  final String title;
  final String content;
  final bool isGlobal;
  final String scopeLabel;
  final DateTime publishedAt;

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    isGlobal,
    scopeLabel,
    publishedAt,
  ];
}
