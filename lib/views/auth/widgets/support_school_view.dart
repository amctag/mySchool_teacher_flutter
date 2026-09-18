import 'package:flutter/material.dart';
import 'package:my_school_teacher/controllers/contact_action_controller.dart';
import 'package:my_school_teacher/controllers/support_schools_controller.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/models/school_info.dart';
import 'package:my_school_teacher/views/widgets/section_card.dart';
import 'package:provider/provider.dart';

class SupportSchoolContent extends StatelessWidget {
  const SupportSchoolContent({
    super.key,
    required this.schools,
    this.compact = false,
  });

  final List<SchoolInfo> schools;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (schools.length == 1) {
      return SupportSchoolView(school: schools.single, compact: compact);
    }
    return DefaultTabController(
      length: schools.length,
      child: Column(
        children: [
          Material(
            color: context.colors.surface,
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: context.colors.primary,
              unselectedLabelColor: context.colors.onSurfaceVariant,
              indicatorColor: context.colors.primary,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                for (final school in schools) Tab(text: school.name),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                for (final school in schools)
                  SupportSchoolView(school: school, compact: compact),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SupportSchoolView extends StatelessWidget {
  const SupportSchoolView({
    super.key,
    required this.school,
    this.compact = false,
    this.enableRefresh = true,
  });

  final SchoolInfo school;
  final bool compact;
  final bool enableRefresh;

  @override
  Widget build(BuildContext context) {
    final actions = context.read<ContactActionController>();
    final content = ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20, compact ? 12 : 18, 20, compact ? 16 : 28),
      children: [
        SupportHeader(schoolInfo: school, compact: compact),
        SizedBox(height: compact ? 14 : 20),
        SupportActionGrid(schoolInfo: school, controller: actions),
        SizedBox(height: compact ? 14 : 20),
        SupportDetailsCard(schoolInfo: school, controller: actions),
      ],
    );
    if (!enableRefresh) {
      return content;
    }
    return RefreshIndicator(
      key: const Key('support_refresh'),
      onRefresh: () => context.read<SupportSchoolsController>().load(),
      child: content,
    );
  }
}

class SupportHeader extends StatelessWidget {
  const SupportHeader({
    super.key,
    required this.schoolInfo,
    this.compact = false,
  });

  final SchoolInfo schoolInfo;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final iconSize = compact ? 56.0 : 76.0;
    return Column(
      children: [
        Container(
          width: iconSize,
          height: iconSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.colors.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.support_agent_rounded,
            size: compact ? 28 : 36,
            color: context.colors.primary,
          ),
        ),
        SizedBox(height: compact ? 8 : 12),
        Text(
          schoolInfo.name,
          textAlign: TextAlign.center,
          style: context.textStyles.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          context.l10n.supportSubtitle,
          textAlign: TextAlign.center,
          style: context.textStyles.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class SupportActionGrid extends StatelessWidget {
  const SupportActionGrid({
    super.key,
    required this.schoolInfo,
    required this.controller,
  });

  final SchoolInfo schoolInfo;
  final ContactActionController controller;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.8,
      children: [
        SupportQuickAction(
          key: const Key('support_call'),
          icon: Icons.call_rounded,
          label: context.l10n.callSchool,
          onTap: () => controller.call(schoolInfo.telephone),
        ),
        SupportQuickAction(
          key: const Key('support_whatsapp'),
          icon: Icons.chat_rounded,
          label: context.l10n.whatsapp,
          onTap: () => controller.whatsapp(schoolInfo.phone),
        ),
        SupportQuickAction(
          key: const Key('support_directions'),
          icon: Icons.directions_rounded,
          label: context.l10n.directions,
          onTap: () => controller.directions(schoolInfo.address),
        ),
        SupportQuickAction(
          key: const Key('support_website'),
          icon: Icons.language_rounded,
          label: context.l10n.visitWebsite,
          onTap: () => controller.website(schoolInfo.website),
        ),
      ],
    );
  }
}

class SupportDetailsCard extends StatelessWidget {
  const SupportDetailsCard({
    super.key,
    required this.schoolInfo,
    required this.controller,
  });

  final SchoolInfo schoolInfo;
  final ContactActionController controller;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          SupportDetailRow(
            icon: Icons.phone_outlined,
            label: context.l10n.telephone,
            contactValue: schoolInfo.telephone,
            onTap: () => controller.call(schoolInfo.telephone),
          ),
          const Divider(height: 1),
          SupportDetailRow(
            icon: Icons.smartphone_outlined,
            label: context.l10n.mobile,
            contactValue: schoolInfo.phone,
            onTap: () => controller.whatsapp(schoolInfo.phone),
          ),
          const Divider(height: 1),
          SupportDetailRow(
            icon: Icons.email_outlined,
            label: context.l10n.email,
            contactValue: schoolInfo.email,
            actionKey: const Key('support_email'),
            onTap: () => controller.email(schoolInfo.email),
          ),
          const Divider(height: 1),
          SupportDetailRow(
            icon: Icons.location_on_outlined,
            label: context.l10n.address,
            contactValue: schoolInfo.address,
            onTap: () => controller.directions(schoolInfo.address),
          ),
          const Divider(height: 1),
          SupportDetailRow(
            icon: Icons.language_rounded,
            label: context.l10n.website,
            contactValue: schoolInfo.website,
            onTap: () => controller.website(schoolInfo.website),
          ),
        ],
      ),
    );
  }
}

class SupportQuickAction extends StatelessWidget {
  const SupportQuickAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      onTap: onTap,
      excludeSemantics: true,
      child: Material(
        color: context.colors.primaryContainer,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          excludeFromSemantics: true,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: context.colors.primary, size: 24),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyles.labelLarge?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SupportDetailRow extends StatelessWidget {
  const SupportDetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.contactValue,
    this.actionKey,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String contactValue;
  final Key? actionKey;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: actionKey,
      minTileHeight: 70,
      leading: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.colors.primaryContainer,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(icon, color: context.colors.primary, size: 21),
      ),
      title: Text(label),
      subtitle: Text(contactValue),
      trailing: onTap == null
          ? null
          : const Icon(Icons.arrow_outward_rounded, size: 19),
      onTap: onTap,
    );
  }
}
