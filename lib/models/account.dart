import 'package:equatable/equatable.dart';

class Account extends Equatable {
  const Account({
    required this.id,
    required this.fullName,
    required this.username,
    required this.roles,
    this.email,
    this.title,
    this.department,
    this.phone,
    this.isSupervisor = false,
    this.supervisedClassIds = const [],
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    id: (json['id'] as num).toInt(),
    fullName: json['full_name'] as String,
    username: json['username'] as String,
    email: json['email'] as String?,
    roles: List<String>.from(json['roles'] as List<dynamic>),
    title: json['title'] as String?,
    department: json['department'] as String?,
    phone: json['phone'] as String?,
    isSupervisor:
        json['is_supervisor'] == true || json['isSupervisor'] == true,
    supervisedClassIds: ((json['supervised_class_ids'] ??
                json['supervisedClassIds']) as List<dynamic>? ??
            const [])
        .map((item) => (item as num).toInt())
        .toList(growable: false),
  );

  final int id;
  final String fullName;
  final String username;
  final String? email;
  final List<String> roles;
  final String? title;
  final String? department;
  final String? phone;
  final bool isSupervisor;
  final List<int> supervisedClassIds;

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
    username,
    email,
    roles,
    title,
    department,
    phone,
    isSupervisor,
    supervisedClassIds,
  ];
}
