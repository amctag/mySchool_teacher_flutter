import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_school_teacher/controllers/attendance_entry_controller.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/core/widgets/controller_consumer.dart';
import 'package:my_school_teacher/models/attendance.dart';
import 'package:my_school_teacher/models/teacher_attendance.dart';
import 'package:my_school_teacher/views/widgets/app_select_field.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/section_card.dart';
import 'package:my_school_teacher/views/widgets/state_views.dart';
import 'package:provider/provider.dart';

class AttendanceEntryPage extends StatelessWidget {
  const AttendanceEntryPage({super.key, this.item});

  final TeacherAttendanceListItem? item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrandAppBar(
        title: item == null
            ? context.l10n.takeAttendance
            : context.l10n.attendance,
      ),
      body:
          ControllerConsumer<AttendanceEntryController, AttendanceEntryState>(
            listener: (context, state) {
              if (state.status == AttendanceEntryStatus.success) {
                Navigator.pop(context);
              }
              if (state.status == AttendanceEntryStatus.failure &&
                  state.message != null) {
                final message = switch (state.message) {
                  'reason_required' => context.l10n.attendanceReasonRequired,
                  'class_required' => context.l10n.selectClassSectionCourseFirst,
                  'view_only' => context.l10n.attendanceViewOnly,
                  _ => state.message!,
                };
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(message)));
              }
            },
            builder: (context, state) {
              final controller = context.read<AttendanceEntryController>();
              final canEdit = state.canTakeAttendance;
              if (state.status == AttendanceEntryStatus.loading &&
                  state.options.classes.isEmpty) {
                return const LoadingView();
              }
              if (state.options.classes.isEmpty) {
                return RefreshableEmptyView(
                  icon: Icons.event_available_rounded,
                  message: context.l10n.noEligibleAttendance,
                  onRefresh: () => controller.initialize(item: item),
                );
              }
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  SectionCard(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AppSelectField<int>(
                                key: const Key('attendance-class'),
                                label: context.l10n.selectClass,
                                value: _valueIn(
                                  state.selectedClassId,
                                  state.options.classes.map((item) => item.id),
                                ),
                                enabled: item == null,
                                options: [
                                  for (final classItem in state.options.classes)
                                    AppSelectOption(
                                      value: classItem.id,
                                      label: classItem.name,
                                    ),
                                ],
                                onChanged: controller.selectClass,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AppSelectField<int>(
                                key: const Key('attendance-section'),
                                label: context.l10n.selectSection,
                                value: _valueIn(
                                  state.selectedSectionId,
                                  state.sections.map((item) => item.id),
                                ),
                                enabled:
                                    item == null && state.selectedClassId != null,
                                options: [
                                  for (final section in state.sections)
                                    AppSelectOption(
                                      value: section.id,
                                      label: section.title,
                                    ),
                                ],
                                onChanged: controller.selectSection,
                              ),
                            ),
                          ],
                        ),
                        if (state.options.attendancePerCourse) ...[
                          const SizedBox(height: 10),
                          AppSelectField<int>(
                            key: const Key('attendance-course'),
                            label: context.l10n.selectCourse,
                            value: _valueIn(
                              state.selectedCourseId,
                              state.courses.map((item) => item.id),
                            ),
                            enabled:
                                item == null && state.selectedSectionId != null,
                            options: [
                              for (final course in state.courses)
                                AppSelectOption(
                                  value: course.id,
                                  label: course.title,
                                ),
                            ],
                            onChanged: controller.selectCourse,
                          ),
                        ],
                        const SizedBox(height: 10),
                        InkWell(
                          key: const Key('attendance-entry-date'),
                          borderRadius: BorderRadius.circular(14),
                          onTap: item == null
                              ? () async {
                                  final current =
                                      state.date ?? DateTime.now();
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: current,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime.now().add(
                                      const Duration(days: 14),
                                    ),
                                  );
                                  if (picked != null) {
                                    await controller.selectDate(picked);
                                  }
                                }
                              : null,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: context.l10n.attendanceDate,
                              isDense: true,
                              contentPadding: const EdgeInsets.fromLTRB(
                                12,
                                10,
                                8,
                                10,
                              ),
                              suffixIcon: const Icon(Icons.event_rounded),
                            ),
                            child: Text(
                              DateFormat.yMMMEd().format(
                                state.date ?? DateTime.now(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (state.status == AttendanceEntryStatus.loading)
                    const SizedBox(height: 180, child: LoadingView())
                  else if (!state.canLoadStudents)
                    EmptyView(
                      icon: Icons.groups_rounded,
                      message: state.options.attendancePerCourse
                          ? context.l10n.selectClassSectionCourse
                          : context.l10n.selectClass,
                    )
                  else if (state.students.isEmpty)
                    EmptyView(
                      icon: Icons.groups_rounded,
                      message: context.l10n.noStudentsInClass,
                    )
                  else ...[
                    if (canEdit)
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton(
                          onPressed: controller.markAllPresent,
                          child: Text(context.l10n.markAllPresent),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          context.l10n.attendanceViewOnly,
                          style: context.textStyles.bodySmall?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    for (final student in state.students) ...[
                      _StudentAttendanceCard(
                        student: student,
                        readOnly: !canEdit,
                      ),
                      const SizedBox(height: 6),
                    ],
                    if (canEdit) ...[
                      const SizedBox(height: 8),
                      FilledButton(
                        key: const Key('attendance_save_button'),
                        onPressed:
                            state.status == AttendanceEntryStatus.submitting
                            ? null
                            : controller.save,
                        child: Text(context.l10n.save),
                      ),
                    ],
                  ],
                ],
              );
            },
          ),
    );
  }

  T? _valueIn<T>(T? value, Iterable<T> allowed) {
    if (value == null) {
      return null;
    }
    return allowed.contains(value) ? value : null;
  }
}

