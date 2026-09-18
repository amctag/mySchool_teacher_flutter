import 'package:flutter/material.dart';
import 'package:my_school_teacher/core/widgets/controller_consumer.dart';
import 'package:provider/provider.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/models/grade_assessment.dart';
import 'package:my_school_teacher/models/grade_entry_context.dart';
import 'package:my_school_teacher/models/request_models.dart';
import 'package:my_school_teacher/controllers/grade_entry_controller.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/section_card.dart';
import 'package:my_school_teacher/views/widgets/state_views.dart';
import 'package:my_school_teacher/views/widgets/app_select_field.dart';

class GradeEntryPage extends StatefulWidget {
  const GradeEntryPage({super.key, this.assessment});

  final GradeAssessmentSummary? assessment;

  @override
  State<GradeEntryPage> createState() => _GradeEntryPageState();
}

class _GradeEntryPageState extends State<GradeEntryPage> {
  final _maxGradeController = TextEditingController();
  final Map<int, TextEditingController> _scoreControllers = {};
  bool _seededFromContext = false;
  String? _seededKey;
  bool _editing = false;

  bool get _isExistingSheet => widget.assessment != null;

  bool get _canEdit => !_isExistingSheet || _editing;

  @override
  void dispose() {
    _maxGradeController.dispose();
    for (final controller in _scoreControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrandAppBar(
        title: widget.assessment == null
            ? context.l10n.addGrades
            : _editing
                ? context.l10n.editGrades
                : context.l10n.grades,
      ),
      body: ControllerConsumer<GradeEntryController, GradeEntryState>(
        listener: (context, state) {
          _seedFromContext(state);
          if (state.status == GradeEntryStatus.success) {
            Navigator.pop(context);
          }
          if (state.status == GradeEntryStatus.failure &&
              state.message != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message!)));
          }
        },
        builder: (context, state) {
          if (state.status == GradeEntryStatus.loading &&
              state.options.classes.isEmpty) {
            return const LoadingView();
          }
          if (state.options.classes.isEmpty) {
            return RefreshableEmptyView(
              icon: Icons.grade_rounded,
              message: context.l10n.noAssignedClasses,
              onRefresh: () => context.read<GradeEntryController>().initialize(
                assessment: widget.assessment,
              ),
            );
          }
          _seedFromContext(state);
          final entryContext = state.context;
          final selectedCourse = state.selectedCourse;
          final students = entryContext == null
              ? const <GradeEntryStudent>[]
              : _studentsForForm(entryContext);
          final canEditSettings = _isExistingSheet
              ? _editing
              : entryContext?.gradeSheetId == null;
          final isMainType = state.selectedTypeIsMain;
          final coefficient =
              selectedCourse?.coefficient ?? entryContext?.coefficient;
          final lockedMaxGrade = isMainType &&
                  coefficient != null &&
                  coefficient > 0
              ? coefficient
              : entryContext?.maxGrade;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              SectionCard(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppSelectField<int>(
                            key: const Key('grade-class'),
                            label: context.l10n.selectClass,
                            value: _valueIn(
                              state.selectedClassId,
                              state.options.classes.map((item) => item.id),
                            ),
                            enabled: widget.assessment == null,
                            options: [
                              for (final item in state.options.classes)
                                AppSelectOption(
                                  value: item.id,
                                  label: item.name,
                                ),
                            ],
                            onChanged: context
                                .read<GradeEntryController>()
                                .selectClass,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AppSelectField<int>(
                            key: const Key('grade-section'),
                            label: context.l10n.selectSection,
                            value: _valueIn(
                              state.selectedSectionId,
                              state.sections.map((item) => item.id),
                            ),
                            enabled: widget.assessment == null &&
                                state.selectedClassId != null,
                            options: [
                              for (final item in state.sections)
                                AppSelectOption(
                                  value: item.id,
                                  label: item.title,
                                ),
                            ],
                            onChanged: context
                                .read<GradeEntryController>()
                                .selectSection,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppSelectField<int>(
                            key: const Key('grade-course'),
                            label: context.l10n.selectCourse,
                            value: _valueIn(
                              state.selectedCourseId,
                              state.courses.map((item) => item.id),
                            ),
                            enabled: widget.assessment == null &&
                                state.selectedSectionId != null,
                            options: [
                              for (final item in state.courses)
                                AppSelectOption(
                                  value: item.id,
                                  label: item.title,
                                ),
                            ],
                            onChanged: context
                                .read<GradeEntryController>()
                                .selectCourse,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AppSelectField<int>(
                            key: const Key('grade-type'),
                            label: context.l10n.assessmentType,
                            value: _valueIn(
                              state.selectedGradeTypeId,
                              state.options.gradeTypes.map((item) => item.id),
                            ),
                            enabled: widget.assessment == null &&
                                state.canChooseAssessmentType,
                            options: [
                              for (final item in state.options.gradeTypes)
                                AppSelectOption(
                                  value: item.id,
                                  label: item.title,
                                  enabled: widget.assessment != null ||
                                      !state.isGradeTypeUsed(item.id),
                                  subtitle: widget.assessment == null &&
                                          state.isGradeTypeUsed(item.id)
                                      ? context.l10n.assessmentAlreadyExists
                                      : null,
                                ),
                            ],
                            onChanged: context
                                .read<GradeEntryController>()
                                .selectGradeType,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _MetaLine(
                            label: context.l10n.coefficientLabel,
                            value: coefficient == null
                                ? '—'
                                : _formatNumber(coefficient),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: isMainType || !canEditSettings
                              ? _MetaLine(
                                  label: context.l10n.maxGradeLabel,
                                  value: lockedMaxGrade == null
                                      ? (_maxGradeController.text.trim().isEmpty
                                          ? '—'
                                          : _maxGradeController.text)
                                      : _formatNumber(lockedMaxGrade),
                                )
                              : TextFormField(
                                  controller: _maxGradeController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: context.l10n.maxGradeLabel,
                                    isDense: true,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (state.status == GradeEntryStatus.loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: LoadingView(),
                )
              else if (!state.canChooseAssessmentType)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: EmptyView(
                    icon: Icons.tune_rounded,
                    message: context.l10n.selectClassSectionCourseFirst,
                  ),
                )
              else if (entryContext == null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: EmptyView(
                    icon: Icons.groups_outlined,
                    message: context.l10n.selectClassSectionCourse,
                  ),
                )
              else if (students.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: EmptyView(
                    icon: Icons.grade_rounded,
                    message: context.l10n.allStudentsAlreadyGraded,
                  ),
                )
              else
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${context.l10n.students} · ${entryContext.classLabel} · ${entryContext.courseTitle}',
                        style: context.textStyles.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${context.l10n.coefficientLabel} ${entryContext.coefficient.toStringAsFixed(entryContext.coefficient % 1 == 0 ? 0 : 2)}',
                        style: context.textStyles.bodySmall?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      for (
                        var index = 0;
                        index < students.length;
                        index++
                      ) ...[
                        if (_canEdit)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  students[index].fullName,
                                  style: context.textStyles.titleSmall,
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: 88,
                                child: TextFormField(
                                  controller: _scoreControllerFor(
                                    students[index].registrationId,
                                    students[index].score,
                                  ),
                                  textAlign: TextAlign.end,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: context.l10n.scoreLabel,
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    students[index].fullName,
                                    style: context.textStyles.titleSmall,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  students[index].score == null
                                      ? '—'
                                      : _formatNumber(students[index].score!),
                                  style: context.textStyles.titleMedium,
                                ),
                              ],
                            ),
                          ),
                        if (index < students.length - 1)
                          const Divider(height: 24),
                      ],
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              if (_isExistingSheet && !_editing)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: entryContext == null
                        ? null
                        : () => setState(() => _editing = true),
                    child: Text(context.l10n.editGrades),
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed:
                        state.status == GradeEntryStatus.submitting ||
                            entryContext == null ||
                            students.isEmpty
                        ? null
                        : _submit,
                    child: Text(context.l10n.save),
                  ),
                ),
              if (_isExistingSheet && _editing) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: state.status == GradeEntryStatus.submitting
                        ? null
                        : _confirmDelete,
                    child: Text(context.l10n.delete),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  void _seedFromContext(GradeEntryState state) {
    final entryContext = state.context;
    if (entryContext == null) {
      _seededFromContext = false;
      _seededKey = null;
      return;
    }
    final key =
        '${entryContext.sectionId}-${entryContext.courseId}-${entryContext.gradeTypeId}';
    if (_seededFromContext && _seededKey == key) {
      return;
    }
    _seededFromContext = true;
    _seededKey = key;
    for (final controller in _scoreControllers.values) {
      controller.dispose();
    }
    _scoreControllers.clear();
    _maxGradeController.text = entryContext.maxGrade.toStringAsFixed(
      entryContext.maxGrade % 1 == 0 ? 0 : 1,
    );
  }

  List<GradeEntryStudent> _studentsForForm(GradeEntryContext entryContext) {
    if (_isExistingSheet) {
      return entryContext.students;
    }
    return entryContext.students
        .where((student) => student.score == null)
        .toList(growable: false);
  }

  String _formatNumber(double value) {
    return value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
  }

  TextEditingController _scoreControllerFor(int registrationId, double? score) {
    return _scoreControllers.putIfAbsent(registrationId, () {
      if (score == null) {
        return TextEditingController();
      }
      return TextEditingController(
        text: score.toStringAsFixed(score % 1 == 0 ? 0 : 1),
      );
    });
  }

  void _submit() {
    final state = context.read<GradeEntryController>().state;
    final entryContext = state.context;
    final sectionId = state.selectedSectionId;
    final courseId = state.selectedCourseId;
    final gradeTypeId = state.selectedGradeTypeId;
    if (entryContext == null ||
        sectionId == null ||
        courseId == null ||
        gradeTypeId == null) {
      return;
    }
    final maxGrade = state.selectedTypeIsMain
        ? (state.selectedCourse?.coefficient ?? entryContext.coefficient)
        : (double.tryParse(_maxGradeController.text.trim()) ??
            entryContext.maxGrade);
    if (maxGrade < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.maxGradeLabel)),
      );
      return;
    }
    final entries = [
      for (final student in _studentsForForm(entryContext))
        StudentGradeInput(
          registrationId: student.registrationId,
          studentId: student.studentId,
          score: double.tryParse(
            _scoreControllers[student.registrationId]?.text ?? '',
          ),
        ),
    ];
    if (!entries.any((entry) => entry.score != null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.atLeastOneGradeRequired)),
      );
      return;
    }
    context.read<GradeEntryController>().save(
      SaveTeacherGradesRequest(
        sectionId: sectionId,
        courseId: courseId,
        gradeTypeId: gradeTypeId,
        maxGrade: maxGrade,
        publishDate: DateTime.tryParse(entryContext.publishDate ?? '') ??
            DateTime.now(),
        entries: entries,
      ),
    );
  }

  Future<void> _confirmDelete() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.delete),
        content: Text(context.l10n.deleteItemQuestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.close),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
    if (shouldDelete == true && mounted && widget.assessment != null) {
      await context.read<GradeEntryController>().delete(widget.assessment!.id);
    }
  }

  int? _valueIn(int? value, Iterable<int> ids) {
    if (value == null) {
      return null;
    }
    return ids.contains(value) ? value : null;
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.labelMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.bodyLarge,
          ),
        ],
      ),
    );
  }
}
