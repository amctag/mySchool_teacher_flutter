import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_school_teacher/core/notifications/app_notification.dart';
import 'package:my_school_teacher/core/notifications/browser_notification.dart';
import 'package:my_school_teacher/core/notifications/firebase_web_config.dart';
import 'package:my_school_teacher/core/notifications/push_notification_service.dart';

const _channelId = 'high_importance_channel';
const _channelName = 'Messages';

const _details = NotificationDetails(
  android: AndroidNotificationDetails(
    _channelId,
    _channelName,
    channelDescription: 'School notices and updates',
    importance: Importance.high,
    priority: Priority.high,
  ),
  iOS: DarwinNotificationDetails(),
);

@visibleForTesting
bool shouldShowLocalForegroundNotification(
  RemoteMessage message,
  TargetPlatform platform,
) {
  if (platform == TargetPlatform.iOS && message.notification != null) {
    return false;
  }
  return true;
}

String _encode(AppNotification notification) => jsonEncode({
  'title': notification.title,
  'body': notification.body,
  'route': notification.route,
  'data': notification.data,
});

AppNotification? _decode(String? payload) {
  if (payload == null) {
    return null;
  }
  try {
    final map = jsonDecode(payload) as Map<String, dynamic>;
    return AppNotification(
      title: map['title'] as String?,
      body: map['body'] as String?,
      route: map['route'] as String?,
      data: Map<String, dynamic>.from(map['data'] as Map? ?? const {}),
    );
  } on FormatException {
    return null;
  }
}

/// Runs in a background isolate when an Android data message arrives while the
/// app is not in the foreground. Notification-bearing messages are displayed by
/// the OS automatically; data-only messages are shown here.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final notification = message.notification;
  if (notification == null ||
      (notification.title == null && notification.body == null)) {
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    await plugin.show(
      id: message.hashCode,
      title: message.data['title'] as String?,
      body: message.data['body'] as String?,
      notificationDetails: _details,
      payload: jsonEncode({
        'title': message.data['title'],
        'body': message.data['body'],
        'route': message.data['route'],
        'data': message.data,
      }),
    );
  }
}

/// FCM-backed [PushNotificationService]. Owns the Firebase lifecycle and maps
/// RemoteMessages into [AppNotification] taps.
class FcmPushNotificationService implements PushNotificationService {
  FcmPushNotificationService({
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localNotifications,
  }) : _messaging = messaging,
       _localNotifications =
           localNotifications ?? FlutterLocalNotificationsPlugin();

  /// Resolved lazily so construction never touches Firebase before
  /// [Firebase.initializeApp] runs in [init].
  FirebaseMessaging? _messaging;
  FirebaseMessaging get _messagingInstance =>
      _messaging ??= FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final _taps = StreamController<AppNotification>.broadcast();

  String? _tokenCache;

  AppNotification? _launchedByNotification;
  bool _initialized = false;

  @override
  Future<void> init() async {
    if (_initialized) {
      return;
    }
    _initialized = true;
    await Firebase.initializeApp(
      options: kIsWeb ? TeacherFirebaseWeb.options : null,
    );

    if (!kIsWeb) {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    }

    if (!kIsWeb) {
      const settings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      );
      await _localNotifications.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: (response) {
          final notification = _decode(response.payload);
          if (notification != null) {
            _taps.add(notification);
          }
        },
      );
      await requestPermission();
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _messagingInstance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    _messagingInstance.onTokenRefresh.listen((token) => _tokenCache = token);

    if (!kIsWeb) {
      await _warmUpToken();
    }

    FirebaseMessaging.onMessage.listen((message) {
      final notification = _fromRemoteMessage(message);
      if (kIsWeb) {
        showBrowserNotification(
          title: notification.title,
          body: notification.body,
        );
        return;
      }
      if (!shouldShowLocalForegroundNotification(
        message,
        defaultTargetPlatform,
      )) {
        return;
      }
      _showForegroundNotification(notification);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _taps.add(_fromRemoteMessage(message));
    });

