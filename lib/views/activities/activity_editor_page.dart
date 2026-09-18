import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_school_teacher/controllers/activity_composer_controller.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/core/widgets/controller_consumer.dart';
import 'package:my_school_teacher/models/request_models.dart';
import 'package:my_school_teacher/views/widgets/app_select_field.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/state_views.dart';
import 'package:provider/provider.dart';

class ActivityEditorPage extends StatefulWidget {
  const ActivityEditorPage({super.key});

  @override
  State<ActivityEditorPage> createState() => _ActivityEditorPageState();
}

class _ActivityEditorPageState extends State<ActivityEditorPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  int? _selectedAssignmentId;
  String? _imageName;
  String? _imageUrl;
  bool _uploadingImage = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrandAppBar(title: context.l10n.addActivity),
      body: ControllerConsumer<ActivityComposerController, ActivityComposerState>(
        listener: (context, state) {
          if (state.status == ActivityComposerStatus.success) {
            Navigator.pop(context, true);
          }
          if (state.status == ActivityComposerStatus.failure &&
              state.message != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message!)));
          }
        },
        builder: (context, state) {
          if (state.status == ActivityComposerStatus.loading) {
            return const LoadingView();
          }
          if (state.status == ActivityComposerStatus.failure &&
              state.assignments.isEmpty) {
            return ErrorView(
              onRetry: context.read<ActivityComposerController>().load,
              message: state.message,
            );
          }
          final assignments = state.assignments;
          if (assignments.isEmpty) {
            return EmptyView(
              icon: Icons.class_outlined,
              message: context.l10n.noClassesAvailable,
            );
          }
          _selectedAssignmentId ??= assignments.first.id;
          final submitting =
              state.status == ActivityComposerStatus.submitting;
          final busy = submitting || _uploadingImage;
          return Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    children: [
                      AppSelectField<int>(
                        key: const Key('activity_assignment'),
                        label: context.l10n.assignment,
                        value: _selectedAssignmentId,
                        enabled: !busy,
                        options: [
                          for (final assignment in assignments)
                            AppSelectOption(
                              value: assignment.id,
                              label:
                                  '${assignment.classLabel} · ${assignment.courseTitle}',
                            ),
                        ],
                        onChanged: (value) => setState(
                          () => _selectedAssignmentId = value,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        minVerticalPadding: 8,
                        leading: Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: context.colors.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.calendar_today_outlined,
                            color: context.colors.primary,
                          ),
                        ),
                        title: Text(context.l10n.activityDate),
                        subtitle: Text(
                          DateFormat.yMMMEd().format(_selectedDate),
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: busy ? null : _pickDate,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _titleController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: context.l10n.titleLabel,
                          isDense: true,
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? context.l10n.fieldRequired
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _contentController,
                        maxLines: 4,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: context.l10n.activityContent,
                          alignLabelWithHint: true,
                          isDense: true,
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? context.l10n.fieldRequired
                            : null,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        context.l10n.attachments,
                        style: context.textStyles.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.l10n.optional,
                        style: context.textStyles.bodySmall?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _AttachmentTile(
                        key: const Key('activity_pick_image'),
                        icon: Icons.image_outlined,
                        title: context.l10n.attachImage,
                        subtitle: _uploadingImage
                            ? context.l10n.uploading
                            : (_imageName ?? context.l10n.chooseImage),
                        selected: _imageUrl != null,
                        uploading: _uploadingImage,
                        onClear: () => setState(() {
                          _imageName = null;
                          _imageUrl = null;
                        }),
                        onPick: busy ? null : _pickImage,
                      ),
                    ],
                  ),
                ),
                Material(
                  color: context.colors.surface,
                  child: SafeArea(
                    top: false,
                    minimum: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: busy ? null : _submit,
                          child: submitting
                              ? const SizedBox.square(
                                  dimension: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(context.l10n.save),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
      initialDate: _selectedDate,
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickImage() async {
    final file = await FilePicker.pickFile(type: FileType.image);
    if (!mounted || file == null) {
      return;
    }
    final name = file.name;
    final lower = name.toLowerCase();
    if (!const ['jpg', 'jpeg', 'png', 'webp', 'gif']
        .any((ext) => lower.endsWith('.$ext'))) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.imageOnly)));
      return;
    }
    setState(() => _uploadingImage = true);
    try {
      final bytes = await file.readAsBytes();
      if (!mounted) {
        return;
      }
      final url = await context
          .read<ActivityComposerController>()
          .uploadActivityMedia(bytes: bytes, filename: file.name);
      if (!mounted) {
        return;
      }
      setState(() {
        _imageName = file.name;
        _imageUrl = url;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.uploadFailed)));
    } finally {
      if (mounted) {
        setState(() => _uploadingImage = false);
      }
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate() || _selectedAssignmentId == null) {
      return;
    }
    final assignment = context
        .read<ActivityComposerController>()
        .state
        .assignments
        .firstWhere((item) => item.id == _selectedAssignmentId);
    context.read<ActivityComposerController>().create(
      UpsertActivityRequest(
        assignmentId: assignment.id,
        classId: assignment.classId,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        date: _selectedDate,
        image: _imageUrl,
      ),
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  const _AttachmentTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.uploading,
    required this.onClear,
    required this.onPick,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final bool uploading;
  final VoidCallback onClear;
  final VoidCallback? onPick;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? context.colors.primaryContainer.withValues(alpha: 0.45)
          : context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: selected
              ? context.colors.primary.withValues(alpha: 0.35)
              : context.colors.outlineVariant,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onPick,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: context.colors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.textStyles.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (uploading)
                const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (selected)
                IconButton(
                  onPressed: onClear,
                  icon: const Icon(Icons.close_rounded),
                  tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
                )
              else
                Icon(
                  Icons.add_rounded,
                  color: context.colors.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
