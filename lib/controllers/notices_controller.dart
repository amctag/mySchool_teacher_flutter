import 'package:my_school_teacher/controllers/notifier_controller.dart';
import 'package:my_school_teacher/core/state/load_state.dart';
import 'package:my_school_teacher/models/teacher_notice.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';

class NoticesController extends NotifierController<LoadState<List<TeacherNotice>>> {
  NoticesController({required TeacherRepository repository})
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
      final items = await _repository.notices();
      emit(items.isEmpty ? const LoadState.empty() : LoadState.success(items));
    } catch (error) {
      emit(LoadState.failure(error.toString(), previous: state.data));
    }
  }
}