    final initialMessage = await _messagingInstance.getInitialMessage();
    if (initialMessage != null) {
      _launchedByNotification = _fromRemoteMessage(initialMessage);
    }
  }

  Future<void> _warmUpToken() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        var apnsToken = await _messagingInstance.getAPNSToken();
        if (apnsToken == null) {
          await Future<void>.delayed(const Duration(seconds: 2));
          apnsToken = await _messagingInstance.getAPNSToken();
          if (apnsToken == null) {
            return;
          }
        }
      }
      _tokenCache = await _readToken();
    } on Object {
      // Token not ready yet; getToken() will retry on demand
    }
  }

  @override
  Future<bool> requestPermission() async {
    final settings = await _messagingInstance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    final status = settings.authorizationStatus;
    return status == AuthorizationStatus.authorized ||
        status == AuthorizationStatus.provisional;
  }

  @override
  Future<String?> getToken({bool prompt = true}) async {
    final cached = _tokenCache;
    if (cached != null) {
      return cached;
    }
    try {
      if (kIsWeb) {
        if (TeacherFirebaseWeb.vapidKey.isEmpty) {
          throw StateError(TeacherFirebaseWeb.vapidConfigError);
        }
        final supported = await FirebaseMessaging.instance.isSupported();
        if (!supported) {
          if (defaultTargetPlatform == TargetPlatform.iOS) {
            throw StateError(
              'On iPhone, Chrome cannot receive web push in a normal tab. '
              'Open this site in Safari → Share → Add to Home Screen, '
              'then open MS Teacher from the home icon and tap Allow notifications.',
            );
          }
          throw StateError(
            'This mobile browser does not support web push. '
            'On Android use Chrome. On iPhone use Safari and Add to Home Screen.',
          );
        }
      }
      // APNs is native iOS only. On iPhone Safari/PWA web, this must be skipped
      // or getToken() always returns null and the UI shows a false "blocked" error.
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
        final apns = await _messagingInstance.getAPNSToken();
        if (apns == null) {
          return null;
        }
      }
      if (kIsWeb) {
        if (prompt) {
          final allowed = await requestPermission();
          if (!allowed) {
            if (defaultTargetPlatform == TargetPlatform.iOS) {
              throw StateError(
                'Notifications are off for this app. On iPhone: Settings → '
                'Notifications → MS Teacher → allow Notifications, then open '
                'the home-screen app again and tap Allow notifications.',
              );
            }
            throw StateError(
              'Notifications are blocked for this site.\n'
              'Desktop: click the lock icon in the address bar → Site settings → '
              'Notifications → Allow, then reload and try again.\n'
              'Android Chrome: tap the lock icon → Permissions → Notifications → Allow.\n'
              'Or open chrome://settings/content/notifications and remove this site from Blocked.',
            );
          }
        } else {
          final settings = await _messagingInstance.getNotificationSettings();
          final status = settings.authorizationStatus;
          if (status != AuthorizationStatus.authorized &&
              status != AuthorizationStatus.provisional) {
            return null;
          }
        }
      }
      final token = await _readToken();
      _tokenCache = token;
      return token;
    } on Object catch (error) {
      debugPrint('FCM getToken failed: $error');
      if (kIsWeb && prompt) {
        rethrow;
      }
      return null;
    }
  }

  @override
  Stream<AppNotification> get notificationTaps => _taps.stream;

  @override
  Future<AppNotification?> initialNotification() async =>
      _launchedByNotification;

  Future<String?> _readToken() {
    return _messagingInstance
        .getToken(
          vapidKey: kIsWeb && TeacherFirebaseWeb.vapidKey.isNotEmpty
              ? TeacherFirebaseWeb.vapidKey
              : null,
          serviceWorkerScriptPath: kIsWeb
              ? '/firebase-messaging-sw.js'
              : null,
        )
        .timeout(const Duration(seconds: 15));
  }

  AppNotification _fromRemoteMessage(RemoteMessage message) {
    final data = Map<String, dynamic>.from(message.data);
    return AppNotification(
      title: message.notification?.title ?? data['title'] as String?,
      body: message.notification?.body ?? data['body'] as String?,
      route: (data['route'] ?? data['type']) as String?,
      data: data,
    );
  }

  Future<void> _showForegroundNotification(AppNotification notification) async {
    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: _details,
      payload: _encode(notification),
    );
  }
}
