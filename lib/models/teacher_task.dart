import 'package:equatable/equatable.dart';

class TeacherTask extends Equatable {
  const TeacherTask({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.isCompleted,
    this.completedAt,
  });

  factory TeacherTask.fromApiJson(Map<String, dynamic> json) {
    final completedRaw = json['completedAt'] ?? json['completed_at'];
    return TeacherTask(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      createdAt: DateTime.parse(
        (json['createdAt'] ?? json['created_at']).toString(),
      ).toLocal(),
      isCompleted: json['isCompleted'] == true || json['is_completed'] == true,
      completedAt: completedRaw == null
          ? null
          : DateTime.parse(completedRaw.toString()).toLocal(),
    );
  }

  final int id;
  final String title;
  final String description;
  final DateTime createdAt;
  final bool isCompleted;
  final DateTime? completedAt;

  TeacherTask copyWith({
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return TeacherTask(
      id: id,
      title: title,
      description: description,
      createdAt: createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    createdAt,
    isCompleted,
    completedAt,
  ];
}
