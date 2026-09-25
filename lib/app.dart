import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_school_teacher/controllers/auth_controller.dart';
import 'package:my_school_teacher/controllers/locale_controller.dart';
import 'package:my_school_teacher/controllers/notifications_controller.dart';
import 'package:my_school_teacher/controllers/tasks_controller.dart';
import 'package:my_school_teacher/controllers/theme_controller.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/core/navigation/app_navigator.dart';
import 'package:my_school_teacher/core/navigation/web_route_sync.dart';
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
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context).schoolName,
              locale: localeController.state,
              // The browser path is owned by [WebRouteSync]; without this the
              // Flutter web engine would also try to parse deep links such as
              // `/agenda` into Navigator routes (and fail, since this app uses
              // imperative navigation).
              initialRoute: AppRoutePaths.root,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themeController.state,
              home: _NotificationRouter(
                service: notifications,
                child: const _SessionGate(),
              ),
              builder: (context, child) {
                final repository = context.read<TeacherRepository>();
                return _ResponsiveShell(
                  child: Provider<TeacherRepository>.value(
                    value: repository,
                    child: SafeArea(
                      key: const Key('app_bottom_safe_area'),
                      top: false,
                      child: child ?? const SizedBox.shrink(),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _SessionGate extends StatefulWidget {
  const _SessionGate();

  @override
  State<_SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<_SessionGate> {
  /// Browser path at boot time (`/agenda`, `/login`, `/`, ...). Read once:
  /// later changes come from the user, not from a reload.
  late final String _bootPath = WebRouteSync.path;

  AuthStatus? _lastStatus;
  bool _handledBootPath = false;
  VoidCallback? _stopListeningToBrowser;

  @override
  void initState() {
    super.initState();
    _stopListeningToBrowser = WebRouteSync.listen(_handleBrowserPath);
  }

  @override
  void dispose() {
    _stopListeningToBrowser?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, auth, _) {
        final status = auth.state.status;
        if (status != _lastStatus) {
          _lastStatus = status;
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => _syncUrlForStatus(status),
          );
        }
        switch (status) {
          case AuthStatus.initial:
          case AuthStatus.loading:
            return const _SplashPage();
          case AuthStatus.authenticated:
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => NotificationsController(
                    repository: context.read<TeacherRepository>(),
                    preferences: context.read<AppPreferences>(),
                    personId: auth.state.account!.id,
                  )..load(force: true),
                ),
                ChangeNotifierProvider(
                  create: (context) => TasksController(
                    repository: context.read<TeacherRepository>(),
                  )..load(force: true),
                ),
              ],
              child: HomePage(account: auth.state.account!),
            );
          case AuthStatus.unauthenticated:
          case AuthStatus.failure:
            return const LoginPage();
        }
      },
    );
  }

  /// Keeps the address bar in sync with the session: `/login` when signed out,
  /// `/dashboard` when signed in. On mobile [WebRouteSync] is a no-op.
  Future<void> _syncUrlForStatus(AuthStatus status) async {
    if (!mounted) {
      return;
    }
    switch (status) {
      case AuthStatus.initial:
      case AuthStatus.loading:
        return;
      case AuthStatus.authenticated:
        WebRouteSync.replace(AppRoutePaths.dashboard);
        if (_handledBootPath) {
          return;
        }
        _handledBootPath = true;
        if (AppRoutePaths.isFeature(_bootPath)) {
          await AppNavigator.openFeaturePath(context, _bootPath);
        }
      case AuthStatus.unauthenticated:
      case AuthStatus.failure:
        WebRouteSync.replace(AppRoutePaths.login);
    }
  }

  /// Browser back/forward: the URL is the source of truth, so the navigator is
  /// re-synced to the path the browser is showing.
  void _handleBrowserPath(String path) {
    if (!mounted) {
      return;
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
    final authenticated =
        context.read<AuthController>().state.status == AuthStatus.authenticated;
    if (!authenticated) {
      if (path != AppRoutePaths.login) {
        WebRouteSync.replace(AppRoutePaths.login);
      }
      return;
    }
    if (AppRoutePaths.isFeature(path)) {
      WebRouteSync.withoutUrlPush(
        () => AppNavigator.openFeaturePath(context, path),
      );
    } else if (path != AppRoutePaths.dashboard) {
      WebRouteSync.replace(AppRoutePaths.dashboard);
    }
  }
}

/// Caps the layout width on wide browser windows so the mobile-first design
/// stays readable on desktop. Windows at or below [_maxWidth] (phones,
/// tablets, Android) render exactly as before.
class _ResponsiveShell extends StatelessWidget {
  const _ResponsiveShell({required this.child});

  static const double _maxWidth = 1024;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= _maxWidth) {
          return child;
        }
        return ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Center(
            child: SizedBox(
              width: _maxWidth,
              height: constraints.maxHeight,
              child: child,
            ),
          ),
        );
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
