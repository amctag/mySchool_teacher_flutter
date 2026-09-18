import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';

typedef AgendaCalendarViewState = ({
  DateTime month,
  DateTime? selectedDate,
  Set<DateTime> activityDates,
});

class AgendaMonthCalendar extends StatelessWidget {
  const AgendaMonthCalendar({
    super.key,
    required this.calendar,
    required this.onDateSelected,
    required this.onMonthChanged,
  });

  final AgendaCalendarViewState calendar;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<DateTime> onMonthChanged;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final month = calendar.month;
    final firstDayIndex = localizations.firstDayOfWeekIndex;
    final weekdays = [
      ...localizations.narrowWeekdays.skip(firstDayIndex),
      ...localizations.narrowWeekdays.take(firstDayIndex),
    ];
    final firstDayOffset = DateUtils.firstDayOffset(
      month.year,
      month.month,
      localizations,
    );
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final populatedCells = firstDayOffset + daysInMonth;
    final calendarCells = ((populatedCells + 6) ~/ 7) * 7;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 6),
          child: Row(
            children: [
              IconButton.filledTonal(
                key: const Key('agenda_previous_month'),
                tooltip: context.l10n.previousMonth,
                onPressed: () =>
                    onMonthChanged(DateTime(month.year, month.month - 1)),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Expanded(
                child: Text(
                  DateFormat.yMMMM(
                    Localizations.localeOf(context).toString(),
                  ).format(month),
                  textAlign: TextAlign.center,
                  style: context.textStyles.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton.filledTonal(
                key: const Key('agenda_next_month'),
                tooltip: context.l10n.nextMonth,
                onPressed: () =>
                    onMonthChanged(DateTime(month.year, month.month + 1)),
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
        ),
        Row(
          children: [
            for (final weekday in weekdays)
              Expanded(
                child: Center(
                  child: Text(
                    weekday,
                    style: context.textStyles.labelSmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisExtent: 44,
          ),
          itemCount: calendarCells,
          itemBuilder: (context, index) {
            if (index < firstDayOffset || index >= populatedCells) {
              return const SizedBox.shrink();
            }
            final day = index - firstDayOffset + 1;
            final date = DateTime(month.year, month.month, day);
            return _AgendaCalendarDay(
              date: date,
              isSelected: DateUtils.isSameDay(date, calendar.selectedDate),
              isToday: DateUtils.isSameDay(date, DateTime.now()),
              hasActivity: calendar.activityDates.contains(date),
              onTap: () => onDateSelected(date),
            );
          },
        ),
      ],
    );
  }
}

class _AgendaCalendarDay extends StatelessWidget {
  const _AgendaCalendarDay({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.hasActivity,
    required this.onTap,
  });

  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final bool hasActivity;
  final VoidCallback onTap;

  String get _dateKey {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final description = DateFormat.yMMMMEEEEd(locale).format(date);
    final semanticParts = [
      description,
      if (isToday) context.l10n.today,
      if (hasActivity) context.l10n.agendaAvailable,
    ];
    final foreground = isSelected
        ? context.colors.onPrimary
        : context.colors.onSurface;

    return Semantics(
      button: true,
      selected: isSelected,
      label: semanticParts.join(', '),
      child: InkWell(
        key: Key('agenda_day_$_dateKey'),
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isSelected ? context.colors.primary : null,
              shape: BoxShape.circle,
              border: isToday && !isSelected
                  ? Border.all(color: context.colors.primary, width: 1.5)
                  : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '${date.day}',
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  style: context.textStyles.labelLarge?.copyWith(
                    color: foreground,
                    height: 1,
                    fontWeight: isSelected || isToday
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
                if (hasActivity)
                  Positioned(
                    bottom: 3,
                    child: Container(
                      key: Key('agenda_marker_$_dateKey'),
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? context.colors.onPrimary
                            : context.colors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
