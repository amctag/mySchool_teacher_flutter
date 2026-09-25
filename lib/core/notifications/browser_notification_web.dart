import 'package:web/web.dart' as web;

Future<void> showBrowserNotificationImpl({String? title, String? body}) async {
  if (web.Notification.permission != 'granted') {
    return;
  }
  web.Notification(
    title ?? 'MS Teacher',
    web.NotificationOptions(body: body ?? ''),
  );
}
