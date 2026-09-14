import 'dart:async';

import 'package:my_school_teacher/core/notifications/app_notification.dart';
import 'package:my_school_teacher/core/notifications/push_notification_service.dart';

/// Default injectable [PushNotificationService] used when Firebase is not
/// configured (widget/unit tests, desktop/web targets).
class NoopPushNotificationService implements PushNotificationService {
  final _taps = StreamController<AppNotification>.broadcast();

  @override
  Future<void> init() async {}

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<String?> getToken() async => null;

  @override
  Stream<AppNotification> get notificationTaps => _taps.stream;

  @override
  Future<AppNotification?> initialNotification() async => null;

  /// Test-only helper: simulates a tap arriving through the taps stream.
  void simulateTap(AppNotification notification) => _taps.add(notification);
}
