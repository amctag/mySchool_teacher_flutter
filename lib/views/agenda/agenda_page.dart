import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/core/navigation/app_navigator.dart';
import 'package:my_school_teacher/core/state/load_state.dart';
import 'package:my_school_teacher/models/teacher_agenda_item.dart';
import 'package:my_school_teacher/controllers/agenda_controller.dart';
import 'package:my_school_teacher/views/agenda/agenda_month_calendar.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/section_card.dart';
import 'package:my_school_teacher/views/widgets/state_views.dart';
import 'package:my_school_teacher/views/widgets/status_badge.dart';

class AgendaPage extends StatelessWidget {
  const AgendaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrandAppBar(
        title: context.l10n.agenda,
        trailing: HeaderAction(
          tooltip: context.l10n.addAgenda,
          icon: Icons.add_rounded,
          onPressed: () => _openEditor(context),
        ),
      ),
      body: Consumer<AgendaController>(
        builder: (context, controller, _) {
          final state = controller.state;
          final items = state.data;
          return RefreshIndicator(
            onRefresh: controller.refresh,
            child: ListView(
              key: const Key('agenda_list'),
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
              children: [
                if (items == null && state.isLoading)
                  const SizedBox(height: 240, child: LoadingView())
                else if (items == null && state.status == LoadStatus.failure)
                  SizedBox(
                    height: 240,
                    child: ErrorView(onRetry: controller.load),
                  )
                else ...[
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      FilterChip(
                        key: const Key('agenda_filter_today'),
                        selected: controller.isTodaySelected,
                        label: Text(context.l10n.today),
                        onSelected: (_) {
                          controller.selectDate(
                            DateUtils.dateOnly(DateTime.now()),
                          );
                        },
                      ),
                      FilterChip(
                        key: const Key('agenda_filter_all'),
                        selected: controller.selectedDate == null,
                        label: Text(context.l10n.showAll),
                        onSelected: (_) => controller.selectDate(null),
                      ),
                    ],
                  ),
                  if (!controller.isTodaySelected) ...[
                    const SizedBox(height: 8),
                    SectionCard(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                      child: AgendaMonthCalendar(
                        calendar: (
                          month: controller.visibleMonth,
                          selectedDate: controller.selectedDate,
                          activityDates: controller.activityDates,
                        ),
                        onDateSelected: controller.toggleDate,
                        onMonthChanged: controller.showMonth,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  ..._buildItemList(
                    context,
                    items ?? const [],
                    hasDateFilter: controller.selectedDate != null,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildItemList(
    BuildContext context,
    List<TeacherAgendaItem> items, {
    required bool hasDateFilter,
  }) {
    if (items.isEmpty) {
      return [
        SizedBox(
          height: 180,
          child: EmptyView(
            icon: hasDateFilter
                ? Icons.event_busy_outlined
                : Icons.edit_note_rounded,
            message: hasDateFilter
                ? context.l10n.noAgenda
                : context.l10n.noAgendaItems,
          ),
        ),
      ];
    }

    final sorted = [...items]..sort((a, b) => b.date.compareTo(a.date));

    return [
      for (var i = 0; i < sorted.length; i++) ...[
        if (i == 0 || !DateUtils.isSameDay(sorted[i].date, sorted[i - 1].date)) ...[
          if (i > 0) const SizedBox(height: 4),
          Text(
            DateFormat.yMMMMEEEEd(
              Localizations.localeOf(context).toString(),
            ).format(sorted[i].date),
            style: context.textStyles.labelLarge?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
        ] else
          const SizedBox(height: 8),
        _AgendaCard(item: sorted[i]),
      ],
    ];
  }

  Future<void> _openEditor(BuildContext context) async {
    await AppNavigator.agendaEditor(context);
    if (context.mounted) {
      await context.read<AgendaController>().load();
    }
  }
}

class _AgendaCard extends StatelessWidget {
  const _AgendaCard({required this.item});

  final TeacherAgendaItem item;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return SectionCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        key: ValueKey(item.id),
        borderRadius: BorderRadius.circular(14),
        onTap: () async {
          await AppNavigator.agendaDetails(context, item);
          if (context.mounted) {
            await context.read<AgendaController>().load();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DateBadge(date: item.date, locale: locale),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: context.textStyles.titleMedium,
                          ),
                        ),
                        const SizedBox(width: 8),
                        StatusBadge(
                          label: item.published
                              ? context.l10n.published
                              : context.l10n.draft,
                          icon: item.published
                              ? Icons.public_outlined
                              : Icons.lock_outline_rounded,
                          color: item.published
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFF9A825),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.classLabel} · ${item.courseTitle}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateBadge extends StatelessWidget {
  const _DateBadge({required this.date, required this.locale});

  final DateTime date;
  final String locale;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: DateFormat.yMMMMd(locale).format(date),
      child: Container(
        width: 52,
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: context.colors.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              DateFormat.d(locale).format(date),
              style: context.textStyles.titleLarge?.copyWith(
                color: context.colors.primary,
              ),
            ),
            Text(
              DateFormat.MMM(locale).format(date).toUpperCase(),
              style: context.textStyles.labelSmall?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
