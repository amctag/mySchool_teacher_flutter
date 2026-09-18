import 'package:equatable/equatable.dart';
import 'package:my_school_teacher/controllers/notifier_controller.dart';
import 'package:my_school_teacher/models/request_models.dart';
import 'package:my_school_teacher/models/teacher_assignment.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';

enum ActivityComposerStatus {
  initial,
  loading,
  ready,
  submitting,
  success,
  failure,
}

class ActivityComposerState extends Equatable {
  const ActivityComposerState({
    this.status = ActivityComposerStatus.initial,
    this.assignments = const [],
    this.message,
  });

  final ActivityComposerStatus status;
  final List<TeacherAssignment> assignments;
  final String? message;

  @override
  List<Object?> get props => [status, assignments, message];
}

class ActivityComposerController
    extends NotifierController<ActivityComposerState> {
  ActivityComposerController({required TeacherRepository repository})
    : _repository = repository,
      super(const ActivityComposerState());

  final TeacherRepository _repository;

  Future<void> load() async {
    emit(const ActivityComposerState(status: ActivityComposerStatus.loading));
    try {
      final assignments = await _repository.teachingAssignments();
      emit(
        ActivityComposerState(
          status: ActivityComposerStatus.ready,
          assignments: assignments,
        ),
      );
    } catch (error) {
      emit(
        ActivityComposerState(
          status: ActivityComposerStatus.failure,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> create(UpsertActivityRequest request) async {
    emit(
      ActivityComposerState(
        status: ActivityComposerStatus.submitting,
        assignments: state.assignments,
      ),
    );
    try {
      await _repository.createActivity(request);
      emit(
        ActivityComposerState(
          status: ActivityComposerStatus.success,
          assignments: state.assignments,
        ),
      );
    } catch (error) {
      emit(
        ActivityComposerState(
          status: ActivityComposerStatus.failure,
          assignments: state.assignments,
          message: error.toString(),
        ),
      );
    }
  }

  Future<String> uploadActivityMedia({
    required List<int> bytes,
    required String filename,
  }) {
    return _repository.uploadAgendaMedia(
      bytes: bytes,
      filename: filename,
      kind: 'image',
    );
  }
}
