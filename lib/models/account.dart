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
  );

  final int id;
  final String fullName;
  final String username;
  final String? email;
  final List<String> roles;
  final String? title;
  final String? department;
  final String? phone;

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
  ];
}
