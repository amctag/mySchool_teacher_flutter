import 'package:flutter/material.dart';
import 'package:my_school_teacher/controllers/notifier_controller.dart';
import 'package:my_school_teacher/core/persistence/app_preferences.dart';

class ThemeController extends NotifierController<ThemeMode> {
  ThemeController({required AppPreferences preferences})
    : _preferences = preferences,
      super(preferences.themeMode);

  final AppPreferences _preferences;

  Future<void> setThemeMode(ThemeMode mode) async {
    await _preferences.saveThemeMode(mode);
    emit(mode);
  }
}
