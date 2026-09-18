import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_school_teacher/controllers/contact_action_controller.dart';
import 'package:my_school_teacher/controllers/support_schools_controller.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/core/services/external_link_service.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';
import 'package:my_school_teacher/views/auth/widgets/support_school_view.dart';
import 'package:my_school_teacher/views/widgets/state_views.dart';
import 'package:provider/provider.dart';

Future<void> showSupportDialog(
  BuildContext context, {
  String? initialId,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => SupportDialog(
      repository: context.read<TeacherRepository>(),
      externalLinkService: context.read<ExternalLinkService>(),
      initialId: initialId,
    ),
  );
}

class SupportDialog extends StatefulWidget {
  const SupportDialog({
    super.key,
    required this.repository,
    required this.externalLinkService,
    this.initialId,
  });

  final TeacherRepository repository;
  final ExternalLinkService externalLinkService;
  final String? initialId;

  @override
  State<SupportDialog> createState() => _SupportDialogState();
}

class _SupportDialogState extends State<SupportDialog> {
  late final TextEditingController _idController;
  int? _lookupPersonId;
  String? _idError;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.initialId ?? '');
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  void _submitId() {
    final raw = _idController.text.trim();
    final personId = int.tryParse(raw);
    if (personId == null || personId < 1) {
      setState(() {
        _idError = context.l10n.supportIdRequired;
      });
      return;
    }
    setState(() {
      _idError = null;
      _lookupPersonId = personId;
    });
  }

  void _resetLookup() {
    setState(() => _lookupPersonId = null);
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.85;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 480, maxHeight: maxHeight),
        child: _lookupPersonId == null
            ? _SupportIdForm(
                idController: _idController,
                idError: _idError,
                onSubmit: _submitId,
              )
            : MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (_) => SupportSchoolsController(
                      repository: widget.repository,
                      personId: _lookupPersonId!,
                    )..load(),
                  ),
                  ChangeNotifierProvider(
                    create: (_) => ContactActionController(
                      externalLinkService: widget.externalLinkService,
                    ),
                  ),
                ],
                child: _SupportLookupResults(onBack: _resetLookup),
              ),
      ),
    );
  }
}

class _SupportIdForm extends StatelessWidget {
  const _SupportIdForm({
    required this.idController,
    required this.idError,
    required this.onSubmit,
  });

  final TextEditingController idController;
  final String? idError;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.support,
                  style: context.textStyles.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.supportSubtitle,
            style: context.textStyles.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            key: const Key('support_id'),
            controller: idController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onSubmitted: (_) => onSubmit(),
            decoration: InputDecoration(
              labelText: context.l10n.supportId,
              prefixIcon: const Icon(Icons.badge_outlined),
              errorText: idError,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            key: const Key('support_submit'),
            onPressed: onSubmit,
            child: Text(context.l10n.supportLookup),
          ),
        ],
      ),
    );
  }
}

class _SupportLookupResults extends StatefulWidget {
  const _SupportLookupResults({required this.onBack});

  final VoidCallback onBack;

  @override
  State<_SupportLookupResults> createState() => _SupportLookupResultsState();
}

class _SupportLookupResultsState extends State<_SupportLookupResults> {
  ContactActionController? _contactController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = context.read<ContactActionController>();
    if (!identical(_contactController, controller)) {
      _contactController?.removeListener(_onContactAction);
      _contactController = controller;
      _contactController?.addListener(_onContactAction);
    }
  }

  @override
  void dispose() {
    _contactController?.removeListener(_onContactAction);
    super.dispose();
  }

  void _onContactAction() {
    final action = _contactController?.state;
    if (action == null || !mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(context.l10n.openContactFailed)),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 4, 0),
          child: Row(
            children: [
              IconButton(
                key: const Key('support_back'),
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              Expanded(
                child: Text(
                  context.l10n.support,
                  style: context.textStyles.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
        ),
        Expanded(
          child: Consumer<SupportSchoolsController>(
            builder: (context, controller, _) {
              final state = controller.state;
              if (state.schools.isEmpty && state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == SupportLoadStatus.empty) {
                return EmptyView(
                  icon: Icons.school_outlined,
                  message: context.l10n.supportNoSchools,
                );
              }
              if (state.status == SupportLoadStatus.failure ||
                  state.schools.isEmpty) {
                return ErrorView(
                  message: state.message ?? context.l10n.supportLoadFailed,
                  onRetry: controller.load,
                );
              }
              return SupportSchoolContent(
                schools: state.schools,
                compact: true,
              );
            },
          ),
        ),
      ],
    );
  }
}

