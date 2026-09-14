import 'package:equatable/equatable.dart';

class Announcement extends Equatable {
  const Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.creator,
    required this.publishDate,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
    id: json['id'] as int,
    title: (json['title'] as String?)?.trim().isNotEmpty == true
        ? json['title'] as String
        : 'School announcement',
    content: json['content'] as String,
    creator: json['creator'] as String,
    publishDate: DateTime.parse(json['publish_date'] as String),
  );

  final int id;
  final String title;
  final String content;
  final String creator;
  final DateTime publishDate;

  @override
  List<Object?> get props => [id, title, content, creator, publishDate];
}
