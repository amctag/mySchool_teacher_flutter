import 'package:equatable/equatable.dart';
import 'package:my_school_teacher/controllers/notifier_controller.dart';
import 'package:my_school_teacher/models/request_models.dart';
import 'package:my_school_teacher/models/teacher_class_summary.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';

enum AnnouncementComposerStatus {
  initial,
  loading,
  ready,
  submitting,
  success,
  failure,
}

class AnnouncementComposerState extends Equatable {
  const AnnouncementComposerState({
    this.status = AnnouncementComposerStatus.initial,
    this.classes = const [],
    this.message,
  });

  final AnnouncementComposerStatus status;
  final List<TeacherClassSummary> classes;
  final String? message;

  @override
  List<Object?> get props => [status, classes, message];
}

class AnnouncementComposerController
    extends NotifierController<AnnouncementComposerState> {
  AnnouncementComposerController({required TeacherRepository repository})
    : _repository = repository,
      super(const AnnouncementComposerState());

  final TeacherRepository _repository;

  Future<void> load() async {
    emit(
      const AnnouncementComposerState(status: AnnouncementComposerStatus.loading),
    );
    try {
      final account = await _repository.currentAccount();
      final classes = await _repository.assignedClasses();
      final supervised = account.supervisedClassIds.toSet();
      emit(
        AnnouncementComposerState(
          status: AnnouncementComposerStatus.ready,
          classes: classes
              .where((item) => supervised.contains(item.id))
              .toList(growable: false),
        ),
      );
    } catch (error) {
      emit(
        AnnouncementComposerState(
          status: AnnouncementComposerStatus.failure,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> submit(CreateAnnouncementRequest request) async {
    emit(
      AnnouncementComposerState(
        status: AnnouncementComposerStatus.submitting,
        classes: state.classes,
      ),
    );
    try {
      await _repository.createAnnouncement(request);
      emit(
        AnnouncementComposerState(
          status: AnnouncementComposerStatus.success,
          classes: state.classes,
        ),
      );
    } catch (error) {
      emit(
        AnnouncementComposerState(
          status: AnnouncementComposerStatus.failure,
          classes: state.classes,
          message: error.toString(),
        ),
      );
    }
  }
}
