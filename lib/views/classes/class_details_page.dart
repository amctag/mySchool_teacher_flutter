import 'package:flutter/material.dart';
import 'package:my_school_teacher/core/widgets/controller_consumer.dart';
import 'package:provider/provider.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/core/state/load_state.dart';
import 'package:my_school_teacher/models/class_details.dart';
import 'package:my_school_teacher/models/teacher_class_summary.dart';
import 'package:my_school_teacher/controllers/class_details_controller.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/section_card.dart';
import 'package:my_school_teacher/views/widgets/state_views.dart';

class ClassDetailsPage extends StatelessWidget {
  const ClassDetailsPage({super.key, required this.classSummary});

  final TeacherClassSummary classSummary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrandAppBar(title: classSummary.label),
      body: ControllerConsumer<ClassDetailsController, LoadState<ClassDetails>>(
        builder: (context, state) {
          final details = state.data;
          if (details == null && state.isLoading) {
            return const LoadingView();
          }
          if (details == null && state.status == LoadStatus.failure) {
            return ErrorView(
              onRetry: () =>
                  context.read<ClassDetailsController>().load(classSummary.id),
            );
          }
          if (details == null) {
            return RefreshableEmptyView(
              icon: Icons.class_outlined,
              message: context.l10n.noClassDetails,
              onRefresh: () =>
                  context.read<ClassDetailsController>().refresh(classSummary.id),
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                context.read<ClassDetailsController>().refresh(classSummary.id),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                SectionCard(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: context.colors.primaryContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.groups_rounded,
                              color: context.colors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  details.summary.label,
                                  style: context.textStyles.titleSmall,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  details.summary.primaryCourseTitle,
                                  style: context.textStyles.bodySmall
                                      ?.copyWith(
                                        color: context.colors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _InfoChip(
                            label: context.l10n.stage,
                            value: details.summary.stage,
                          ),
                          _InfoChip(
                            label: context.l10n.academicYear,
                            value: details.summary.yearTitle,
                          ),
                          _InfoChip(
                            label: context.l10n.sectionLabel,
                            value: details.summary.sectionTitle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _Title(context.l10n.students),
                const SizedBox(height: 10),
                SectionCard(
                  child: Column(
                    children: [
                      for (
                        var index = 0;
                        index < details.students.length;
                        index++
                      ) ...[
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: context.colors.primaryContainer,
                            foregroundColor: context.colors.primary,
                            child: Text(details.students[index].initials),
                          ),
                          title: Text(details.students[index].fullName),
                          subtitle: Text(
                            '${context.l10n.seatNumberLabel} ${details.students[index].seatNumber}',
                          ),
                        ),
                        if (index < details.students.length - 1)
                          const Divider(),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _Title(context.l10n.weeklySchedule),
                const SizedBox(height: 10),
                for (final day in details.schedule.days) ...[
                  Text(day.dayName, style: context.textStyles.titleSmall),
                  const SizedBox(height: 8),
                  for (final entry in day.entries)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SectionCard(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.courseTitle,
                                    style: context.textStyles.titleSmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(entry.periodLabel),
                                  const SizedBox(height: 4),
                                  Text('${entry.startTime} - ${entry.endTime}'),
                                ],
                              ),
                            ),
                            Text('${context.l10n.room}: ${entry.room}'),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: 16),
                _Title(context.l10n.teachers),
                const SizedBox(height: 10),
                SectionCard(
                  child: Column(
                    children: [
                      for (
                        var index = 0;
                        index < details.roster.length;
                        index++
                      ) ...[
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            details.roster[index].isCurrentTeacher
                                ? Icons.star_rounded
                                : Icons.person_outline_rounded,
                            color: details.roster[index].isCurrentTeacher
                                ? context.colors.primary
                                : context.colors.onSurfaceVariant,
                          ),
                          title: Text(details.roster[index].teacherName),
                          subtitle: Text(details.roster[index].courseTitle),
                          trailing: details.roster[index].isCurrentTeacher
                              ? Text(
                                  context.l10n.yourAssignment,
                                  style: context.textStyles.labelMedium
                                      ?.copyWith(
                                        color: context.colors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                )
                              : null,
                        ),
                        if (index < details.roster.length - 1) const Divider(),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.text);

  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: context.textStyles.titleMedium);
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.colors.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: context.textStyles.labelSmall?.copyWith(
          color: context.colors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
