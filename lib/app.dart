import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_school_teacher/controllers/auth_controller.dart';
import 'package:my_school_teacher/controllers/locale_controller.dart';
import 'package:my_school_teacher/controllers/notifications_controller.dart';
import 'package:my_school_teacher/controllers/theme_controller.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/core/navigation/app_navigator.dart';
import 'package:my_school_teacher/core/notifications/app_notification.dart';
import 'package:my_school_teacher/core/notifications/noop_push_notification_service.dart';
import 'package:my_school_teacher/core/notifications/push_notification_service.dart';
import 'package:my_school_teacher/core/persistence/app_preferences.dart';
import 'package:my_school_teacher/core/services/external_link_service.dart';
import 'package:my_school_teacher/core/theme/app_theme.dart';
import 'package:my_school_teacher/l10n/app_localizations.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';
import 'package:my_school_teacher/views/auth/login_page.dart';
import 'package:my_school_teacher/views/home/home_page.dart';
import 'package:provider/provider.dart';

class SchoolTeacherApp extends StatelessWidget {
  const SchoolTeacherApp({
    super.key,
    required this.repository,
    required this.preferences,
    this.pushNotificationService,
    this.externalLinkService = const ExternalLinkService(),
  });

  final TeacherRepository repository;
  final AppPreferences preferences;
  final PushNotificationService? pushNotificationService;
  final ExternalLinkService externalLinkService;

  @override
  Widget build(BuildContext context) {
    final notifications =
        pushNotificationService ?? NoopPushNotificationService();
    return MultiProvider(
      providers: [
        Provider<TeacherRepository>.value(value: repository),
        Provider<AppPreferences>.value(value: preferences),
        Provider<PushNotificationService>.value(value: notifications),
        Provider<ExternalLinkService>.value(value: externalLinkService),
        ChangeNotifierProvider(
          create: (_) =>
              AuthController(repository: repository, preferences: preferences)
                ..restore(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocaleController(preferences: preferences),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeController(preferences: preferences),
        ),
      ],
      child: _AppView(notifications: notifications),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView({required this.notifications});

  final PushNotificationService notifications;

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleController>(
      builder: (context, localeController, _) {
        return Consumer<ThemeController>(
          builder: (context, themeController, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              builder: (context, child) {
                final repository = context.read<TeacherRepository>();
                return Provider<TeacherRepository>.value(
                  value: repository,
                  child: SafeArea(
                    key: const Key('app_bottom_safe_area'),
                    top: false,
                    child: child ?? const SizedBox.shrink(),
                  ),
                );
              },
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context).schoolName,
              locale: localeController.state,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themeController.state,
              home: _NotificationRouter(
                service: notifications,
                child: const _SessionGate(),
              ),
            );
          },
        );
      },
    );
  }
}

class _SessionGate extends StatelessWidget {
  const _SessionGate();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, auth, _) {
        switch (auth.state.status) {
          case AuthStatus.initial:
          case AuthStatus.loading:
            return const _SplashPage();
          case AuthStatus.authenticated:
            return ChangeNotifierProvider(
              create: (context) => NotificationsController(
                repository: context.read<TeacherRepository>(),
                preferences: context.read<AppPreferences>(),
                personId: auth.state.account!.id,
              )..load(force: true),
              child: HomePage(account: auth.state.account!),
            );
          case AuthStatus.unauthenticated:
          case AuthStatus.failure:
            return const LoginPage();
        }
      },
    );
  }
}

class _NotificationRouter extends StatefulWidget {
  const _NotificationRouter({required this.service, required this.child});

  final PushNotificationService service;
  final Widget child;

  @override
  State<_NotificationRouter> createState() => _NotificationRouterState();
}

class _NotificationRouterState extends State<_NotificationRouter> {
  StreamSubscription<AppNotification>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.service.notificationTaps.listen(_handleTap);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final initial = await widget.service.initialNotification();
      if (initial != null) {
        _handleTap(initial);
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _handleTap(AppNotification notification) {
    if (!mounted) {
      return;
    }
    final authState = context.read<AuthController>().state;
    if (authState.status != AuthStatus.authenticated) {
      return;
    }
    AppNavigator.routeFromNotification(context, notification);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _SplashPage extends StatelessWidget {
  const _SplashPage();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.l10n.appName,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colors.onPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 24),
            CircularProgressIndicator(color: colors.onPrimary, strokeWidth: 3),
          ],
        ),
      ),
    );
  }
}
