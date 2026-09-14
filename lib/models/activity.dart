import 'package:equatable/equatable.dart';

class SchoolActivity extends Equatable {
  const SchoolActivity({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.imageKey,
    required this.creator,
  });

  factory SchoolActivity.fromJson(Map<String, dynamic> json) => SchoolActivity(
    id: json['id'] as int,
    title: json['title'] as String,
    content: json['content'] as String,
    date: DateTime.parse(json['date'] as String),
    imageKey: json['image'] as String,
    creator: json['creator'] as String,
  );

  final int id;
  final String title;
  final String content;
  final DateTime date;
  final String imageKey;
  final String creator;

  @override
  List<Object?> get props => [id, title, content, date, imageKey, creator];
}
