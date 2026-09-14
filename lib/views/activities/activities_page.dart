import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_school_teacher/core/widgets/controller_consumer.dart';
import 'package:provider/provider.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/core/navigation/app_navigator.dart';
import 'package:my_school_teacher/core/state/load_state.dart';
import 'package:my_school_teacher/models/teacher_media.dart';
import 'package:my_school_teacher/controllers/media_controllers.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/section_card.dart';
import 'package:my_school_teacher/views/widgets/state_views.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrandAppBar(title: context.l10n.activities),
      body: ControllerConsumer<
        ActivitiesController,
        LoadState<List<TeacherActivity>>
      >(
        builder: (context, state) {
          final items = state.data;
          return RefreshIndicator(
            onRefresh: context.read<ActivitiesController>().refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                if (items == null && state.isLoading)
                  const SizedBox(height: 240, child: LoadingView())
                else if (items == null && state.status == LoadStatus.failure)
                  SizedBox(
                    height: 240,
                    child: ErrorView(
                      onRetry: context.read<ActivitiesController>().load,
                    ),
                  )
                else if (items == null || items.isEmpty)
                  SizedBox(
                    height: 180,
                    child: EmptyView(
                      icon: Icons.celebration_outlined,
                      message: context.l10n.noActivities,
                    ),
                  )
                else
                  for (final activity in items) ...[
                    _ActivityCard(activity: activity),
                    if (activity != items.last) const SizedBox(height: 12),
                  ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.activity});

  final TeacherActivity activity;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => AppNavigator.activityDetails(context, activity),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    activity.title,
                    style: context.textStyles.titleMedium,
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: context.colors.onSurfaceVariant,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              activity.scopeLabel,
              style: context.textStyles.bodySmall?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              activity.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat.yMMMd().format(activity.date),
              style: context.textStyles.labelSmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityDetailsPage extends StatelessWidget {
  const ActivityDetailsPage({super.key, required this.activity});

  final TeacherActivity activity;

  @override
  Widget build(BuildContext context) {
    final image = activity.image.trim();
    final hasImage =
        image.startsWith('http://') || image.startsWith('https://');
    return Scaffold(
      appBar: BrandAppBar(title: context.l10n.activityDetails),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.title, style: context.textStyles.titleLarge),
                const SizedBox(height: 8),
                Text(
                  activity.scopeLabel,
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat.yMMMd().format(activity.date),
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                if (hasImage) ...[
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(image, fit: BoxFit.cover),
                  ),
                ],
                const SizedBox(height: 16),
                Text(activity.content, style: context.textStyles.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
