import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/core/notifications/push_notification_service.dart';
import 'package:my_school_teacher/controllers/auth_controller.dart';
import 'package:my_school_teacher/views/auth/support_dialog.dart';
import 'package:my_school_teacher/views/widgets/app_logo.dart';
import 'package:my_school_teacher/views/widgets/language_toggle.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  AuthController? _authController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = context.read<AuthController>();
    if (!identical(_authController, controller)) {
      _authController?.removeListener(_onAuthChanged);
      _authController = controller;
      _authController?.addListener(_onAuthChanged);
    }
  }

  @override
  void dispose() {
    _authController?.removeListener(_onAuthChanged);
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onAuthChanged() {
    final state = _authController?.state;
    if (state == null || state.status != AuthStatus.failure || !mounted) {
      return;
    }
    if (state.accountInactive || state.paymentRequired) {
      _showBlockedLoginDialog(
        context,
        paymentRequired: state.paymentRequired,
      );
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(state.message ?? context.l10n.credentialsRequired),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
                  children: [
                    const Center(child: AppLogo()),
                    const SizedBox(height: 14),
                    Text(
                      context.l10n.appName,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      context.l10n.welcomeBack,
                      textAlign: TextAlign.center,
                      style: context.textStyles.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.loginSubtitle,
                      textAlign: TextAlign.center,
                      style: context.textStyles.bodyLarge?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 28),
                    TextField(
                      key: const Key('login_id'),
                      controller: _idController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.username],
                      decoration: InputDecoration(
                        labelText: context.l10n.supportId,
                        prefixIcon: const Icon(Icons.badge_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      key: const Key('login_password'),
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      onSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: context.l10n.password,
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(
                              () => _obscurePassword = !_obscurePassword,
                            );
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                    ),
                    Consumer<AuthController>(
                      builder: (context, controller, _) {
                        final state = controller.state;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 20),
                            FilledButton(
                              key: const Key('login_submit'),
                              onPressed: state.status == AuthStatus.loading
                                  ? null
                                  : _submit,
                              child: state.status == AuthStatus.loading
                                  ? SizedBox.square(
                                      dimension: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: context.colors.onPrimary,
                                      ),
                                    )
                                  : Text(context.l10n.signIn),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              key: const Key('support_link'),
                              behavior: HitTestBehavior.opaque,
                              onTap: () => _openSupport(context),
                              child: Text(
                                context.l10n.support,
                                textAlign: TextAlign.center,
                                style: context.textStyles.labelLarge?.copyWith(
                                  color: context.colors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const PositionedDirectional(
              top: 8,
              end: 20,
              child: LanguageToggle(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final controller = context.read<AuthController>();
    String? deviceToken;
    try {
      deviceToken = await context.read<PushNotificationService>().getToken();
    } catch (_) {
      deviceToken = null;
    }
    if (!mounted) {
      return;
    }
    final id = int.tryParse(_idController.text.trim()) ?? 0;
    controller.login(
      id,
      _passwordController.text,
      deviceToken: deviceToken,
    );
  }

  void _openSupport(BuildContext context) {
    showSupportDialog(context, initialId: _idController.text.trim());
  }

  Future<void> _showBlockedLoginDialog(
    BuildContext context, {
    required bool paymentRequired,
  }) async {
    final l10n = context.l10n;
    final id = _idController.text.trim();
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          key: Key(
            paymentRequired
                ? 'account_unpaid_dialog'
                : 'account_inactive_dialog',
          ),
          title: Text(
            paymentRequired
                ? l10n.accountUnpaidTitle
                : l10n.accountInactiveTitle,
          ),
          content: Text(
            paymentRequired
                ? l10n.accountUnpaidBody
                : l10n.accountInactiveBody,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.close),
            ),
            FilledButton(
              key: const Key('contact_support_button'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                showSupportDialog(context, initialId: id);
              },
              child: Text(l10n.contactSupport),
            ),
          ],
        );
      },
    );
  }
}
