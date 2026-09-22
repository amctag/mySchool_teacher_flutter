import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_school_teacher/core/widgets/controller_consumer.dart';
import 'package:provider/provider.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/core/navigation/app_navigator.dart';
import 'package:my_school_teacher/core/state/load_state.dart';
import 'package:my_school_teacher/models/teacher_announcement.dart';
import 'package:my_school_teacher/controllers/announcements_controller.dart';
import 'package:my_school_teacher/controllers/auth_controller.dart';
import 'package:my_school_teacher/views/widgets/app_select_field.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/section_card.dart';
import 'package:my_school_teacher/views/widgets/state_views.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openFilterDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void _closeFilterDrawer() {
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final isSupervisor =
        context.watch<AuthController>().state.account?.isSupervisor ?? false;
    final filterDrawer = _AnnouncementsFilterDrawer(
      onApply: () async {
        await context.read<AnnouncementsController>().applyFilters();
        if (context.mounted) {
          _closeFilterDrawer();
        }
      },
    );
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: filterDrawer,
      appBar: BrandAppBar(
        title: context.l10n.announcements,
        trailing: isSupervisor
            ? HeaderAction(
                tooltip: context.l10n.addAnnouncement,
                icon: Icons.add_rounded,
                onPressed: () async {
                  final saved = await AppNavigator.announcementEditor(context);
                  if (saved && context.mounted) {
                    await context.read<AnnouncementsController>().refresh();
                  }
                },
              )
            : null,
      ),
      body: ControllerConsumer<
        AnnouncementsController,
        LoadState<List<TeacherAnnouncement>>
      >(
        builder: (context, state) {
          final controller = context.watch<AnnouncementsController>();
          final items = state.data;
          return RefreshIndicator(
            onRefresh: controller.refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: OutlinedButton.icon(
                    key: const Key('announcements_filter_button'),
                    onPressed: controller.options.classes.isEmpty
                        ? null
                        : _openFilterDrawer,
                    icon: const Icon(Icons.filter_list_rounded),
                    label: Text(context.l10n.filters),
                  ),
                ),
                const SizedBox(height: 16),
                if (items == null && state.isLoading)
                  const SizedBox(height: 240, child: LoadingView())
                else if (items == null && state.status == LoadStatus.failure)
                  SizedBox(
                    height: 240,
                    child: ErrorView(onRetry: controller.load),
                  )
                else if (items == null || items.isEmpty)
                  SizedBox(
                    height: 180,
                    child: EmptyView(
                      icon: Icons.campaign_outlined,
                      message: context.l10n.noAnnouncements,
                    ),
                  )
                else
                  for (final announcement in items) ...[
                    _AnnouncementCard(announcement: announcement),
                    if (announcement != items.last) const SizedBox(height: 12),
                  ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AnnouncementsFilterDrawer extends StatelessWidget {
  const _AnnouncementsFilterDrawer({required this.onApply});

  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AnnouncementsController>();
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
                key: const Key('announcements-filter-class'),
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
                key: const Key('announcements-filter-section'),
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
              const Spacer(),
              FilledButton(
                key: const Key('announcements_load_button'),
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

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({required this.announcement});

  final TeacherAnnouncement announcement;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(announcement.title, style: context.textStyles.titleMedium),
          const SizedBox(height: 4),
          Text(
            announcement.scopeLabel,
            style: context.textStyles.bodySmall?.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(announcement.content, style: context.textStyles.bodyMedium),
          const SizedBox(height: 8),
          Text(
            DateFormat.yMMMd().format(announcement.publishedAt),
            style: context.textStyles.labelSmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
