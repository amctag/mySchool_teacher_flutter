import 'dart:convert';

import 'package:equatable/equatable.dart';

class TeacherPushNotification extends Equatable {
  const TeacherPushNotification({
    required this.id,
    required this.title,
    required this.body,
    this.type,
    this.route,
    this.data = const {},
    required this.createdAt,
  });

  factory TeacherPushNotification.fromApiJson(Map<String, dynamic> json) {
    final data = <String, String>{};
    final rawData = json['data'];
    if (rawData is Map) {
      for (final entry in rawData.entries) {
        if (entry.value == null) continue;
        data['${entry.key}'] = '${entry.value}';
      }
    } else if (rawData is String && rawData.trim().isNotEmpty) {
      try {
        final parsed = jsonDecode(rawData);
        if (parsed is Map) {
          for (final entry in parsed.entries) {
            if (entry.value == null) continue;
            data['${entry.key}'] = '${entry.value}';
          }
        }
      } catch (_) {}
    }

    final createdRaw = json['createdAt'] ?? json['created_at'];
    if (createdRaw == null) {
      throw FormatException('Notification missing createdAt', json);
    }

    return TeacherPushNotification(
      id: _readInt(json['id']),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      type: json['type'] as String?,
      route: json['route'] as String?,
      data: data,
      createdAt: DateTime.parse(createdRaw.toString()).toLocal(),
    );
  }

  static int _readInt(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String && value.trim().isNotEmpty) {
      return int.parse(value);
    }
    throw FormatException('Invalid notification id', value);
  }

  final int id;
  final String title;
  final String body;
  final String? type;
  final String? route;
  final Map<String, String> data;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, title, body, type, route, data, createdAt];
}
