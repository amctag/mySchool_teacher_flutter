import 'package:equatable/equatable.dart';
import 'package:my_school_teacher/controllers/notifier_controller.dart';
import 'package:my_school_teacher/models/request_models.dart';
import 'package:my_school_teacher/models/teacher_assignment.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';

enum AgendaComposerStatus { initial, loading, ready, submitting, success, failure }

class AgendaComposerState extends Equatable {
  const AgendaComposerState({
    this.status = AgendaComposerStatus.initial,
    this.assignments = const [],
    this.message,
  });

  final AgendaComposerStatus status;
  final List<TeacherAssignment> assignments;
  final String? message;

  @override
  List<Object?> get props => [status, assignments, message];
}

class AgendaComposerController extends NotifierController<AgendaComposerState> {
  AgendaComposerController({required TeacherRepository repository})
    : _repository = repository,
      super(const AgendaComposerState());

  final TeacherRepository _repository;

  Future<void> load() async {
    emit(const AgendaComposerState(status: AgendaComposerStatus.loading));
    try {
      final assignments = await _repository.teachingAssignments();
      emit(
        AgendaComposerState(
          status: AgendaComposerStatus.ready,
          assignments: assignments,
        ),
      );
    } catch (error) {
      emit(
        AgendaComposerState(
          status: AgendaComposerStatus.failure,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> create(UpsertAgendaRequest request) async {
    await _submit(() => _repository.createAgenda(request));
  }

  Future<String> uploadAgendaMedia({
    required List<int> bytes,
    required String filename,
    required String kind,
  }) {
    return _repository.uploadAgendaMedia(
      bytes: bytes,
      filename: filename,
      kind: kind,
    );
  }

  Future<void> publish(int agendaId) async {
    await _submit(() => _repository.publishAgenda(agendaId));
  }

  Future<void> update(int agendaId, UpsertAgendaRequest request) async {
    await _submit(() => _repository.updateAgenda(agendaId, request));
  }

  Future<void> delete(int agendaId) async {
    await _submit(() => _repository.deleteAgenda(agendaId));
  }

  Future<void> _submit(Future<void> Function() action) async {
    emit(
      AgendaComposerState(
        status: AgendaComposerStatus.submitting,
        assignments: state.assignments,
      ),
    );
    try {
      await action();
      emit(
        AgendaComposerState(
          status: AgendaComposerStatus.success,
          assignments: state.assignments,
        ),
      );
    } catch (error) {
      emit(
        AgendaComposerState(
          status: AgendaComposerStatus.failure,
          assignments: state.assignments,
          message: error.toString(),
        ),
      );
    }
  }
}
