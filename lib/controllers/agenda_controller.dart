import 'package:my_school_teacher/controllers/notifier_controller.dart';
import 'package:my_school_teacher/core/state/load_state.dart';
import 'package:my_school_teacher/models/teacher_agenda_item.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';

class AgendaController
    extends NotifierController<LoadState<List<TeacherAgendaItem>>> {
  AgendaController({required TeacherRepository repository})
    : _repository = repository,
      _selectedDate = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      _visibleMonth = DateTime(DateTime.now().year, DateTime.now().month),
      super(const LoadState());

  final TeacherRepository _repository;
  DateTime? _selectedDate;
  DateTime _visibleMonth;
  Set<DateTime> _activityDates = {};
  bool teachersCanPublishAgenda = true;

  DateTime? get selectedDate => _selectedDate;
  DateTime get visibleMonth => _visibleMonth;
  Set<DateTime> get activityDates => _activityDates;

  bool get isTodaySelected {
    final selected = _selectedDate;
    if (selected == null) {
      return false;
    }
    return _isSameDay(selected, DateTime.now());
  }

  Future<void> selectDate(DateTime? date) {
    _selectedDate = date == null ? null : _dateOnly(date);
    if (_selectedDate != null) {
      _visibleMonth = DateTime(_selectedDate!.year, _selectedDate!.month);
    }
    return load();
  }

  Future<void> toggleDate(DateTime date) {
    final next = _selectedDate != null && _isSameDay(_selectedDate!, date)
        ? null
        : _dateOnly(date);
    return selectDate(next);
  }

  Future<void> showMonth(DateTime month) {
    _visibleMonth = DateTime(month.year, month.month);
    return load();
  }

  Future<void> refresh() {
    _repository.clearReadCache();
    return load();
  }

  Future<void> load() async {
    emit(LoadState.loading(previous: state.data));
    try {
      final items = await _repository.agendaItems(date: _selectedDate);
      try {
        final monthItems = await _repository.agendaItems(month: _visibleMonth);
        _activityDates = {
          for (final item in monthItems) _dateOnly(item.date),
        };
      } catch (_) {
        if (_selectedDate == null) {
          _activityDates = {
            for (final item in items) _dateOnly(item.date),
          };
        }
      }
      teachersCanPublishAgenda = _repository.teachersCanPublishAgenda;
      emit(LoadState.success(items));
    } catch (error) {
      emit(LoadState.failure(error.toString(), previous: state.data));
    }
  }

  DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
