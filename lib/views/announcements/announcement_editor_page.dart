import 'package:flutter/material.dart';
import 'package:my_school_teacher/controllers/announcement_composer_controller.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/core/widgets/controller_consumer.dart';
import 'package:my_school_teacher/models/request_models.dart';
import 'package:my_school_teacher/views/widgets/app_select_field.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/state_views.dart';
import 'package:provider/provider.dart';

class AnnouncementEditorPage extends StatefulWidget {
  const AnnouncementEditorPage({super.key});

  @override
  State<AnnouncementEditorPage> createState() => _AnnouncementEditorPageState();
}

class _AnnouncementEditorPageState extends State<AnnouncementEditorPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int? _selectedClassId;
  String _audience = 'parent';

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrandAppBar(title: context.l10n.addAnnouncement),
      body: ControllerConsumer<
        AnnouncementComposerController,
        AnnouncementComposerState
      >(
        listener: (context, state) {
          if (state.status == AnnouncementComposerStatus.success) {
            Navigator.pop(context, true);
          }
          if (state.status == AnnouncementComposerStatus.failure &&
              state.message != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message!)));
          }
        },
        builder: (context, state) {
          if (state.status == AnnouncementComposerStatus.loading) {
            return const LoadingView();
          }
          if (state.status == AnnouncementComposerStatus.failure &&
              state.classes.isEmpty) {
            return ErrorView(
              onRetry: context.read<AnnouncementComposerController>().load,
              message: state.message,
            );
          }
          final classes = state.classes;
          if (classes.isEmpty) {
            return EmptyView(
              icon: Icons.class_outlined,
              message: context.l10n.noClassesAvailable,
            );
          }
          _selectedClassId ??= classes.first.id;
          final submitting =
              state.status == AnnouncementComposerStatus.submitting;
          return Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      AppSelectField<int>(
                        label: context.l10n.selectClass,
                        value: _selectedClassId,
                        options: [
                          for (final item in classes)
                            AppSelectOption(
                              value: item.id,
                              label: '${item.className} · ${item.sectionTitle}',
                            ),
                        ],
                        onChanged: (value) {
                          setState(() => _selectedClassId = value);
                        },
                      ),
                      const SizedBox(height: 16),
                      AppSelectField<String>(
                        label: context.l10n.announcementAudience,
                        value: _audience,
                        options: [
                          AppSelectOption(
                            value: 'parent',
                            label: context.l10n.audienceParent,
                          ),
                          AppSelectOption(
                            value: 'teacher',
                            label: context.l10n.audienceTeacher,
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _audience = value);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: context.l10n.titleLabel,
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _contentController,
                        minLines: 4,
                        maxLines: 8,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? context.l10n.fieldRequired
                            : null,
                        decoration: InputDecoration(
                          labelText: context.l10n.noticeContent,
                          alignLabelWithHint: true,
                          isDense: true,
                        ),
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: submitting ? null : _submit,
                        child: submitting
                            ? const SizedBox.square(
                                dimension: 22,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(context.l10n.save),
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedClassId == null) {
      return;
    }
    await context.read<AnnouncementComposerController>().submit(
      CreateAnnouncementRequest(
        sectionId: _selectedClassId!,
        audience: _audience,
        title: _titleController.text,
        content: _contentController.text.trim(),
      ),
    );
  }
}
