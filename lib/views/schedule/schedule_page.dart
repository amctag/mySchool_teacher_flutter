import 'package:flutter/material.dart';
import 'package:my_school_teacher/core/widgets/controller_consumer.dart';
import 'package:provider/provider.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/core/state/load_state.dart';
import 'package:my_school_teacher/models/teacher_schedule.dart';
import 'package:my_school_teacher/controllers/schedule_controller.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/state_views.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrandAppBar(title: context.l10n.mySchedule),
      body: ControllerConsumer<ScheduleController, LoadState<TeacherSchedule>>(
        builder: (context, state) {
          final schedule = state.data;
          return RefreshIndicator(
            onRefresh: context.read<ScheduleController>().refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              children: [
                if (schedule == null && state.isLoading)
                  const SizedBox(height: 300, child: LoadingView())
                else if (schedule == null && state.status == LoadStatus.failure)
                  SizedBox(
                    height: 300,
                    child: ErrorView(
                      onRetry: context.read<ScheduleController>().load,
                    ),
                  )
                else if (schedule == null || !_hasLessons(schedule))
                  SizedBox(
                    height: 180,
                    child: EmptyView(
                      icon: Icons.calendar_view_week_rounded,
                      message: context.l10n.noSchedule,
                    ),
                  )
                else
                  _ScheduleTable(schedule: schedule),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _hasLessons(TeacherSchedule schedule) {
    return schedule.days.any((day) => day.entries.isNotEmpty);
  }
}

class _ScheduleTable extends StatelessWidget {
  const _ScheduleTable({required this.schedule});

  final TeacherSchedule schedule;

  static const _weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  Widget build(BuildContext context) {
    const periodWidth = 36.0;
    const cellWidth = 92.0;
    final orderedDays = _orderedDays();
    final periodCount = _maxPeriods(schedule);
    final borderColor = context.colors.outlineVariant;
    final headingStyle = context.textStyles.labelSmall?.copyWith(
      fontWeight: FontWeight.w700,
    );
    final headerBg = context.colors.primaryContainer;

    TableRow headerRow() {
      return TableRow(
        decoration: BoxDecoration(color: headerBg),
        children: [
          _HeaderCell(
            width: periodWidth,
            child: Text('*', textAlign: TextAlign.center, style: headingStyle),
          ),
          for (final day in orderedDays)
            _HeaderCell(
              width: cellWidth,
              child: Text(
                _shortDayName(day.dayName),
                textAlign: TextAlign.center,
                style: headingStyle,
              ),
            ),
        ],
      );
    }

    return Scrollbar(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 4),
        scrollDirection: Axis.horizontal,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Table(
            border: TableBorder.all(color: borderColor, width: 1),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: {
              0: const FixedColumnWidth(periodWidth),
              for (var i = 0; i < orderedDays.length; i++)
                i + 1: const FixedColumnWidth(cellWidth),
            },
            children: [
              headerRow(),
              for (var index = 0; index < periodCount; index++)
                TableRow(
                  children: [
                    _BodyCell(
                      child: Text(
                        '${index + 1}',
                        textAlign: TextAlign.center,
                        style: context.textStyles.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    for (final day in orderedDays)
                      _BodyCell(
                        child: _PeriodCell(
                          entries: _entriesAtPosition(day, index + 1),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<TeacherScheduleDay> _orderedDays() {
    final daysByName = {
      for (final day in schedule.days) day.dayName.trim().toLowerCase(): day,
    };
    return [
      for (var index = 0; index < _weekDays.length; index++)
        daysByName[_weekDays[index].toLowerCase()] ??
            TeacherScheduleDay(
              dayName: _weekDays[index],
              position: index + 1,
              entries: const [],
            ),
    ];
  }

  int _maxPeriods(TeacherSchedule schedule) {
    final loadedPeriods = schedule.days.expand((day) => day.entries).fold(0, (
      maximum,
      entry,
    ) {
      return entry.periodNumber > maximum ? entry.periodNumber : maximum;
    });
    return loadedPeriods < 7 ? 7 : loadedPeriods;
  }

  List<TeacherScheduleEntry> _entriesAtPosition(
    TeacherScheduleDay day,
    int position,
  ) {
    for (final entry in day.entries) {
      if (entry.periodNumber == position) {
        return [entry];
      }
    }
    return const [];
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: child,
      ),
    );
  }
}

class _BodyCell extends StatelessWidget {
  const _BodyCell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: child,
    );
  }
}

String _shortDayName(String dayName) {
  final trimmed = dayName.trim();
  if (trimmed.isEmpty) {
    return trimmed;
  }
  final short = trimmed.length <= 3
      ? trimmed
      : trimmed.substring(0, 3);
  return '${short[0].toUpperCase()}${short.substring(1).toLowerCase()}';
}

String _compactClassSectionLabel(String label) {
  return label
      .replaceAll(RegExp(r'\s*-\s*Section\s+', caseSensitive: false), ' / ')
      .replaceAll(RegExp(r'\s*-\s*شعبة\s+'), ' / ')
      .replaceAll(RegExp(r'\s+Section\s+', caseSensitive: false), ' / ')
      .replaceAll(RegExp(r'\s+شعبة\s+'), ' / ')
      .trim();
}

class _PeriodCell extends StatelessWidget {
  const _PeriodCell({required this.entries});

  final List<TeacherScheduleEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const SizedBox(height: 36);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var index = 0; index < entries.length; index++) ...[
          if (index > 0) const SizedBox(height: 6),
          Text(
            entries[index].courseTitle,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.labelMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          if (entries[index].classLabel.isNotEmpty) ...[
            const SizedBox(height: 1),
            Text(
              _compactClassSectionLabel(entries[index].classLabel),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.labelSmall?.copyWith(
                color: context.colors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ],
    );
  }
}
