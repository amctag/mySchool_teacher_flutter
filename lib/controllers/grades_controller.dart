import 'package:my_school_teacher/controllers/notifier_controller.dart';
import 'package:my_school_teacher/core/state/load_state.dart';
import 'package:my_school_teacher/models/grade_assessment.dart';
import 'package:my_school_teacher/models/grade_options.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';

class GradesController
    extends NotifierController<LoadState<List<GradeAssessmentSummary>>> {
  GradesController({
    required TeacherRepository repository,
    this.pageSize = 20,
  }) : _repository = repository,
       super(const LoadState());

  final TeacherRepository _repository;
  final int pageSize;
  GradeOptions _options = const GradeOptions(classes: [], gradeTypes: []);
  int? _classId;
  int? _sectionId;
  int? _courseId;
  int? _gradeTypeId;
  int _page = 0;
  int _totalPages = 0;
  int _total = 0;
  bool _loadingMore = false;
  int _loadSeq = 0;

  GradeOptions get options => _options;
  int? get selectedClassId => _classId;
  int? get selectedSectionId => _sectionId;
  int? get selectedCourseId => _courseId;
  int? get selectedGradeTypeId => _gradeTypeId;
  int get page => _page;
  int get totalPages => _totalPages;
  int get total => _total;
  bool get isLoadingMore => _loadingMore;
  bool get hasMore => _totalPages > 0 && _page < _totalPages;

  List<GradeSectionOption> get sections {
    final classId = _classId;
    if (classId == null) {
      return const [];
    }
    return _options.classes
        .where((item) => item.id == classId)
        .expand((item) => item.sections)
        .toList(growable: false);
  }

  List<GradeCourseOption> get courses {
    final sectionId = _sectionId;
    if (sectionId == null) {
      return const [];
    }
    return sections
        .where((item) => item.id == sectionId)
        .expand((item) => item.courses)
        .toList(growable: false);
  }

  Future<void> selectClass(int? classId) {
    _classId = classId;
    _sectionId = null;
    _courseId = null;
    return applyFilters();
  }

  Future<void> selectSection(int? sectionId) {
    _sectionId = sectionId;
    _courseId = null;
    return applyFilters();
  }

  Future<void> selectCourse(int? courseId) {
    _courseId = courseId;
    return applyFilters();
  }

  Future<void> selectGradeType(int? gradeTypeId) {
    _gradeTypeId = gradeTypeId;
    return applyFilters();
  }

  Future<void> refresh() {
    _repository.clearReadCache();
    return applyFilters();
  }

  Future<void> load() async {
    final seq = ++_loadSeq;
    emit(const LoadState.loading());
    try {
      _options = await _repository.gradeOptions();
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

  Future<void> applyFilters() {
    return _fetchPage(page: 1, replace: true);
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
      final result = await _repository.gradeAssessments(
        classId: _classId,
        sectionId: _sectionId,
        courseId: _courseId,
        gradeTypeId: _gradeTypeId,
        page: page,
        limit: pageSize,
      );
      if (requestSeq != _loadSeq) {
        return;
      }
      _page = result.page;
      _totalPages = result.totalPages;
      _total = result.total;
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
