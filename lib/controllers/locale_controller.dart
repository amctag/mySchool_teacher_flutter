import 'package:flutter/material.dart';
import 'package:my_school_teacher/controllers/notifier_controller.dart';
import 'package:my_school_teacher/core/persistence/app_preferences.dart';

class LocaleController extends NotifierController<Locale> {
  LocaleController({required AppPreferences preferences})
    : _preferences = preferences,
      super(_supportedLocale(preferences.locale));

  static const supportedLanguageCodes = ['en', 'fr', 'ar'];

  final AppPreferences _preferences;

  static Locale _supportedLocale(Locale locale) {
    return supportedLanguageCodes.contains(locale.languageCode)
        ? Locale(locale.languageCode)
        : const Locale('en');
  }

  Future<void> setLocale(Locale locale) async {
    if (!supportedLanguageCodes.contains(locale.languageCode)) {
      return;
    }
    if (state.languageCode == locale.languageCode) {
      return;
    }
    await _preferences.saveLocale(locale);
    emit(Locale(locale.languageCode));
  }
}
