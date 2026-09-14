import 'package:equatable/equatable.dart';

class GradeTypeOption extends Equatable {
  const GradeTypeOption({
    required this.id,
    required this.title,
    this.isMain = false,
  });

  factory GradeTypeOption.fromJson(Map<String, dynamic> json) {
    return GradeTypeOption(
      id: json['id'] as int,
      title: (json['title'] ?? '') as String,
      isMain: parseJsonBool(json['isMain'] ?? json['is_main']),
    );
  }

  final int id;
  final String title;
  final bool isMain;

  @override
  List<Object?> get props => [id, title, isMain];
}

bool parseJsonBool(Object? value) {
  return value == true || value == 1 || value == '1' || value == 'true';
}

class GradeCourseOption extends Equatable {
  const GradeCourseOption({
    required this.id,
    required this.title,
    required this.assignmentId,
    required this.coefficient,
  });

  factory GradeCourseOption.fromJson(Map<String, dynamic> json) {
    return GradeCourseOption(
      id: json['id'] as int,
      title: (json['title'] ?? '') as String,
      assignmentId: (json['assignmentId'] ?? json['assignment_id'] ?? 0) as int,
      coefficient: ((json['coefficient'] ?? 1) as num).toDouble(),
    );
  }

  final int id;
  final String title;
  final int assignmentId;
  final double coefficient;

  @override
  List<Object?> get props => [id, title, assignmentId, coefficient];
}

class GradeSectionOption extends Equatable {
  const GradeSectionOption({
    required this.id,
    required this.title,
    required this.courses,
  });

  factory GradeSectionOption.fromJson(Map<String, dynamic> json) {
    return GradeSectionOption(
      id: json['id'] as int,
      title: (json['title'] ?? '') as String,
      courses: ((json['courses'] as List<dynamic>?) ?? const [])
          .map((item) => GradeCourseOption.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  final int id;
  final String title;
  final List<GradeCourseOption> courses;

  @override
  List<Object?> get props => [id, title, courses];
}

class GradeClassOption extends Equatable {
  const GradeClassOption({
    required this.id,
    required this.name,
    required this.sections,
  });

  factory GradeClassOption.fromJson(Map<String, dynamic> json) {
    return GradeClassOption(
      id: json['id'] as int,
      name: (json['name'] ?? '') as String,
      sections: ((json['sections'] as List<dynamic>?) ?? const [])
          .map(
            (item) => GradeSectionOption.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
    );
  }

  final int id;
  final String name;
  final List<GradeSectionOption> sections;

  @override
  List<Object?> get props => [id, name, sections];
}

class GradeOptions extends Equatable {
  const GradeOptions({
    required this.classes,
    required this.gradeTypes,
  });

  factory GradeOptions.fromJson(Map<String, dynamic> json) {
    return GradeOptions(
      classes: ((json['classes'] as List<dynamic>?) ?? const [])
          .map((item) => GradeClassOption.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
      gradeTypes: ((json['gradeTypes'] ?? json['grade_types'] ?? const [])
              as List<dynamic>)
          .map((item) => GradeTypeOption.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  final List<GradeClassOption> classes;
  final List<GradeTypeOption> gradeTypes;

  @override
  List<Object?> get props => [classes, gradeTypes];
}
