import 'package:flutter/material.dart';
import 'package:my_school_teacher/core/widgets/controller_consumer.dart';
import 'package:provider/provider.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/controllers/change_password_controller.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/section_card.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmationController = TextEditingController();

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrandAppBar(title: context.l10n.changePassword),
      body: ControllerConsumer<ChangePasswordController, ChangePasswordState>(
        listener: (context, state) {
          if (state.status == ChangePasswordStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.passwordUpdated)),
            );
            Navigator.pop(context);
          } else if (state.status == ChangePasswordStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.passwordUpdateFailed)),
            );
          }
        },
        builder: (context, state) {
          final submitting = state.status == ChangePasswordStatus.submitting;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Container(
                  width: 92,
                  height: 92,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.colors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.password_rounded,
                    size: 42,
                    color: context.colors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SectionCard(
                child: Column(
                  children: [
                    _PasswordField(
                      config: _PasswordFieldConfig(
                        fieldKey: const Key('current_password'),
                        label: context.l10n.currentPassword,
                        autofillHint: AutofillHints.password,
                      ),
                      controller: _currentController,
                      errorText: _errorText(context, state.currentError),
                    ),
                    const SizedBox(height: 16),
                    _PasswordField(
                      config: _PasswordFieldConfig(
                        fieldKey: const Key('new_password'),
                        label: context.l10n.newPassword,
                        autofillHint: AutofillHints.newPassword,
                      ),
                      controller: _newController,
                      errorText: _errorText(context, state.newError),
                    ),
                    const SizedBox(height: 16),
                    _PasswordField(
                      config: _PasswordFieldConfig(
                        fieldKey: const Key('confirm_password'),
                        label: context.l10n.confirmNewPassword,
                        autofillHint: AutofillHints.newPassword,
                        textInputAction: TextInputAction.done,
                      ),
                      controller: _confirmationController,
                      errorText: _errorText(context, state.confirmationError),
                      onSubmitted: submitting ? null : _submit,
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        key: const Key('change_password_submit'),
                        onPressed: submitting ? null : _submit,
                        child: submitting
                            ? SizedBox.square(
                                dimension: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: context.colors.onPrimary,
                                ),
                              )
                            : Text(context.l10n.changePassword),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String? _errorText(BuildContext context, PasswordFieldError? error) =>
      switch (error) {
        null => null,
        PasswordFieldError.required => context.l10n.fieldRequired,
        PasswordFieldError.tooShort => context.l10n.passwordTooShort,
        PasswordFieldError.mismatch => context.l10n.passwordsDoNotMatch,
        PasswordFieldError.incorrectCurrent =>
          context.l10n.currentPasswordIncorrect,
      };

  void _submit() {
    context.read<ChangePasswordController>().changePassword(
      currentPassword: _currentController.text,
      newPassword: _newController.text,
      confirmation: _confirmationController.text,
    );
  }
}

class _PasswordFieldConfig {
  const _PasswordFieldConfig({
    required this.fieldKey,
    required this.label,
    required this.autofillHint,
    this.textInputAction = TextInputAction.next,
  });

  final Key fieldKey;
  final String label;
  final String autofillHint;
  final TextInputAction textInputAction;
}

class _PasswordField extends StatefulWidget {
  const _PasswordField({
    required this.config,
    required this.controller,
    required this.errorText,
    this.onSubmitted,
  });

  final _PasswordFieldConfig config;
  final TextEditingController controller;
  final String? errorText;
  final VoidCallback? onSubmitted;

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: widget.config.fieldKey,
      controller: widget.controller,
      obscureText: !_visible,
      textInputAction: widget.config.textInputAction,
      autofillHints: [widget.config.autofillHint],
      onSubmitted: widget.onSubmitted == null
          ? null
          : (_) => widget.onSubmitted!(),
      decoration: InputDecoration(
        labelText: widget.config.label,
        errorText: widget.errorText,
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          tooltip: _visible
              ? context.l10n.hidePassword
              : context.l10n.showPassword,
          onPressed: () => setState(() => _visible = !_visible),
          icon: Icon(
            _visible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
        ),
      ),
    );
  }
}
