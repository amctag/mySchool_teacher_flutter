import 'package:flutter/material.dart';
import 'package:my_school_teacher/core/widgets/controller_consumer.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/core/navigation/app_navigator.dart';
import 'package:my_school_teacher/core/state/load_state.dart';
import 'package:my_school_teacher/models/grade_assessment.dart';
import 'package:my_school_teacher/controllers/grades_controller.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/section_card.dart';
import 'package:my_school_teacher/views/widgets/state_views.dart';
import 'package:my_school_teacher/views/widgets/app_select_field.dart';

class GradesPage extends StatefulWidget {
  const GradesPage({super.key});

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openFilterDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void _closeFilterDrawer() {
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final filterDrawer = _GradesFilterDrawer(
      onApply: () async {
        await context.read<GradesController>().applyFilters();
        if (context.mounted) {
          _closeFilterDrawer();
        }
      },
    );
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: filterDrawer,
      appBar: BrandAppBar(
        title: context.l10n.grades,
        trailing: HeaderAction(
          tooltip: context.l10n.addGrades,
          icon: Icons.add_rounded,
          onPressed: () async {
            await AppNavigator.gradeEntry(context);
            if (!context.mounted) {
              return;
            }
            await context.read<GradesController>().refresh();
          },
        ),
      ),
      body:
          ControllerConsumer<
            GradesController,
            LoadState<List<GradeAssessmentSummary>>
          >(
            builder: (context, state) {
              final controller = context.watch<GradesController>();
              final assessments = state.data;
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
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: OutlinedButton.icon(
                          key: const Key('grades_filter_button'),
                          onPressed: controller.options.classes.isEmpty
                              ? null
                              : _openFilterDrawer,
                          icon: const Icon(Icons.filter_list_rounded),
                          label: Text(context.l10n.filters),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (state.isLoading && assessments == null)
                        const SizedBox(height: 240, child: LoadingView())
                      else if (state.status == LoadStatus.failure &&
                          assessments == null)
                        SizedBox(
                          height: 240,
                          child: ErrorView(onRetry: controller.load),
                        )
                      else if (assessments == null || assessments.isEmpty)
                        SizedBox(
                          height: 180,
                          child: EmptyView(
                            icon: Icons.grade_rounded,
                            message: context.l10n.noMatchingGrades,
                          ),
                        )
                      else ...[
                        for (final assessment in assessments) ...[
                          _GradeCard(
                            key: ValueKey(assessment.id),
                            assessment: assessment,
                          ),
                          if (assessment != assessments.last)
                            const SizedBox(height: 12),
                        ],
                        if (controller.hasMore) ...[
                          const SizedBox(height: 16),
                          Center(
                            child: controller.isLoadingMore
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : TextButton(
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

class _GradesFilterDrawer extends StatelessWidget {
  const _GradesFilterDrawer({required this.onApply});

  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GradesController>();
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.l10n.filters,
                      style: context.textStyles.titleLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: context.l10n.close,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppSelectField<int?>(
                key: const Key('grades-filter-class'),
                label: context.l10n.selectClass,
                value: controller.selectedClassId,
                options: [
                  AppSelectOption(
                    value: null,
                    label: context.l10n.allClasses,
                  ),
                  for (final item in controller.options.classes)
                    AppSelectOption(value: item.id, label: item.name),
                ],
                onChanged: controller.selectClass,
              ),
              const SizedBox(height: 12),
              AppSelectField<int?>(
                key: const Key('grades-filter-section'),
                label: context.l10n.selectSection,
                value: controller.selectedSectionId,
                enabled: controller.selectedClassId != null,
                options: [
                  AppSelectOption(
                    value: null,
                    label: context.l10n.allSections,
                  ),
                  for (final item in controller.sections)
                    AppSelectOption(value: item.id, label: item.title),
                ],
                onChanged: controller.selectSection,
              ),
              const SizedBox(height: 12),
              AppSelectField<int?>(
                key: const Key('grades-filter-course'),
                label: context.l10n.selectCourse,
                value: controller.selectedCourseId,
                enabled: controller.selectedSectionId != null,
                options: [
                  AppSelectOption(
                    value: null,
                    label: context.l10n.allCourses,
                  ),
                  for (final item in controller.courses)
                    AppSelectOption(value: item.id, label: item.title),
                ],
                onChanged: controller.selectCourse,
              ),
              const SizedBox(height: 12),
              AppSelectField<int?>(
                key: const Key('grades-filter-type'),
                label: context.l10n.assessmentType,
                value: controller.selectedGradeTypeId,
                options: [
                  AppSelectOption(
                    value: null,
                    label: context.l10n.allGradeTypes,
                  ),
                  for (final item in controller.options.gradeTypes)
                    AppSelectOption(value: item.id, label: item.title),
                ],
                onChanged: controller.selectGradeType,
              ),
              const Spacer(),
              FilledButton(
                key: const Key('grades_load_button'),
                onPressed: controller.state.status == LoadStatus.loading
                    ? null
                    : onApply,
                child: Text(context.l10n.loadGrades),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradeCard extends StatelessWidget {
  const _GradeCard({super.key, required this.assessment});

  final GradeAssessmentSummary assessment;

  @override
  Widget build(BuildContext context) {
    Future<void> openDetails() async {
      await AppNavigator.gradeEntry(context, assessment: assessment);
      if (context.mounted) {
        await context.read<GradesController>().refresh();
      }
    }

    return SectionCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: openDetails,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        assessment.courseTitle,
                        style: context.textStyles.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${assessment.classLabel}\n${assessment.gradeTypeTitle} · ${assessment.entriesCount} ${context.l10n.entriesLabel}',
                        style: context.textStyles.bodySmall?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${context.l10n.coefficientLabel} ${assessment.coefficient.toStringAsFixed(assessment.coefficient % 1 == 0 ? 0 : 2)}',
                        style: context.textStyles.bodySmall?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        DateFormat.yMMMd().format(assessment.publishDate),
                        style: context.textStyles.bodySmall?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    assessment.maxGrade.toStringAsFixed(
                      assessment.maxGrade % 1 == 0 ? 0 : 1,
                    ),
                    style: context.textStyles.titleSmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
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
