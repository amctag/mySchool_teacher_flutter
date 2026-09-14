import 'package:flutter/material.dart';
import 'package:my_school_teacher/core/widgets/controller_consumer.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/core/navigation/app_navigator.dart';
import 'package:my_school_teacher/core/state/load_state.dart';
import 'package:my_school_teacher/models/teacher_notice.dart';
import 'package:my_school_teacher/controllers/notices_controller.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/section_card.dart';
import 'package:my_school_teacher/views/widgets/state_views.dart';
import 'package:my_school_teacher/views/widgets/status_badge.dart';

class NoticesPage extends StatelessWidget {
  const NoticesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrandAppBar(
        title: context.l10n.notices,
        trailing: HeaderAction(
          tooltip: context.l10n.addNotice,
          icon: Icons.add_rounded,
          onPressed: () async {
            await AppNavigator.noticeEditor(context);
            if (context.mounted) {
              await context.read<NoticesController>().load();
            }
          },
        ),
      ),
      body: ControllerConsumer<NoticesController, LoadState<List<TeacherNotice>>>(
        builder: (context, state) {
          final items = state.data;
          return RefreshIndicator(
            onRefresh: context.read<NoticesController>().refresh,
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
                      onRetry: context.read<NoticesController>().load,
                    ),
                  )
                else if (items == null || items.isEmpty)
                  SizedBox(
                    height: 180,
                    child: EmptyView(
                      icon: Icons.sticky_note_2_rounded,
                      message: context.l10n.noNoticesCreated,
                    ),
                  )
                else
                  for (final notice in items) ...[
                    _NoticeCard(notice: notice),
                    if (notice != items.last) const SizedBox(height: 12),
                  ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.notice});

  final TeacherNotice notice;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () async {
          await AppNavigator.noticeEditor(context, notice: notice);
          if (context.mounted) {
            await context.read<NoticesController>().load();
          }
        },
        child: Padding(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: context.colors.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      notice.targetType == NoticeTargetType.student
                          ? Icons.person_outline_rounded
                          : Icons.groups_2_outlined,
                      color: context.colors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notice.title,
                          style: context.textStyles.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${notice.creator} · ${DateFormat.yMMMd().format(notice.publishDate)}',
                          style: context.textStyles.bodySmall?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusBadge(
                    label: notice.targetType == NoticeTargetType.student
                        ? context.l10n.targetStudent
                        : context.l10n.targetSection,
                    color: notice.targetType == NoticeTargetType.student
                        ? context.colors.primary
                        : context.colors.tertiary,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '${notice.classLabel} · ${notice.targetLabel}',
                style: context.textStyles.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(notice.content, style: context.textStyles.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
