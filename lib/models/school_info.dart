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
    this.logo,
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
    logo: _optionalLogo(json['logo']),
  );

  factory SchoolInfo.fromSchoolDetailsApiJson(Map<String, dynamic> json) =>
      SchoolInfo(
        name: json['schoolName'] as String,
        telephone: json['telephone'] as String,
        phone: json['phone'] as String,
        fax: json['fax'] as String,
        address: json['address'] as String,
        email: json['email'] as String,
        website: json['website'] as String,
        about: json['about'] as String,
        logo: _optionalLogo(json['logo']),
      );

  static String? _optionalLogo(Object? value) {
    if (value is! String) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  final String name;
  final String telephone;
  final String phone;
  final String fax;
  final String address;
  final String email;
  final String website;
  final String about;
  final String? logo;

  bool get hasLogo => logo != null;

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
    logo,
  ];
}
