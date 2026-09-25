import 'package:my_school_teacher/controllers/notifier_controller.dart';
import 'package:my_school_teacher/core/state/load_state.dart';
import 'package:my_school_teacher/models/teacher_task.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';

class TasksController extends NotifierController<LoadState<List<TeacherTask>>> {
  TasksController({required TeacherRepository repository})
    : _repository = repository,
      super(const LoadState());

  final TeacherRepository _repository;
  int _loadSeq = 0;
  final Set<int> _completingIds = {};

  bool isCompleting(int taskId) => _completingIds.contains(taskId);

  int get openCount {
    final items = state.data;
    if (items == null) return 0;
    return items.where((task) => !task.isCompleted).length;
  }

  List<TeacherTask> get openTasks {
    final items = state.data;
    if (items == null) return const [];
    return items.where((task) => !task.isCompleted).toList(growable: false);
  }

  Future<void> load({bool force = false}) async {
    final seq = ++_loadSeq;
    emit(LoadState.loading(previous: state.data));
    try {
      if (force) {
        _repository.clearReadCache();
      }
      final tasks = await _repository.tasks(force: force);
      if (seq != _loadSeq) {
        return;
      }
      emit(
        tasks.isEmpty
            ? const LoadState.empty()
            : LoadState.success(tasks),
      );
    } catch (error) {
      if (seq != _loadSeq) {
        return;
      }
      emit(LoadState.failure(error.toString(), previous: state.data));
    }
  }

  Future<void> markDone(int taskId) async {
    if (_completingIds.contains(taskId)) {
      return;
    }
    _completingIds.add(taskId);
    notifyListeners();
    try {
      final updated = await _repository.completeTask(taskId);
      final current = state.data;
      if (current == null) {
        await load(force: true);
        return;
      }
      final next = current
          .map((task) => task.id == updated.id ? updated : task)
          .toList(growable: false);
      emit(LoadState.success(next));
    } finally {
      _completingIds.remove(taskId);
      notifyListeners();
    }
  }
}
