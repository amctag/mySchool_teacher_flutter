import 'package:my_school_teacher/controllers/notifier_controller.dart';
import 'package:my_school_teacher/core/state/load_state.dart';
import 'package:my_school_teacher/models/grade_options.dart';
import 'package:my_school_teacher/models/teacher_announcement.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';

class AnnouncementsController
    extends NotifierController<LoadState<List<TeacherAnnouncement>>> {
  AnnouncementsController({required TeacherRepository repository})
    : _repository = repository,
      super(const LoadState());

  final TeacherRepository _repository;
  GradeOptions _options = const GradeOptions(classes: [], gradeTypes: []);
  int? _classId;
  int? _sectionId;
  int _loadSeq = 0;

  GradeOptions get options => _options;
  int? get selectedClassId => _classId;
  int? get selectedSectionId => _sectionId;

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

  void selectClass(int? classId) {
    _classId = classId;
    _sectionId = null;
    notifyListeners();
  }

  void selectSection(int? sectionId) {
    _sectionId = sectionId;
    notifyListeners();
  }

  Future<void> refresh() {
    _repository.clearReadCache();
    return applyFilters();
  }

  Future<void> applyFilters() => load(reloadOptions: false);

  Future<void> load({bool reloadOptions = true}) async {
    final seq = ++_loadSeq;
    emit(LoadState.loading(previous: state.data));
    try {
      if (reloadOptions) {
        _options = await _repository.gradeOptions();
      }
      final items = await _repository.announcements(
        classId: _classId,
        sectionId: _sectionId,
      );
      if (seq != _loadSeq) {
        return;
      }
      emit(items.isEmpty ? const LoadState.empty() : LoadState.success(items));
    } catch (error) {
      if (seq != _loadSeq) {
        return;
      }
      emit(LoadState.failure(error.toString(), previous: state.data));
    }
  }
}
