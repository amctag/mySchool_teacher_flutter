import 'package:equatable/equatable.dart';
import 'package:my_school_teacher/controllers/notifier_controller.dart';
import 'package:my_school_teacher/models/class_details.dart';
import 'package:my_school_teacher/models/request_models.dart';
import 'package:my_school_teacher/models/teacher_class_summary.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';

enum NoticeComposerStatus { initial, loading, ready, submitting, success, failure }

class NoticeComposerState extends Equatable {
  const NoticeComposerState({
    this.status = NoticeComposerStatus.initial,
    this.assignedClasses = const [],
    this.studentsByClass = const {},
    this.studentsLoadingClassId,
    this.message,
  });

  final NoticeComposerStatus status;
  final List<TeacherClassSummary> assignedClasses;
  final Map<int, List<StudentSummary>> studentsByClass;
  final int? studentsLoadingClassId;
  final String? message;

  bool isLoadingStudents(int? classId) =>
      classId != null && studentsLoadingClassId == classId;

  NoticeComposerState copyWith({
    NoticeComposerStatus? status,
    List<TeacherClassSummary>? assignedClasses,
    Map<int, List<StudentSummary>>? studentsByClass,
    int? studentsLoadingClassId,
    bool clearStudentsLoading = false,
    String? message,
    bool clearMessage = false,
  }) {
    return NoticeComposerState(
      status: status ?? this.status,
      assignedClasses: assignedClasses ?? this.assignedClasses,
      studentsByClass: studentsByClass ?? this.studentsByClass,
      studentsLoadingClassId: clearStudentsLoading
          ? null
          : (studentsLoadingClassId ?? this.studentsLoadingClassId),
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [
    status,
    assignedClasses,
    studentsByClass,
    studentsLoadingClassId,
    message,
  ];
}

class NoticeComposerController extends NotifierController<NoticeComposerState> {
  NoticeComposerController({required TeacherRepository repository})
    : _repository = repository,
      super(const NoticeComposerState());

  final TeacherRepository _repository;

  Future<void> load() async {
    emit(const NoticeComposerState(status: NoticeComposerStatus.loading));
    try {
      final classes = await _repository.assignedClasses();
      emit(
        NoticeComposerState(
          status: NoticeComposerStatus.ready,
          assignedClasses: classes,
        ),
      );
    } catch (error) {
      emit(
        NoticeComposerState(
          status: NoticeComposerStatus.failure,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> loadStudents(int classId) async {
    if (state.studentsByClass.containsKey(classId) ||
        state.studentsLoadingClassId == classId) {
      return;
    }

    emit(state.copyWith(studentsLoadingClassId: classId, clearMessage: true));
    try {
      final students = await _repository.classStudents(classId);
      final next = Map<int, List<StudentSummary>>.from(state.studentsByClass);
      next[classId] = students;
      emit(state.copyWith(studentsByClass: next, clearStudentsLoading: true));
    } catch (error) {
      emit(
        state.copyWith(
          clearStudentsLoading: true,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> create(UpsertNoticeRequest request) async {
    await _submit(() => _repository.createNotice(request));
  }

  Future<void> update(int noticeId, UpsertNoticeRequest request) async {
    await _submit(() => _repository.updateNotice(noticeId, request));
  }

  Future<void> delete(int noticeId) async {
    await _submit(() => _repository.deleteNotice(noticeId));
  }

  Future<void> _submit(Future<void> Function() action) async {
    emit(
      state.copyWith(
        status: NoticeComposerStatus.submitting,
        clearMessage: true,
      ),
    );
    try {
      await action();
      emit(state.copyWith(status: NoticeComposerStatus.success));
    } catch (error) {
      emit(
        state.copyWith(
          status: NoticeComposerStatus.failure,
          message: error.toString(),
        ),
      );
    }
  }
}
