import 'package:my_school_teacher/controllers/notifier_controller.dart';
import 'package:my_school_teacher/core/state/load_state.dart';
import 'package:my_school_teacher/models/teacher_class_summary.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';

class AllClassSchedulesController
    extends NotifierController<LoadState<List<TeacherClassSummary>>> {
  AllClassSchedulesController({required TeacherRepository repository})
    : _repository = repository,
      super(const LoadState());

  final TeacherRepository _repository;

  Future<void> refresh() {
    _repository.clearReadCache();
    return load();
  }

  Future<void> load() async {
    emit(LoadState.loading(previous: state.data));
    try {
      final classes = await _repository.allClassSchedules();
      emit(classes.isEmpty ? const LoadState.empty() : LoadState.success(classes));
    } catch (error) {
      emit(LoadState.failure(error.toString(), previous: state.data));
    }
  }
}
