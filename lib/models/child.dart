import 'package:equatable/equatable.dart';

class Enrollment extends Equatable {
  const Enrollment({
    required this.id,
    required this.className,
    required this.sectionTitle,
    required this.yearTitle,
    required this.stage,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) => Enrollment(
    id: json['id'] as int,
    className: json['class_name'] as String,
    sectionTitle: json['section_title'] as String,
    yearTitle: json['year_title'] as String,
    stage: json['stage'] as String,
  );

  final int id;
  final String className;
  final String sectionTitle;
  final String yearTitle;
  final String stage;

  @override
  List<Object?> get props => [id, className, sectionTitle, yearTitle, stage];
}

class Child extends Equatable {
  const Child({
    required this.id,
    required this.fullName,
    required this.firstName,
    required this.enrollment,
    this.birthday,
    this.motherName,
    this.picture,
  });

  factory Child.fromJson(Map<String, dynamic> json) => Child(
    id: json['id'] as int,
    fullName: json['full_name'] as String,
    firstName: json['first_name'] as String,
    motherName: json['mother_name'] as String?,
    picture: json['picture'] as String?,
    birthday: json['birthday'] == null
        ? null
        : DateTime.parse(json['birthday'] as String),
    enrollment: Enrollment.fromJson(json['enrollment'] as Map<String, dynamic>),
  );

  final int id;
  final String fullName;
  final String firstName;
  final String? motherName;
  final String? picture;
  final DateTime? birthday;
  final Enrollment enrollment;

  String get initials => fullName
      .split(' ')
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part[0].toUpperCase())
      .join();

  @override
  List<Object?> get props => [
    id,
    fullName,
    firstName,
    motherName,
    picture,
    birthday,
    enrollment,
  ];
}
