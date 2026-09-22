import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:my_school_teacher/controllers/notifications_controller.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/core/state/load_state.dart';
import 'package:my_school_teacher/core/widgets/controller_consumer.dart';
import 'package:my_school_teacher/models/teacher_push_notification.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/section_card.dart';
import 'package:my_school_teacher/views/widgets/state_views.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrandAppBar(title: context.l10n.notifications),
      body:
          ControllerConsumer<
            NotificationsController,
            LoadState<List<TeacherPushNotification>>
          >(
            builder: (context, state) {
              if (state.data == null &&
                  (state.isLoading || state.status == LoadStatus.initial)) {
                return const LoadingView();
              }
              if (state.status == LoadStatus.failure && state.data == null) {
                return ErrorView(
                  message: state.message,
                  onRetry: () => context
                      .read<NotificationsController>()
                      .load(force: true, markAsSeen: true),
                );
              }
              if (state.status == LoadStatus.empty) {
                return RefreshableEmptyView(
                  key: const Key('notifications_refresh'),
                  icon: Icons.notifications_none_rounded,
                  message: context.l10n.noNotifications,
                  onRefresh: () => context
                      .read<NotificationsController>()
                      .load(force: true, markAsSeen: true),
                );
              }
              final items = state.data ?? const <TeacherPushNotification>[];
              return RefreshIndicator(
                key: const Key('notifications_refresh'),
                onRefresh: () => context
                    .read<NotificationsController>()
                    .load(force: true, markAsSeen: true),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _NotificationCard(item: item);
                  },
                ),
              );
            },
          ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item});

  final TeacherPushNotification item;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: context.colors.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.notifications_rounded,
              color: context.colors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: context.textStyles.titleMedium),
                if (item.body.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.body,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyles.bodyMedium,
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  DateFormat.yMMMd(
                    Localizations.localeOf(context).toString(),
                  ).add_jm().format(item.createdAt),
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
