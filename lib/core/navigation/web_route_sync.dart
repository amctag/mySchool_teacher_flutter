import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

/// Canonical browser paths used by the Flutter Web build.
///
/// Android/iOS never read or write these paths — on those platforms
/// [WebRouteSync] is a no-op, so mobile navigation stays exactly as it was.
abstract final class AppRoutePaths {
  static const String root = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';

  static const String profile = '/profile';
  static const String schedule = '/schedule';
  static const String agenda = '/agenda';
  static const String grades = '/grades';
  static const String attendance = '/attendance';
  static const String notices = '/notices';
  static const String announcements = '/announcements';
  static const String tasks = '/tasks';
  static const String activities = '/activities';
  static const String albums = '/albums';
  static const String classes = '/classes';
  static const String classSchedules = '/class-schedules';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String language = '/language';

  /// Top level pages that can be opened directly from a browser URL.
  ///
  /// Editors and detail pages intentionally stay out of this set: they keep the
  /// URL of the feature they belong to.
  static const Set<String> features = {
    profile,
    schedule,
    agenda,
    grades,
    attendance,
    notices,
    announcements,
    tasks,
    activities,
    albums,
    classes,
    classSchedules,
    notifications,
    settings,
    language,
  };

  /// Removes query/hash/trailing slash noise so `/agenda/` and `/agenda?x=1`
  /// both resolve to `/agenda`.
  static String normalize(String? rawPath) {
    var path = rawPath ?? root;
    path = path.split('#').first.split('?').first;
    if (path.isEmpty) {
      return root;
    }
    if (!path.startsWith('/')) {
      path = '/$path';
    }
    while (path.length > 1 && path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    return path;
  }

  static bool isFeature(String? path) => features.contains(normalize(path));
}

/// Bridge between the browser URL/history and the app's [Navigator] stack.
///
/// Uses the active Flutter [UrlStrategy]:
/// * `null` (non-web platforms) → every call is a no-op.
/// * [PathUrlStrategy] (web) → clean URLs such as `/dashboard` instead of
///   `/#/dashboard`.
///
/// The URL is the source of truth for top level navigation: a browser
/// back/forward event re-syncs the navigator stack with the requested path.
abstract final class WebRouteSync {
  static UrlStrategy? get _strategy => urlStrategy;

  /// `true` when the app is running inside a browser.
  static bool get isWeb => _strategy != null;

  /// Normalised path currently shown in the browser address bar.
  static String get path =>
      AppRoutePaths.normalize(_strategy?.getPath() ?? AppRoutePaths.root);

  /// Replaces the current history entry (used for login/dashboard state).
  static void replace(String path) => _strategy?.replaceState(null, '', path);

  /// Adds a history entry (used when a feature page is opened).
  static void push(String path) => _strategy?.pushState(null, '', path);

  /// [push] that can be silenced while the navigator is already being
  /// re-synced from a popstate event.
  static bool _silent = false;

  static void pushUnlessSilent(String path) {
    if (_silent) {
      return;
    }
    push(path);
  }

  /// Runs [body] without touching browser history.
  static T withoutUrlPush<T>(T Function() body) {
    final previous = _silent;
    _silent = true;
    try {
      return body();
    } finally {
      _silent = previous;
    }
  }

  /// Subscribes to browser back/forward events and returns the unsubscribe
  /// callback. Never fires on mobile.
  static VoidCallback listen(void Function(String path) onPath) {
    final strategy = _strategy;
    if (strategy == null) {
      return () {};
    }
    void handler(Object? _) => onPath(AppRoutePaths.normalize(strategy.getPath()));
    return strategy.addPopStateListener(handler);
  }
}
