import 'package:flutter/material.dart';
import 'package:my_school_teacher/core/widgets/controller_consumer.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/models/class_details.dart';
import 'package:my_school_teacher/models/request_models.dart';
import 'package:my_school_teacher/models/teacher_class_summary.dart';
import 'package:my_school_teacher/models/teacher_notice.dart';
import 'package:my_school_teacher/controllers/notice_composer_controller.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/section_card.dart';
import 'package:my_school_teacher/views/widgets/state_views.dart';

class NoticeEditorPage extends StatefulWidget {
  const NoticeEditorPage({super.key, this.notice});

  final TeacherNotice? notice;

  @override
  State<NoticeEditorPage> createState() => _NoticeEditorPageState();
}

class _NoticeEditorPageState extends State<NoticeEditorPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int? _selectedClassId;
  NoticeTargetType _targetType = NoticeTargetType.section;
  int? _targetId;
  DateTime _publishDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    final notice = widget.notice;
    if (notice != null) {
      _titleController.text = notice.title;
      _contentController.text = notice.content;
      _selectedClassId = notice.classId;
      _targetType = notice.targetType;
      _targetId = notice.targetId;
      _publishDate = notice.publishDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrandAppBar(
        title: widget.notice == null
            ? context.l10n.addNotice
            : context.l10n.editNotice,
      ),
      body: ControllerConsumer<NoticeComposerController, NoticeComposerState>(
        listener: (context, state) {
          if (state.status == NoticeComposerStatus.success) {
            Navigator.pop(context);
          }
          if (state.message != null &&
              state.status != NoticeComposerStatus.submitting &&
              state.status != NoticeComposerStatus.success) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message!)));
          }
          if (state.status == NoticeComposerStatus.ready) {
            _loadStudentsIfNeeded(context);
          }
        },
        builder: (context, state) {
          if (state.status == NoticeComposerStatus.loading) {
            return const LoadingView();
          }
          if (state.status == NoticeComposerStatus.failure &&
              state.assignedClasses.isEmpty) {
            return ErrorView(onRetry: context.read<NoticeComposerController>().load);
          }
          if (state.assignedClasses.isEmpty) {
            return EmptyView(
              icon: Icons.groups_rounded,
              message: context.l10n.noAssignedClasses,
            );
          }
          if (_selectedClassId == null) {
            return _ClassPicker(
              classes: state.assignedClasses,
              onSelect: _selectClass,
            );
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _EditorHeader(
                  icon: Icons.sticky_note_2_rounded,
                  title: widget.notice == null
                      ? context.l10n.addNotice
                      : context.l10n.editNotice,
                  subtitle: _selectedClass(state)?.label ?? context.l10n.notices,
                ),
                const SizedBox(height: 24),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: context.colors.primaryContainer,
                          foregroundColor: context.colors.primary,
                          child: Text(
                            _selectedClass(state)?.sectionTitle ?? '',
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                        title: Text(_selectedClass(state)?.label ?? ''),
                        subtitle: Text(
                          _selectedClass(state)?.primaryCourseTitle ?? '',
                        ),
                        trailing: widget.notice == null
                            ? TextButton(
                                onPressed:
                                    state.status ==
                                        NoticeComposerStatus.submitting
                                    ? null
                                    : () => setState(() {
                                        _selectedClassId = null;
                                        _targetId = null;
                                        _targetType = NoticeTargetType.section;
                                      }),
                                child: Text(context.l10n.changeClass),
                              )
                            : null,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.targetTypeLabel,
                        style: context.textStyles.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      SegmentedButton<NoticeTargetType>(
                        showSelectedIcon: false,
                        segments: [
                          ButtonSegment(
                            value: NoticeTargetType.section,
                            label: Text(context.l10n.sendToEntireClass),
                          ),
                          ButtonSegment(
                            value: NoticeTargetType.student,
                            label: Text(context.l10n.targetStudent),
                          ),
                        ],
                        selected: {_targetType},
                        onSelectionChanged:
                            state.status == NoticeComposerStatus.submitting
                            ? null
                            : (value) {
                                final next = value.first;
                                setState(() {
                                  _targetType = next;
                                  _targetId = next == NoticeTargetType.section
                                      ? _selectedClassId
                                      : null;
                                });
                                if (next == NoticeTargetType.student &&
                                    _selectedClassId != null) {
                                  context
                                      .read<NoticeComposerController>()
                                      .loadStudents(_selectedClassId!);
                                }
                              },
                      ),
                      if (_targetType == NoticeTargetType.student) ...[
                        const SizedBox(height: 16),
                        Text(
                          context.l10n.selectStudent,
                          style: context.textStyles.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        _StudentPicker(
                          students: state.studentsByClass[_selectedClassId],
                          loading: state.isLoadingStudents(_selectedClassId),
                          failed: state.message != null &&
                              !state.isLoadingStudents(_selectedClassId),
                          selectedId: _targetId,
                          onSelect: (id) => setState(() => _targetId = id),
                          onRetry: () => context
                              .read<NoticeComposerController>()
                              .loadStudents(_selectedClassId!),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: context.l10n.titleLabel,
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? context.l10n.fieldRequired
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _contentController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: context.l10n.noticeContent,
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? context.l10n.fieldRequired
                            : null,
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(context.l10n.publishDateLabel),
                        subtitle: Text(DateFormat.yMMMd().format(_publishDate)),
                        trailing: const Icon(Icons.calendar_today_outlined),
                        onTap: _pickDate,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: state.status == NoticeComposerStatus.submitting
                        ? null
                        : () => _submit(),
                    child: Text(context.l10n.save),
                  ),
                ),
                if (widget.notice != null) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: state.status == NoticeComposerStatus.submitting
                          ? null
                          : _confirmDelete,
                      child: Text(context.l10n.delete),
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

  TeacherClassSummary? _selectedClass(NoticeComposerState state) {
    for (final item in state.assignedClasses) {
      if (item.id == _selectedClassId) {
        return item;
      }
    }
    return null;
  }

  void _selectClass(int classId) {
    setState(() {
      _selectedClassId = classId;
      _targetType = NoticeTargetType.section;
      _targetId = classId;
    });
  }

  void _loadStudentsIfNeeded(BuildContext context) {
    final classId = _selectedClassId;
    if (classId == null || _targetType != NoticeTargetType.student) {
      return;
    }
    context.read<NoticeComposerController>().loadStudents(classId);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
      initialDate: _publishDate,
    );
    if (picked != null) {
      setState(() => _publishDate = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate() || _selectedClassId == null) {
      return;
    }
    final targetId = _targetType == NoticeTargetType.section
        ? _selectedClassId
        : _targetId;
    if (targetId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.selectStudent)),
      );
      return;
    }
    final request = UpsertNoticeRequest(
      classId: _selectedClassId!,
      targetType: _targetType,
      targetId: targetId,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      publishDate: _publishDate,
      assignmentId: widget.notice?.assignmentId,
    );
    if (widget.notice == null) {
      context.read<NoticeComposerController>().create(request);
      return;
    }
    context.read<NoticeComposerController>().update(widget.notice!.id, request);
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
    if (shouldDelete == true && mounted && widget.notice != null) {
      await context.read<NoticeComposerController>().delete(widget.notice!.id);
    }
  }
}

