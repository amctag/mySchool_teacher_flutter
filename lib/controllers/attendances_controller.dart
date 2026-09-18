import 'package:my_school_teacher/controllers/notifier_controller.dart';
import 'package:my_school_teacher/core/state/load_state.dart';
import 'package:my_school_teacher/models/teacher_attendance.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';

class AttendancesController
    extends NotifierController<LoadState<List<TeacherAttendanceListItem>>> {
  AttendancesController({
    required TeacherRepository repository,
    this.pageSize = 20,
  }) : _repository = repository,
       super(const LoadState());

  final TeacherRepository _repository;
  final int pageSize;
  TeacherAttendanceOptions _options = TeacherAttendanceOptions.empty;
  DateTime _date = DateTime.now();
  int _page = 0;
  int _totalPages = 0;
  bool _loadingMore = false;
  int _loadSeq = 0;

  TeacherAttendanceOptions get options => _options;
  DateTime get selectedDate => _date;
  bool get isLoadingMore => _loadingMore;
  bool get hasMore => _totalPages > 0 && _page < _totalPages;

  Future<void> selectDate(DateTime date) {
    _date = DateTime(date.year, date.month, date.day);
    return load();
  }

  Future<void> refresh() {
    _repository.clearReadCache();
    return load();
  }

  Future<void> load() async {
    final seq = ++_loadSeq;
    emit(const LoadState.loading());
    try {
      _options = await _repository.attendanceOptions(date: _date);
      if (seq != _loadSeq) {
        return;
      }
      await _fetchPage(page: 1, replace: true, seq: seq);
    } catch (error) {
      if (seq != _loadSeq) {
        return;
      }
      emit(LoadState.failure(error.toString()));
    }
  }

  Future<void> loadMore() async {
    if (!hasMore || _loadingMore || state.isLoading) {
      return;
    }
    await _fetchPage(page: _page + 1, replace: false);
  }

  Future<void> _fetchPage({
    required int page,
    required bool replace,
    int? seq,
  }) async {
    final requestSeq = seq ?? ++_loadSeq;
    if (replace) {
      emit(LoadState.loading(previous: state.data));
    } else {
      _loadingMore = true;
      notifyListeners();
    }
    try {
      final result = await _repository.attendances(
        date: _date,
        page: page,
        limit: pageSize,
      );
      if (requestSeq != _loadSeq) {
        return;
      }
      _page = result.page;
      _totalPages = result.totalPages;
      final items = replace
          ? result.items
          : [...?state.data, ...result.items];
      emit(
        items.isEmpty ? const LoadState.empty() : LoadState.success(items),
      );
    } catch (error) {
      if (requestSeq != _loadSeq) {
        return;
      }
      emit(LoadState.failure(error.toString(), previous: state.data));
    } finally {
      _loadingMore = false;
    }
  }
}
