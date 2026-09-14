import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_school_teacher/app.dart';
import 'package:my_school_teacher/core/notifications/fcm_push_notification_service.dart';
import 'package:my_school_teacher/core/notifications/noop_push_notification_service.dart';
import 'package:my_school_teacher/core/notifications/push_notification_service.dart';
import 'package:my_school_teacher/core/persistence/app_preferences.dart';
import 'package:my_school_teacher/services/datasources/api_teacher_data_source.dart';
import 'package:my_school_teacher/services/network/teacher_api_client.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  final preferences = AppPreferences(await SharedPreferences.getInstance());
  final repository = TeacherRepository(
    dataSource: ApiTeacherDataSource(
      api: TeacherApiClient(preferences: preferences),
    ),
  );
  // Web has no google-services / FirebaseOptions; FCM stays mobile-only.
  final PushNotificationService pushNotificationService = kIsWeb
      ? NoopPushNotificationService()
      : FcmPushNotificationService();
  try {
    await pushNotificationService.init();
  } on Object {
    // Firebase not configured for this build environment; notifications
    // degrade gracefully to no-ops. AssertionError on web is an Error,
    // not an Exception — catch Object so Chrome can still boot.
  }
  runApp(
    SchoolTeacherApp(
      repository: repository,
      preferences: preferences,
      pushNotificationService: pushNotificationService,
    ),
  );
}