class _ClassPicker extends StatelessWidget {
  const _ClassPicker({required this.classes, required this.onSelect});

  final List<TeacherClassSummary> classes;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(context.l10n.selectClass, style: context.textStyles.titleLarge),
        const SizedBox(height: 16),
        for (final classSummary in classes) ...[
          SectionCard(
            padding: EdgeInsets.zero,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => onSelect(classSummary.id),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
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
                          const SizedBox(height: 4),
                          Text(
                            classSummary.primaryCourseTitle,
                            style: context.textStyles.bodySmall?.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded),
                  ],
                ),
              ),
            ),
          ),
          if (classSummary != classes.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _StudentPicker extends StatelessWidget {
  const _StudentPicker({
    required this.students,
    required this.loading,
    required this.failed,
    required this.selectedId,
    required this.onSelect,
    required this.onRetry,
  });

  final List<StudentSummary>? students;
  final bool loading;
  final bool failed;
  final int? selectedId;
  final ValueChanged<int> onSelect;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (loading || (students == null && !failed)) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: LoadingView(),
      );
    }
    if (students == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: TextButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
          label: Text(context.l10n.retry),
        ),
      );
    }
    if (students!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          context.l10n.noStudentsInClass,
          style: context.textStyles.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      );
    }
    return Column(
      children: [
        for (final student in students!)
          ListTile(
            contentPadding: EdgeInsets.zero,
            minVerticalPadding: 12,
            leading: CircleAvatar(
              backgroundColor: student.id == selectedId
                  ? context.colors.primary
                  : context.colors.primaryContainer,
              foregroundColor: student.id == selectedId
                  ? context.colors.onPrimary
                  : context.colors.primary,
              child: Text(student.initials),
            ),
            title: Text(student.fullName),
            subtitle: Text(
              '${context.l10n.seatNumberLabel} ${student.seatNumber}',
            ),
            trailing: student.id == selectedId
                ? Icon(Icons.check_circle, color: context.colors.primary)
                : const Icon(Icons.circle_outlined),
            onTap: () => onSelect(student.id),
          ),
      ],
    );
  }
}

class _EditorHeader extends StatelessWidget {
  const _EditorHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.colors.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: context.colors.primary, size: 28),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.textStyles.titleLarge),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: context.textStyles.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
