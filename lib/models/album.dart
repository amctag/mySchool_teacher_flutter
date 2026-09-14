import 'package:equatable/equatable.dart';

class SchoolAlbum extends Equatable {
  const SchoolAlbum({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.yearTitle,
    required this.isActive,
    required this.photoCount,
  });

  factory SchoolAlbum.fromJson(Map<String, dynamic> json) => SchoolAlbum(
    id: json['id'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    date: DateTime.parse(json['date'] as String),
    yearTitle: json['year_title'] as String,
    isActive: json['status'] as int == 1,
    photoCount: json['photo_count'] as int,
  );

  final int id;
  final String title;
  final String description;
  final DateTime date;
  final String yearTitle;
  final bool isActive;
  final int photoCount;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    date,
    yearTitle,
    isActive,
    photoCount,
  ];
}
