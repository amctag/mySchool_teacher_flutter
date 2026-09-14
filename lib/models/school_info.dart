import 'package:equatable/equatable.dart';

class SchoolInfo extends Equatable {
  const SchoolInfo({
    required this.name,
    required this.telephone,
    required this.phone,
    required this.fax,
    required this.address,
    required this.email,
    required this.website,
    required this.about,
  });

  factory SchoolInfo.fromJson(Map<String, dynamic> json) => SchoolInfo(
    name: json['name'] as String,
    telephone: json['telephone'] as String,
    phone: json['phone'] as String,
    fax: json['fax'] as String,
    address: json['address'] as String,
    email: json['email'] as String,
    website: json['website'] as String,
    about: json['about'] as String,
  );

  final String name;
  final String telephone;
  final String phone;
  final String fax;
  final String address;
  final String email;
  final String website;
  final String about;

  @override
  List<Object?> get props => [
    name,
    telephone,
    phone,
    fax,
    address,
    email,
    website,
    about,
  ];
}
