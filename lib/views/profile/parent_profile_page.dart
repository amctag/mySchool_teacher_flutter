import 'package:flutter/material.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/models/account.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/section_card.dart';

class ParentProfilePage extends StatelessWidget {
  const ParentProfilePage({super.key, required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    final rows = <(IconData, String, String)>[
      (Icons.badge_outlined, context.l10n.profile, account.fullName),
      (Icons.alternate_email_rounded, context.l10n.username, account.username),
      if (account.email != null)
        (Icons.email_outlined, context.l10n.email, account.email!),
      (
        Icons.verified_user_outlined,
        context.l10n.role,
        account.roles.map((role) => _roleLabel(context, role)).join(', '),
      ),
    ];

    return Scaffold(
      appBar: BrandAppBar(title: context.l10n.profileDetails),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 52,
              backgroundColor: context.colors.primaryContainer,
              foregroundColor: context.colors.primary,
              child: Text(
                account.initials,
                style: context.textStyles.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            account.fullName,
            textAlign: TextAlign.center,
            style: context.textStyles.titleLarge,
          ),
          const SizedBox(height: 24),
          SectionCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var index = 0; index < rows.length; index++) ...[
                  ListTile(
                    minTileHeight: 68,
                    leading: Icon(
                      rows[index].$1,
                      color: context.colors.primary,
                    ),
                    title: Text(rows[index].$2),
                    subtitle: Text(rows[index].$3),
                  ),
                  if (index < rows.length - 1) const Divider(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _roleLabel(BuildContext context, String role) =>
    role == 'parent' ? context.l10n.parentRole : role;
