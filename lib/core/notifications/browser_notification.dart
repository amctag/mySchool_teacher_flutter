import 'browser_notification_stub.dart'
    if (dart.library.html) 'browser_notification_web.dart';

Future<void> showBrowserNotification({String? title, String? body}) =>
    showBrowserNotificationImpl(title: title, body: body);