class _StudentAttendanceCard extends StatelessWidget {
  const _StudentAttendanceCard({
    required this.student,
    required this.readOnly,
  });

  final TeacherAttendanceStudent student;
  final bool readOnly;

  bool get _isAbsent => student.status != AttendanceStatus.present;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AttendanceEntryController>();
    final reasons = context
        .watch<AttendanceEntryController>()
        .state
        .options
        .reasons;
    final groupValue = _isAbsent
        ? AttendanceStatus.absent
        : AttendanceStatus.present;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 6, 6, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    student.studentName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyles.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _StatusRadio(
                  label: context.l10n.present,
                  value: AttendanceStatus.present,
                  groupValue: groupValue,
                  enabled: !readOnly,
                  onChanged: (status) =>
                      controller.setStatus(student.studentId, status),
                ),
                _StatusRadio(
                  label: context.l10n.absent,
                  value: AttendanceStatus.absent,
                  groupValue: groupValue,
                  enabled: !readOnly,
                  onChanged: (status) =>
                      controller.setStatus(student.studentId, status),
                ),
              ],
            ),
            if (_isAbsent) ...[
              const SizedBox(height: 2),
              AppSelectField<int>(
                label: context.l10n.reason,
                value: student.attendanceReasonId,
                enabled: !readOnly,
                options: [
                  for (final reason in reasons)
                    AppSelectOption(value: reason.id, label: reason.title),
                ],
                onChanged: readOnly
                    ? (_) {}
                    : (value) =>
                        controller.setReason(student.studentId, value),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusRadio extends StatelessWidget {
  const _StatusRadio({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.enabled,
    required this.onChanged,
  });

  final String label;
  final AttendanceStatus value;
  final AttendanceStatus groupValue;
  final bool enabled;
  final ValueChanged<AttendanceStatus> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? () => onChanged(value) : null,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 2, end: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<AttendanceStatus>(
              value: value,
              groupValue: groupValue,
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: enabled ? (_) => onChanged(value) : null,
            ),
            Text(label, style: context.textStyles.labelMedium),
          ],
        ),
      ),
    );
  }
}
