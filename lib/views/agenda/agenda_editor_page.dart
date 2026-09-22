import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:my_school_teacher/core/widgets/controller_consumer.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/models/request_models.dart';
import 'package:my_school_teacher/models/teacher_agenda_item.dart';
import 'package:my_school_teacher/controllers/agenda_composer_controller.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/state_views.dart';
import 'package:my_school_teacher/views/widgets/app_select_field.dart';

class AgendaEditorPage extends StatefulWidget {
  const AgendaEditorPage({
    super.key,
    this.item,
    this.canPublish = true,
  });

  final TeacherAgendaItem? item;
  final bool canPublish;

  @override
  State<AgendaEditorPage> createState() => _AgendaEditorPageState();
}

class _AgendaEditorPageState extends State<AgendaEditorPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  int? _selectedAssignmentId;
  String? _imageName;
  String? _imageUrl;
  String? _pdfName;
  String? _pdfUrl;
  bool _uploadingImage = false;
  bool _uploadingPdf = false;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    if (item == null) {
      return;
    }
    _titleController.text = item.title;
    _descriptionController.text = item.description;
    _selectedDate = item.date;
    _selectedAssignmentId = item.assignmentId == 0 ? null : item.assignmentId;
    _imageUrl = item.imageLink;
    _imageName = item.imageLink;
    _pdfUrl = item.fileLink;
    _pdfName = item.fileLink;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrandAppBar(
        title: _isEditing ? context.l10n.editAgenda : context.l10n.addAgenda,
      ),
      body: ControllerConsumer<AgendaComposerController, AgendaComposerState>(
        listener: (context, state) {
          if (state.status == AgendaComposerStatus.success) {
            Navigator.pop(context, true);
          }
          if (state.status == AgendaComposerStatus.failure &&
              state.message != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message!)));
          }
        },
        builder: (context, state) {
          if (state.status == AgendaComposerStatus.loading) {
            return const LoadingView();
          }
          if (state.status == AgendaComposerStatus.failure &&
              state.assignments.isEmpty) {
            return ErrorView(
              onRetry: context.read<AgendaComposerController>().load,
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
          _selectedAssignmentId ??= () {
            final item = widget.item;
            if (item != null) {
              for (final assignment in assignments) {
                if (assignment.id == item.assignmentId) {
                  return assignment.id;
                }
              }
              for (final assignment in assignments) {
                if (assignment.classId == item.classId) {
                  return assignment.id;
                }
              }
            }
            return assignments.first.id;
          }();
          final submitting =
              state.status == AgendaComposerStatus.submitting;
          final uploading = _uploadingImage || _uploadingPdf;
          final busy = submitting || uploading;
          return Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    children: [
                      if (!_canPublish) ...[
                        Text(
                          context.l10n.schoolPublishesAgenda,
                          style: context.textStyles.bodyMedium?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      AppSelectField<int>(
                        key: const Key('agenda_assignment'),
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
                        title: Text(context.l10n.agendaDate),
                        subtitle: Text(
                          DateFormat.yMMMEd().format(_selectedDate),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                        ),
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
                        controller: _descriptionController,
                        maxLines: 4,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: context.l10n.agendaDescription,
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
                        key: const Key('agenda_pick_image'),
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
                      const SizedBox(height: 8),
                      _AttachmentTile(
                        key: const Key('agenda_pick_pdf'),
                        icon: Icons.picture_as_pdf_outlined,
                        title: context.l10n.attachPdf,
                        subtitle: _uploadingPdf
                            ? context.l10n.uploading
                            : (_pdfName ?? context.l10n.choosePdf),
                        selected: _pdfUrl != null,
                        uploading: _uploadingPdf,
                        onClear: () => setState(() {
                          _pdfName = null;
                          _pdfUrl = null;
                        }),
                        onPick: busy ? null : _pickPdf,
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
                      child: _editorActions(
                        context,
                        busy: busy,
                        submitting: submitting,
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
    if (!_hasExtension(name, const ['jpg', 'jpeg', 'png', 'webp', 'gif'])) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.imageOnly)));
      return;
    }
    await _uploadPickedFile(file: file, kind: 'image');
  }

  Future<void> _pickPdf() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
    );
    if (!mounted || file == null) {
      return;
    }
    final name = file.name;
    if (!_hasExtension(name, const ['pdf'])) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.pdfOnly)));
      return;
    }
    await _uploadPickedFile(file: file, kind: 'file');
  }

  Future<void> _uploadPickedFile({
    required PlatformFile file,
    required String kind,
  }) async {
    setState(() {
      if (kind == 'image') {
        _uploadingImage = true;
      } else {
        _uploadingPdf = true;
      }
    });
    try {
      final bytes = await file.readAsBytes();
      if (!mounted) {
        return;
      }
      final url = await context
          .read<AgendaComposerController>()
          .uploadAgendaMedia(
            bytes: bytes,
            filename: file.name,
            kind: kind,
          );
      if (!mounted) {
        return;
      }
      setState(() {
        if (kind == 'image') {
          _imageName = file.name;
          _imageUrl = url;
        } else {
          _pdfName = file.name;
          _pdfUrl = url;
        }
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
        setState(() {
          if (kind == 'image') {
            _uploadingImage = false;
          } else {
            _uploadingPdf = false;
          }
        });
      }
    }
  }

  bool _hasExtension(String name, List<String> extensions) {
    final lower = name.toLowerCase();
    return extensions.any((ext) => lower.endsWith('.$ext'));
  }

  bool get _canPublish => widget.item?.canPublish ?? widget.canPublish;

  Widget _editorActions(
    BuildContext context, {
    required bool busy,
    required bool submitting,
  }) {
    final keepPublished = widget.item?.published == true;
    if (keepPublished || !_canPublish) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: busy ? null : () => _submit(published: keepPublished),
          child: submitting
              ? const SizedBox.square(
                  dimension: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(context.l10n.save),
        ),
      );
    }
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(64, 52),
            ),
            onPressed: busy ? null : () => _submit(published: false),
            child: Text(context.l10n.save),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: busy ? null : () => _submit(published: true),
            child: submitting
                ? const SizedBox.square(
                    dimension: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(context.l10n.publish),
          ),
        ),
      ],
    );
  }

  void _submit({required bool published}) {
    if (!_formKey.currentState!.validate() || _selectedAssignmentId == null) {
      return;
    }
    final assignment = context
        .read<AgendaComposerController>()
        .state
        .assignments
        .firstWhere((item) => item.id == _selectedAssignmentId);
    final request = UpsertAgendaRequest(
      assignmentId: assignment.id,
      classId: assignment.classId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      date: _selectedDate,
      imageLink: _imageUrl,
      fileLink: _pdfUrl,
      published: published,
    );
    final controller = context.read<AgendaComposerController>();
    final item = widget.item;
    if (item == null) {
      controller.create(request);
      return;
    }
    controller.update(item.id, request);
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
        onTap: uploading ? null : onPick,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  child: Icon(icon, color: context.colors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
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
                    dimension: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else if (selected)
                  IconButton(
                    tooltip: context.l10n.delete,
                    onPressed: onClear,
                    icon: const Icon(Icons.close_rounded),
                  )
                else
                  Icon(
                    Icons.upload_file_outlined,
                    color: context.colors.onSurfaceVariant,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



