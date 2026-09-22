import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  const AppPreferences(this._preferences);

  static const _localeKey = 'locale';
  static const _themeModeKey = 'theme_mode';
  static const _sessionKey = 'has_session';
  static const _selectedChildKey = 'selected_child_id';
  static const _allChildrenSelectedKey = 'all_children_selected';
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _accessTokenExpiresKey = 'access_token_expires_at';
  static const _refreshTokenExpiresKey = 'refresh_token_expires_at';
  static const _notificationsLastSeenPrefix = 'notifications_last_seen_id_';

  final SharedPreferences _preferences;

  int lastSeenNotificationId(int personId) =>
      _preferences.getInt('$_notificationsLastSeenPrefix$personId') ?? 0;

  Future<void> saveLastSeenNotificationId(int personId, int notificationId) =>
      _preferences.setInt(
        '$_notificationsLastSeenPrefix$personId',
        notificationId,
      );

  bool get hasSession => _preferences.getBool(_sessionKey) ?? false;

  String? get accessToken => _preferences.getString(_accessTokenKey);

  String? get refreshToken => _preferences.getString(_refreshTokenKey);

  int? get selectedChildId => _preferences.getInt(_selectedChildKey);

  bool get allChildrenSelected =>
      _preferences.getBool(_allChildrenSelectedKey) ?? false;

  Locale get locale => Locale(_preferences.getString(_localeKey) ?? 'en');

  ThemeMode get themeMode {
    final value = _preferences.getString(_themeModeKey);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> saveSession(bool value) async {
    await _preferences.setBool(_sessionKey, value);
    if (!value) {
      await clearTokens();
    }
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    String? accessTokenExpiresAt,
    String? refreshTokenExpiresAt,
  }) async {
    await Future.wait([
      _preferences.setBool(_sessionKey, true),
      _preferences.setString(_accessTokenKey, accessToken),
      _preferences.setString(_refreshTokenKey, refreshToken),
      if (accessTokenExpiresAt != null)
        _preferences.setString(_accessTokenExpiresKey, accessTokenExpiresAt)
      else
        _preferences.remove(_accessTokenExpiresKey),
      if (refreshTokenExpiresAt != null)
        _preferences.setString(_refreshTokenExpiresKey, refreshTokenExpiresAt)
      else
        _preferences.remove(_refreshTokenExpiresKey),
    ]);
  }

  Future<void> clearTokens() async {
    await Future.wait([
      _preferences.remove(_accessTokenKey),
      _preferences.remove(_refreshTokenKey),
      _preferences.remove(_accessTokenExpiresKey),
      _preferences.remove(_refreshTokenExpiresKey),
    ]);
  }

  Future<void> clearSession() async {
    await Future.wait([
      _preferences.setBool(_sessionKey, false),
      clearTokens(),
    ]);
  }

  Future<void> saveSelectedChildId(int? value) async {
    if (value == null) {
      await _preferences.remove(_selectedChildKey);
      return;
    }
    await _preferences.setInt(_selectedChildKey, value);
  }

  Future<void> saveAllChildrenSelected(bool value) async {
    await _preferences.setBool(_allChildrenSelectedKey, value);
  }

  Future<void> clearChildSelection() async {
    await Future.wait([
      _preferences.remove(_selectedChildKey),
      _preferences.setBool(_allChildrenSelectedKey, false),
    ]);
  }

  Future<void> saveLocale(Locale value) async {
    await _preferences.setString(_localeKey, value.languageCode);
  }

  Future<void> saveThemeMode(ThemeMode value) async {
    await _preferences.setString(_themeModeKey, value.name);
  }
}
