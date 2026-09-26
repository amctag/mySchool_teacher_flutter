import 'package:my_school_teacher/core/notifications/app_notification.dart';

/// Abstraction over push notification delivery (FCM in production,
/// no-op in tests/desktop).
abstract class PushNotificationService {
  /// Configures the platform notification pipeline. Safe to call once.
  Future<void> init();

  /// Requests notification permission; returns whether it was granted.
  Future<bool> requestPermission();

  /// Current registration token for this install, or null when unavailable.
  ///
  /// On web, [prompt] controls whether Chrome's Allow dialog is shown.
  Future<String?> getToken({bool prompt = true});

  /// Emits a notification when the user taps on it (foreground or background).
  Stream<AppNotification> get notificationTaps;

  /// Notification that launched the app from a terminated state, if any.
  Future<AppNotification?> initialNotification();
}
