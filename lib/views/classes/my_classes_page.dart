import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/core/navigation/app_navigator.dart';
import 'package:my_school_teacher/core/state/load_state.dart';
import 'package:my_school_teacher/models/teacher_class_summary.dart';
import 'package:my_school_teacher/controllers/my_classes_controller.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/section_card.dart';
import 'package:my_school_teacher/views/widgets/state_views.dart';
import 'package:my_school_teacher/views/widgets/status_badge.dart';

class MyClassesPage extends StatelessWidget {
  const MyClassesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MyClassesController>().state;
    return ClassesPageScaffold(
      title: context.l10n.myClasses,
      icon: Icons.groups_rounded,
      emptyMessage: context.l10n.noAssignedClasses,
      state: state,
      onRefresh: context.read<MyClassesController>().refresh,
    );
  }
}

class ClassesPageScaffold extends StatelessWidget {
  const ClassesPageScaffold({
    super.key,
    required this.title,
    required this.icon,
    required this.emptyMessage,
    required this.state,
    required this.onRefresh,
  });

  final String title;
  final IconData icon;
  final String emptyMessage;
  final LoadState<List<TeacherClassSummary>> state;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final classes = state.data;
    return Scaffold(
      appBar: BrandAppBar(title: title),
      body: Builder(
        builder: (context) {
          if (classes == null && state.isLoading) {
            return const LoadingView();
          }
          if (classes == null && state.status == LoadStatus.failure) {
            return ErrorView(onRetry: onRefresh);
          }
          if (classes == null || classes.isEmpty) {
            return RefreshableEmptyView(
              icon: icon,
              message: emptyMessage,
              onRefresh: onRefresh,
            );
          }
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                for (final classSummary in classes) ...[
                  _ClassCard(classSummary: classSummary),
                  if (classSummary != classes.last) const SizedBox(height: 12),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ClassCard extends StatelessWidget {
  const _ClassCard({required this.classSummary});

  final TeacherClassSummary classSummary;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => AppNavigator.classDetails(context, classSummary),
        child: Padding(
          padding: EdgeInsets.zero,
          child: Row(
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
                child: Text(
                  classSummary.sectionTitle,
                  style: context.textStyles.titleSmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classSummary.label,
                      style: context.textStyles.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    if (classSummary.courseTitles.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final course in classSummary.courseTitles)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: context.colors.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                course,
                                style: context.textStyles.labelSmall?.copyWith(
                                  color: context.colors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      )
                    else if (classSummary.primaryCourseTitle.isNotEmpty)
                      Text(
                        classSummary.primaryCourseTitle,
                        style: context.textStyles.bodySmall?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      classSummary.yearTitle,
                      style: context.textStyles.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                    if (classSummary.isAssignedToCurrentTeacher) ...[
                      const SizedBox(height: 10),
                      StatusBadge(
                        label: context.l10n.yourAssignment,
                        color: context.colors.primary,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
