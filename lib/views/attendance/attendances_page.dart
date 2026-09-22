import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_school_teacher/controllers/attendances_controller.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/core/navigation/app_navigator.dart';
import 'package:my_school_teacher/core/state/load_state.dart';
import 'package:my_school_teacher/core/widgets/controller_consumer.dart';
import 'package:my_school_teacher/models/teacher_attendance.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/section_card.dart';
import 'package:my_school_teacher/views/widgets/state_views.dart';
import 'package:provider/provider.dart';

class AttendancesPage extends StatelessWidget {
  const AttendancesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final canTakeAttendance = context
        .watch<AttendancesController>()
        .options
        .canTakeAttendance;
    return Scaffold(
      appBar: BrandAppBar(
        title: context.l10n.attendance,
        trailing: canTakeAttendance
            ? HeaderAction(
                tooltip: context.l10n.takeAttendance,
                icon: Icons.add_rounded,
                onPressed: () async {
                  final date = context.read<AttendancesController>().selectedDate;
                  await AppNavigator.attendanceEntry(context, date: date);
                  if (!context.mounted) {
                    return;
                  }
                  await context.read<AttendancesController>().refresh();
                },
              )
            : null,
      ),
      body:
          ControllerConsumer<
            AttendancesController,
            LoadState<List<TeacherAttendanceListItem>>
          >(
            builder: (context, state) {
              final controller = context.watch<AttendancesController>();
              final items = state.data;
              return RefreshIndicator(
                onRefresh: controller.refresh,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.pixels >=
                        notification.metrics.maxScrollExtent - 120) {
                      controller.loadMore();
                    }
                    return false;
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    children: [
                      OutlinedButton.icon(
                        key: const Key('attendance_date_button'),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: controller.selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now().add(
                              const Duration(days: 14),
                            ),
                          );
                          if (picked != null) {
                            await controller.selectDate(picked);
                          }
                        },
                        icon: const Icon(Icons.event_rounded),
                        label: Text(
                          DateFormat.yMMMEd().format(controller.selectedDate),
                        ),
                      ),
                      if (!controller.options.canTakeAttendance) ...[
                        const SizedBox(height: 12),
                        Text(
                          context.l10n.attendanceViewOnly,
                          style: context.textStyles.bodySmall?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      if (state.isLoading && items == null)
                        const SizedBox(height: 240, child: LoadingView())
                      else if (state.status == LoadStatus.failure &&
                          items == null)
                        SizedBox(
                          height: 240,
                          child: ErrorView(onRetry: controller.load),
                        )
                      else if (items == null || items.isEmpty)
                        SizedBox(
                          height: 180,
                          child: EmptyView(
                            icon: Icons.event_available_rounded,
                            message: context.l10n.noAttendanceRecords,
                          ),
                        )
                      else ...[
                        for (final item in items) ...[
                          _AttendanceCard(
                            key: ValueKey(item.id),
                            item: item,
                          ),
                          if (item != items.last) const SizedBox(height: 12),
                        ],
                        if (controller.hasMore) ...[
                          const SizedBox(height: 16),
                          if (controller.isLoadingMore)
                            const Center(child: CircularProgressIndicator())
                          else
                            Center(
                              child: TextButton(
                                onPressed: controller.loadMore,
                                child: Text(context.l10n.loadMore),
                              ),
                            ),
                        ],
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  const _AttendanceCard({super.key, required this.item});

  final TeacherAttendanceListItem item;

  @override
  Widget build(BuildContext context) {
    Future<void> openDetails() async {
      await AppNavigator.attendanceEntry(context, item: item);
      if (context.mounted) {
        await context.read<AttendancesController>().refresh();
      }
    }

    return SectionCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: openDetails,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(item.classLabel, style: context.textStyles.titleMedium),
            if (item.courseTitle != null && item.courseTitle!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                item.courseTitle!,
                style: context.textStyles.bodySmall?.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              context.l10n.absentStudentsCount(item.absentCount),
              style: context.textStyles.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  context.l10n.viewDetails,
                  style: context.textStyles.labelSmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: context.colors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
