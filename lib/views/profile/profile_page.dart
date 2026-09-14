import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/core/navigation/app_navigator.dart';
import 'package:my_school_teacher/models/account.dart';
import 'package:my_school_teacher/controllers/auth_controller.dart';
import 'package:my_school_teacher/controllers/locale_controller.dart';
import 'package:my_school_teacher/controllers/theme_controller.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/section_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AuthController>().state.account!;
    final locale = context.watch<LocaleController>().state;
    final theme = context.watch<ThemeController>().state;

    return Scaffold(
      appBar: BrandAppBar(title: context.l10n.profile),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _ProfileHeader(account: account),
          const SizedBox(height: 24),
          _SectionTitle(title: context.l10n.account),
          const SizedBox(height: 10),
          SectionCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _ProfileRow(
                  rowKey: const Key('profile_details'),
                  icon: Icons.person_outline_rounded,
                  title: context.l10n.profile,
                  subtitle: account.username,
                  onTap: () => AppNavigator.teacherProfile(context, account),
                ),
                const Divider(),
                _ProfileRow(
                  rowKey: const Key('profile_change_password'),
                  icon: Icons.password_rounded,
                  title: context.l10n.changePassword,
                  onTap: () => AppNavigator.changePassword(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _SectionTitle(title: context.l10n.appearance),
          const SizedBox(height: 10),
          SectionCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _ProfileRow(
                  icon: Icons.translate_rounded,
                  title: context.l10n.language,
                  subtitle: locale.languageCode == 'ar'
                      ? context.l10n.arabic
                      : context.l10n.english,
                  onTap: () => AppNavigator.language(context),
                ),
                const Divider(),
                _ProfileRow(
                  icon: Icons.brightness_6_outlined,
                  title: context.l10n.theme,
                  subtitle: _themeLabel(context, theme),
                  trailing: const Icon(Icons.expand_more_rounded),
                  onTap: () => _showThemeSheet(context, theme),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _SectionTitle(title: context.l10n.application),
          const SizedBox(height: 10),
          SectionCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _ProfileRow(
                  icon: Icons.info_outline_rounded,
                  title: context.l10n.version,
                ),
                const Divider(),
                _ProfileRow(
                  icon: Icons.logout_rounded,
                  title: context.l10n.logout,
                  foregroundColor: context.colors.error,
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

  String _themeLabel(BuildContext context, ThemeMode mode) => switch (mode) {
    ThemeMode.system => context.l10n.systemTheme,
    ThemeMode.light => context.l10n.lightTheme,
    ThemeMode.dark => context.l10n.darkTheme,
  };

  Future<void> _showThemeSheet(BuildContext context, ThemeMode selected) {
    return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
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

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: context.colors.primaryContainer,
            foregroundColor: context.colors.primary,
            child: Text(
              account.initials,
              style: context.textStyles.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(account.fullName, style: context.textStyles.titleMedium),
                const SizedBox(height: 3),
                Text(
                  account.title ?? account.username,
                  style: context.textStyles.bodyMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                if (account.email != null)
                  Text(
                    account.email!,
                    style: context.textStyles.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) =>
      Text(title, style: context.textStyles.titleMedium);
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.title,
    this.rowKey,
    this.subtitle,
    this.trailing,
    this.foregroundColor,
    this.onTap,
  });

  final Key? rowKey;
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Color? foregroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = foregroundColor ?? context.colors.primary;
    return ListTile(
      key: rowKey,
      minTileHeight: 64,
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: foregroundColor == null
            ? null
            : TextStyle(color: foregroundColor),
      ),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing:
          trailing ??
          (onTap == null ? null : const Icon(Icons.chevron_right_rounded)),
      onTap: onTap,
    );
  }
}
