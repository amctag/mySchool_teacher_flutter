import 'package:equatable/equatable.dart';

/// Framework-agnostic push notification payload used by the app layer.
class AppNotification extends Equatable {
  const AppNotification({
    this.title,
    this.body,
    this.route,
    this.data = const {},
  });

  /// Built from an FCM [RemoteMessage]-shaped map so services stay decoupled.
  factory AppNotification.fromMessageMap(Map<String, dynamic> message) {
    final notification = message['notification'] as Map<String, dynamic>?;
    final data = Map<String, dynamic>.from(
      (message['data'] as Map<String, dynamic>? ?? const {}) as Map,
    );
    return AppNotification(
      title: (notification?['title'] ?? data['title']) as String?,
      body: (notification?['body'] ?? data['body']) as String?,
      route: (data['route'] ?? data['type']) as String?,
      data: data,
    );
  }

  final String? title;
  final String? body;

  /// Navigation hint emitted by the server (e.g. "notices").
  final String? route;

  /// Extra key/value payload (ids, URLs, ...).
  final Map<String, dynamic> data;

  @override
  List<Object?> get props => [title, body, route, data];
}
