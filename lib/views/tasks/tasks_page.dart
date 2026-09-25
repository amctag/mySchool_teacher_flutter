import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:my_school_teacher/controllers/tasks_controller.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/core/state/load_state.dart';
import 'package:my_school_teacher/core/widgets/controller_consumer.dart';
import 'package:my_school_teacher/models/teacher_task.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/section_card.dart';
import 'package:my_school_teacher/views/widgets/state_views.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrandAppBar(title: context.l10n.tasks),
      body: ControllerConsumer<TasksController, LoadState<List<TeacherTask>>>(
        builder: (context, state) {
          if (state.data == null &&
              (state.isLoading || state.status == LoadStatus.initial)) {
            return const LoadingView();
          }
          if (state.status == LoadStatus.failure && state.data == null) {
            return ErrorView(
              message: state.message,
              onRetry: () =>
                  context.read<TasksController>().load(force: true),
            );
          }
          if (state.status == LoadStatus.empty) {
            return RefreshableEmptyView(
              key: const Key('tasks_refresh'),
              icon: Icons.task_alt_rounded,
              message: context.l10n.noTasks,
              onRefresh: () =>
                  context.read<TasksController>().load(force: true),
            );
          }
          final items = state.data ?? const <TeacherTask>[];
          final open = items.where((task) => !task.isCompleted).toList();
          final done = items.where((task) => task.isCompleted).toList();
          return RefreshIndicator(
            key: const Key('tasks_refresh'),
            onRefresh: () =>
                context.read<TasksController>().load(force: true),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              children: [
                if (open.isNotEmpty) ...[
                  Text(
                    context.l10n.openTasks,
                    style: context.textStyles.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  ...open.map(
                    (task) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _TaskCard(task: task),
                    ),
                  ),
                ],
                if (done.isNotEmpty) ...[
                  SizedBox(height: open.isEmpty ? 0 : 8),
                  Text(
                    context.l10n.completedTasks,
                    style: context.textStyles.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  ...done.map(
                    (task) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _TaskCard(task: task),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.task});

  final TeacherTask task;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TasksController>();
    final completing = controller.isCompleting(task.id);
    final dateLabel = DateFormat.yMMMd(
      Localizations.localeOf(context).toString(),
    ).add_jm().format(task.createdAt);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: task.isCompleted
                      ? context.colors.secondaryContainer
                      : context.colors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  task.isCompleted
                      ? Icons.check_circle_rounded
                      : Icons.assignment_outlined,
                  color: task.isCompleted
                      ? context.colors.onSecondaryContainer
                      : context.colors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: context.textStyles.titleMedium?.copyWith(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    if (task.description.trim().isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        task.description,
                        style: context.textStyles.bodyMedium?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Text(
                      dateLabel,
                      style: context.textStyles.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!task.isCompleted) ...[
            const SizedBox(height: 14),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton.tonalIcon(
                key: Key('task_done_${task.id}'),
                onPressed: completing
                    ? null
                    : () => controller.markDone(task.id),
                icon: completing
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_rounded, size: 18),
                label: Text(context.l10n.markTaskDone),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
