import 'package:my_school_teacher/controllers/notifier_controller.dart';
import 'package:my_school_teacher/core/state/load_state.dart';
import 'package:my_school_teacher/models/class_details.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';

class ClassDetailsController extends NotifierController<LoadState<ClassDetails>> {
  ClassDetailsController({required TeacherRepository repository})
    : _repository = repository,
      super(const LoadState());

  final TeacherRepository _repository;

  Future<void> refresh(int classId) {
    _repository.clearReadCache();
    return load(classId);
  }

  Future<void> load(int classId) async {
    emit(LoadState.loading(previous: state.data));
    try {
      final details = await _repository.classDetails(classId);
      emit(LoadState.success(details));
    } catch (error) {
      emit(LoadState.failure(error.toString(), previous: state.data));
    }
  }
}
