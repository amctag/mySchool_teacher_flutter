import 'package:my_school_teacher/controllers/notifier_controller.dart';
import 'package:my_school_teacher/core/persistence/app_preferences.dart';
import 'package:my_school_teacher/core/state/load_state.dart';
import 'package:my_school_teacher/models/teacher_push_notification.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';

class NotificationsController
    extends NotifierController<LoadState<List<TeacherPushNotification>>> {
  NotificationsController({
    required TeacherRepository repository,
    required AppPreferences preferences,
    required int personId,
  }) : _repository = repository,
       _preferences = preferences,
       _personId = personId,
       _lastSeenId = preferences.lastSeenNotificationId(personId),
       super(const LoadState());

  final TeacherRepository _repository;
  final AppPreferences _preferences;
  final int _personId;
  int _lastSeenId;
  int _loadSeq = 0;

  int get unreadCount {
    final items = state.data;
    if (items == null || items.isEmpty) {
      return 0;
    }
    return items.where((item) => item.id > _lastSeenId).length;
  }

  Future<void> load({bool force = false, bool markAsSeen = false}) async {
    final seq = ++_loadSeq;
    emit(LoadState.loading(previous: state.data));
    try {
      final notifications = await _repository.notifications(force: force);
      if (seq != _loadSeq) {
        return;
      }
      emit(
        notifications.isEmpty
            ? const LoadState.empty()
            : LoadState.success(notifications),
      );
      if (markAsSeen) {
        await markAllAsSeen();
      }
    } catch (error) {
      if (seq != _loadSeq) {
        return;
      }
      emit(LoadState.failure(error.toString(), previous: state.data));
    }
  }

  Future<void> markAllAsSeen() async {
    final items = state.data ?? const <TeacherPushNotification>[];
    final maxId = items.fold<int>(
      _lastSeenId,
      (current, item) => item.id > current ? item.id : current,
    );
    if (maxId == _lastSeenId && unreadCount == 0) {
      return;
    }
    _lastSeenId = maxId;
    await _preferences.saveLastSeenNotificationId(_personId, maxId);
    notifyListeners();
  }
}
