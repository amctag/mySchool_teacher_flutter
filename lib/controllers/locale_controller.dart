import 'package:flutter/material.dart';
import 'package:my_school_teacher/controllers/notifier_controller.dart';
import 'package:my_school_teacher/core/persistence/app_preferences.dart';

class LocaleController extends NotifierController<Locale> {
  LocaleController({required AppPreferences preferences})
    : _preferences = preferences,
      super(preferences.locale);

  final AppPreferences _preferences;

  Future<void> setLocale(Locale locale) async {
    if (locale.languageCode != 'en' && locale.languageCode != 'ar') {
      return;
    }
    await _preferences.saveLocale(locale);
    emit(locale);
  }
}
