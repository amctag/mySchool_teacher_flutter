import 'package:flutter_test/flutter_test.dart';
import 'package:my_school_teacher/core/notifications/app_notification.dart';
import 'package:my_school_teacher/core/notifications/noop_push_notification_service.dart';

void main() {
  group('AppNotification', () {
    test('parses a notification-block payload', () {
      final notification = AppNotification.fromMessageMap({
        'notification': {'title': 'Hello', 'body': 'World'},
        'data': {'route': 'notices'},
      });

      expect(notification.title, 'Hello');
      expect(notification.body, 'World');
      expect(notification.route, 'notices');
    });

    test('falls back to data-only payload', () {
      final notification = AppNotification.fromMessageMap({
        'data': {'title': 'T', 'body': 'B', 'route': 'grades'},
      });

      expect(notification.title, 'T');
      expect(notification.body, 'B');
      expect(notification.route, 'grades');
    });
  });

  group('NoopPushNotificationService', () {
    test('never reports a token and stores no initial notification', () async {
      final service = NoopPushNotificationService();

      await service.init();
      expect(await service.getToken(), isNull);
      expect(await service.initialNotification(), isNull);
      expect(await service.requestPermission(), isFalse);
    });

    test('streams simulated taps', () async {
      final service = NoopPushNotificationService();
      final taps = <AppNotification>[];
      service.notificationTaps.listen(taps.add);

      service.simulateTap(
        const AppNotification(title: 'New notice', route: 'notices'),
      );
      await Future<void>.delayed(Duration.zero);

      expect(taps, hasLength(1));
      expect(taps.single.route, 'notices');
    });
  });
}
