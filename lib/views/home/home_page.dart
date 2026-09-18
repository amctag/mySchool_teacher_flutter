import 'package:flutter/material.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/core/navigation/app_navigator.dart';
import 'package:my_school_teacher/models/account.dart';
import 'package:my_school_teacher/views/widgets/feature_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    final destinations = [
      _HomeTile(
        context.l10n.agenda,
        Icons.edit_note_rounded,
        AppNavigator.agenda,
      ),
      _HomeTile(
        context.l10n.grades,
        Icons.grade_rounded,
        AppNavigator.grades,
      ),
      _HomeTile(
        context.l10n.attendance,
        Icons.event_available_rounded,
        AppNavigator.attendances,
      ),
      _HomeTile(
        context.l10n.notices,
        Icons.sticky_note_2_rounded,
        AppNavigator.notices,
      ),
      _HomeTile(
        context.l10n.announcements,
        Icons.campaign_outlined,
        AppNavigator.announcements,
      ),
      _HomeTile(
        context.l10n.myClasses,
        Icons.groups_rounded,
        AppNavigator.myClasses,
      ),
      _HomeTile(
        context.l10n.mySchedule,
        Icons.calendar_view_week_rounded,
        AppNavigator.schedule,
      ),
      _HomeTile(
        context.l10n.activities,
        Icons.celebration_outlined,
        AppNavigator.activities,
      ),
      _HomeTile(
        context.l10n.albums,
        Icons.photo_library_outlined,
        AppNavigator.albums,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsetsDirectional.only(start: 12),
          child: IconButton(
            tooltip: context.l10n.profile,
            onPressed: () => AppNavigator.profile(context),
            icon: CircleAvatar(
              radius: 17,
              backgroundColor: context.colors.onPrimary.withValues(alpha: 0.16),
              foregroundColor: context.colors.onPrimary,
              child: Text(
                account.initials,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
        title: Text(context.l10n.appName),
      ),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greeting(context),
                      style: context.textStyles.bodyMedium?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      account.fullName,
                      style: context.textStyles.titleLarge,
                    ),
                    if (account.title != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        account.title!,
                        style: context.textStyles.bodyMedium?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    Text(
                      context.l10n.teacherHomeSubtitle,
                      style: context.textStyles.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  mainAxisExtent: 128,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final destination = destinations[index];
                  return FeatureTile(
                    label: destination.label,
                    icon: destination.icon,
                    onTap: () => destination.open(context),
                  );
                }, childCount: destinations.length),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _greeting(BuildContext context) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return context.l10n.goodMorning;
    }
    if (hour < 18) {
      return context.l10n.goodAfternoon;
    }
    return context.l10n.goodEvening;
  }
}

class _HomeTile {
  const _HomeTile(this.label, this.icon, this.open);

  final String label;
  final IconData icon;
  final Future<void> Function(BuildContext context) open;
}
