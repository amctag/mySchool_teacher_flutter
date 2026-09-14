import 'package:equatable/equatable.dart';

class ParentNotice extends Equatable {
  const ParentNotice({
    required this.id,
    required this.scope,
    required this.scopeLabel,
    required this.title,
    required this.content,
    required this.creator,
    required this.publishDate,
  });

  factory ParentNotice.fromJson(Map<String, dynamic> json) => ParentNotice(
    id: json['id'] as int,
    scope: json['scope'] as String,
    scopeLabel: json['scope_label'] as String,
    title: json['title'] as String,
    content: json['content'] as String,
    creator: json['creator'] as String,
    publishDate: DateTime.parse(json['publish_date'] as String),
  );

  final int id;
  final String scope;
  final String scopeLabel;
  final String title;
  final String content;
  final String creator;
  final DateTime publishDate;

  @override
  List<Object?> get props => [
    id,
    scope,
    scopeLabel,
    title,
    content,
    creator,
    publishDate,
  ];
}
