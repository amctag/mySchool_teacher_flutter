import 'package:equatable/equatable.dart';

class AgendaEntry extends Equatable {
  const AgendaEntry({
    required this.id,
    required this.description,
    required this.date,
    required this.creator,
    required this.course,
    required this.publishedDate,
    required this.time,
    this.imageLink,
    this.fileLink,
  });

  factory AgendaEntry.fromJson(Map<String, dynamic> json) => AgendaEntry(
    id: json['id'] as int,
    description: json['description'] as String,
    date: DateTime.parse(json['date'] as String),
    creator: json['creator'] as String,
    course: json['course'] as String,
    publishedDate: DateTime.parse(json['published_date'] as String),
    time: json['time'] as String,
    imageLink: json['image_link'] as String?,
    fileLink: json['file_link'] as String?,
  );

  final int id;
  final String description;
  final DateTime date;
  final String creator;
  final String course;
  final DateTime publishedDate;
  final String time;
  final String? imageLink;
  final String? fileLink;

  bool get hasImage => imageLink?.isNotEmpty ?? false;
  bool get hasFile => fileLink?.isNotEmpty ?? false;

  @override
  List<Object?> get props => [
    id,
    description,
    date,
    creator,
    course,
    publishedDate,
    time,
    imageLink,
    fileLink,
  ];
}
