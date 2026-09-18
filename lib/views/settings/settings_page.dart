import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/core/navigation/app_navigator.dart';
import 'package:my_school_teacher/controllers/auth_controller.dart';
import 'package:my_school_teacher/controllers/locale_controller.dart';
import 'package:my_school_teacher/controllers/theme_controller.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/section_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>().state;
    final locale = context.watch<LocaleController>().state;
    final theme = context.watch<ThemeController>().state;
    return Scaffold(
      appBar: BrandAppBar(title: context.l10n.settings),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(context.l10n.account, style: context.textStyles.titleMedium),
          const SizedBox(height: 10),
          SectionCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: context.colors.primaryContainer,
                foregroundColor: context.colors.primary,
                child: const Icon(Icons.person_rounded),
              ),
              title: Text(auth.account?.fullName ?? ''),
              subtitle: Text(auth.account?.username ?? ''),
            ),
          ),
          const SizedBox(height: 24),
          Text(context.l10n.appearance, style: context.textStyles.titleMedium),
          const SizedBox(height: 10),
          SectionCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  minTileHeight: 64,
                  leading: const Icon(Icons.translate_rounded),
                  title: Text(context.l10n.language),
                  subtitle: Text(_languageLabel(context, locale)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => AppNavigator.language(context),
                ),
                const Divider(),
                ListTile(
                  minTileHeight: 64,
                  leading: const Icon(Icons.brightness_6_outlined),
                  title: Text(context.l10n.theme),
                  subtitle: Text(_themeLabel(context, theme)),
                  trailing: const Icon(Icons.expand_more_rounded),
                  onTap: () => _showThemeSheet(context, theme),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(context.l10n.application, style: context.textStyles.titleMedium),
          const SizedBox(height: 10),
          SectionCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  minTileHeight: 64,
                  leading: const Icon(Icons.info_outline_rounded),
                  title: Text(context.l10n.version),
                ),
                const Divider(),
                ListTile(
                  minTileHeight: 64,
                  leading: Icon(
                    Icons.logout_rounded,
                    color: context.colors.error,
                  ),
                  title: Text(
                    context.l10n.logout,
                    style: TextStyle(color: context.colors.error),
                  ),
                  onTap: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    context.read<AuthController>().logout();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _languageLabel(BuildContext context, Locale locale) =>
      switch (locale.languageCode) {
        'ar' => context.l10n.arabic,
        'fr' => context.l10n.french,
        _ => context.l10n.english,
      };

  String _themeLabel(BuildContext context, ThemeMode mode) => switch (mode) {
    ThemeMode.system => context.l10n.systemTheme,
    ThemeMode.light => context.l10n.lightTheme,
    ThemeMode.dark => context.l10n.darkTheme,
  };

  Future<void> _showThemeSheet(BuildContext context, ThemeMode selected) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: RadioGroup<ThemeMode>(
          groupValue: selected,
          onChanged: (mode) {
            if (mode != null) {
              context.read<ThemeController>().setThemeMode(mode);
              Navigator.pop(sheetContext);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                value: ThemeMode.system,
                title: Text(context.l10n.systemTheme),
              ),
              RadioListTile(
                value: ThemeMode.light,
                title: Text(context.l10n.lightTheme),
              ),
              RadioListTile(
                value: ThemeMode.dark,
                title: Text(context.l10n.darkTheme),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
