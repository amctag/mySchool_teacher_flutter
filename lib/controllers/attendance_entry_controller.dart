import 'package:equatable/equatable.dart';
import 'package:my_school_teacher/controllers/notifier_controller.dart';
import 'package:my_school_teacher/models/attendance.dart';
import 'package:my_school_teacher/models/request_models.dart';
import 'package:my_school_teacher/models/teacher_attendance.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';

enum AttendanceEntryStatus {
  initial,
  loading,
  ready,
  submitting,
  success,
  failure,
}

class AttendanceEntryState extends Equatable {
  const AttendanceEntryState({
    this.status = AttendanceEntryStatus.initial,
    this.options = TeacherAttendanceOptions.empty,
    this.sheet,
    this.selectedClassId,
    this.selectedSectionId,
    this.selectedCourseId,
    this.date,
    this.students = const [],
    this.message,
  });

  final AttendanceEntryStatus status;
  final TeacherAttendanceOptions options;
  final TeacherAttendanceSheet? sheet;
  final int? selectedClassId;
  final int? selectedSectionId;
  final int? selectedCourseId;
  final DateTime? date;
  final List<TeacherAttendanceStudent> students;
  final String? message;

  List<AttendanceSectionOption> get sections {
    final classId = selectedClassId;
    if (classId == null) {
      return const [];
    }
    return options.classes
        .where((item) => item.id == classId)
        .expand((item) => item.sections)
        .toList(growable: false);
  }

  List<AttendanceCourseOption> get courses {
    final sectionId = selectedSectionId;
    if (sectionId == null) {
      return const [];
    }
    return sections
        .where((item) => item.id == sectionId)
        .expand((item) => item.courses)
        .toList(growable: false);
  }

  bool get canLoadStudents {
    if (selectedSectionId == null || date == null) {
      return false;
    }
    if (!options.attendancePerCourse) {
      return true;
    }
    return selectedCourseId != null;
  }

  bool get canTakeAttendance => options.canTakeAttendance;

  @override
  List<Object?> get props => [
    status,
    options,
    sheet,
    selectedClassId,
    selectedSectionId,
    selectedCourseId,
    date,
    students,
    message,
  ];

  AttendanceEntryState copyWith({
    AttendanceEntryStatus? status,
    TeacherAttendanceOptions? options,
    TeacherAttendanceSheet? sheet,
    bool clearSheet = false,
    int? selectedClassId,
    bool clearClass = false,
    int? selectedSectionId,
    bool clearSection = false,
    int? selectedCourseId,
    bool clearCourse = false,
    DateTime? date,
    List<TeacherAttendanceStudent>? students,
    String? message,
    bool clearMessage = false,
  }) {
    return AttendanceEntryState(
      status: status ?? this.status,
      options: options ?? this.options,
      sheet: clearSheet ? null : (sheet ?? this.sheet),
      selectedClassId: clearClass
          ? null
          : (selectedClassId ?? this.selectedClassId),
      selectedSectionId: clearSection
          ? null
          : (selectedSectionId ?? this.selectedSectionId),
      selectedCourseId: clearCourse
          ? null
          : (selectedCourseId ?? this.selectedCourseId),
      date: date ?? this.date,
      students: students ?? this.students,
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}

class AttendanceEntryController extends NotifierController<AttendanceEntryState> {
  AttendanceEntryController({required TeacherRepository repository})
    : _repository = repository,
      super(const AttendanceEntryState());

  final TeacherRepository _repository;
  int _loadSeq = 0;

  Future<void> initialize({
    TeacherAttendanceListItem? item,
    DateTime? date,
  }) async {
    final seq = ++_loadSeq;
    final selectedDate = DateTime(
      (date ?? item?.date ?? DateTime.now()).year,
      (date ?? item?.date ?? DateTime.now()).month,
      (date ?? item?.date ?? DateTime.now()).day,
    );
    emit(
      AttendanceEntryState(
        status: AttendanceEntryStatus.loading,
        date: selectedDate,
        selectedSectionId: item?.sectionId,
        selectedCourseId: item?.courseId,
      ),
    );
    try {
      final options = await _repository.attendanceOptions(date: selectedDate);
      if (seq != _loadSeq) {
        return;
      }
      int? classId;
      int? sectionId = item?.sectionId;
      int? courseId = item?.courseId;
      if (item != null) {
        for (final classItem in options.classes) {
          if (classItem.sections.any((section) => section.id == item.sectionId)) {
            classId = classItem.id;
            break;
          }
        }
      } else if (options.defaultSectionId != null) {
        classId = options.defaultClassId;
        sectionId = options.defaultSectionId;
        courseId = options.defaultCourseId;
      }
      emit(
        AttendanceEntryState(
          status: AttendanceEntryStatus.ready,
          options: options,
          date: selectedDate,
          selectedClassId: classId,
          selectedSectionId: sectionId,
          selectedCourseId: courseId,
        ),
      );
      if (item != null || sectionId != null) {
        await loadSheet();
      }
    } catch (error) {
      if (seq != _loadSeq) {
        return;
      }
      emit(
        state.copyWith(
          status: AttendanceEntryStatus.failure,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> selectClass(int? classId) async {
    emit(
      state.copyWith(
        selectedClassId: classId,
        clearClass: classId == null,
        clearSection: true,
        clearCourse: true,
        clearSheet: true,
        students: const [],
        status: AttendanceEntryStatus.ready,
        clearMessage: true,
      ),
    );
  }

  Future<void> selectSection(int? sectionId) async {
    emit(
      state.copyWith(
        selectedSectionId: sectionId,
        clearSection: sectionId == null,
        clearCourse: true,
        clearSheet: true,
        students: const [],
        status: AttendanceEntryStatus.ready,
        clearMessage: true,
      ),
    );
    if (state.canLoadStudents) {
      await loadSheet();
    }
  }

  Future<void> selectCourse(int? courseId) async {
    emit(
      state.copyWith(
        selectedCourseId: courseId,
        clearCourse: courseId == null,
        clearSheet: true,
        students: const [],
        status: AttendanceEntryStatus.ready,
        clearMessage: true,
      ),
    );
    if (state.canLoadStudents) {
      await loadSheet();
    }
  }

  Future<void> selectDate(DateTime date) async {
    final selectedDate = DateTime(date.year, date.month, date.day);
    emit(
      state.copyWith(
        date: selectedDate,
        clearSheet: true,
        students: const [],
        status: AttendanceEntryStatus.loading,
        clearMessage: true,
      ),
    );
    try {
      final options = await _repository.attendanceOptions(date: selectedDate);
      final useDefault =
          !options.attendancePerCourse && options.defaultSectionId != null;
      emit(
        state.copyWith(
          status: AttendanceEntryStatus.ready,
          options: options,
          selectedClassId: useDefault
              ? options.defaultClassId
              : state.selectedClassId,
          selectedSectionId: useDefault
              ? options.defaultSectionId
              : state.selectedSectionId,
          selectedCourseId: useDefault ? null : state.selectedCourseId,
          clearCourse: useDefault,
        ),
      );
      if (state.canLoadStudents) {
        await loadSheet();
      }
    } catch (error) {
      emit(
        state.copyWith(
          status: AttendanceEntryStatus.failure,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> loadSheet() async {
    final sectionId = state.selectedSectionId;
    final date = state.date;
    if (sectionId == null || date == null || !state.canLoadStudents) {
      return;
    }
    final seq = ++_loadSeq;
    emit(state.copyWith(status: AttendanceEntryStatus.loading, clearMessage: true));
    try {
      final sheet = await _repository.attendanceSheet(
        sectionId: sectionId,
        date: date,
        courseId: state.options.attendancePerCourse
            ? state.selectedCourseId
            : null,
      );
      if (seq != _loadSeq) {
        return;
      }
      emit(
        state.copyWith(
          status: AttendanceEntryStatus.ready,
          sheet: sheet,
          students: sheet.students,
        ),
      );
    } catch (error) {
      if (seq != _loadSeq) {
        return;
      }
      emit(
        state.copyWith(
          status: AttendanceEntryStatus.failure,
          message: error.toString(),
          clearSheet: true,
          students: const [],
        ),
      );
    }
  }

  void setStatus(int studentId, AttendanceStatus status) {
    emit(
      state.copyWith(
        students: [
          for (final student in state.students)
            if (student.studentId == studentId)
              student.copyWith(
                status: status,
                clearReason: status != AttendanceStatus.absent,
                clearDescription: status != AttendanceStatus.absent,
              )
            else
              student,
        ],
        status: AttendanceEntryStatus.ready,
        clearMessage: true,
      ),
    );
  }

  void setReason(int studentId, int? reasonId) {
    emit(
      state.copyWith(
        students: [
          for (final student in state.students)
            if (student.studentId == studentId)
              student.copyWith(
                attendanceReasonId: reasonId,
                clearReason: reasonId == null,
              )
            else
              student,
        ],
      ),
    );
  }

  void setDescription(int studentId, String description) {
    emit(
      state.copyWith(
        students: [
          for (final student in state.students)
            if (student.studentId == studentId)
              student.copyWith(
                description: description,
                clearDescription: description.trim().isEmpty,
              )
            else
              student,
        ],
      ),
    );
  }

  void markAllPresent() {
    emit(
      state.copyWith(
        students: [
          for (final student in state.students)
            student.copyWith(
              status: AttendanceStatus.present,
              clearReason: true,
              clearDescription: true,
            ),
        ],
        status: AttendanceEntryStatus.ready,
        clearMessage: true,
      ),
    );
  }

  Future<void> save() async {
    if (!state.canTakeAttendance) {
      emit(
        state.copyWith(
          status: AttendanceEntryStatus.failure,
          message: 'view_only',
        ),
      );
      return;
    }
    final sectionId = state.selectedSectionId;
    final date = state.date;
    if (sectionId == null || date == null || state.students.isEmpty) {
      emit(
        state.copyWith(
          status: AttendanceEntryStatus.failure,
          message: 'class_required',
        ),
      );
      return;
    }
    for (final student in state.students) {
      if (student.status != AttendanceStatus.present &&
          student.attendanceReasonId == null) {
        emit(
          state.copyWith(
            status: AttendanceEntryStatus.failure,
            message: 'reason_required',
          ),
        );
        return;
      }
    }
    emit(state.copyWith(status: AttendanceEntryStatus.submitting, clearMessage: true));
    try {
      await _repository.saveTeacherAttendance(
        SaveTeacherAttendanceRequest(
          sectionId: sectionId,
          courseId: state.options.attendancePerCourse
              ? state.selectedCourseId
              : null,
          date: date,
          details: [
            for (final student in state.students)
              StudentAttendanceInput(
                studentId: student.studentId,
                status: student.status == AttendanceStatus.present
                    ? 'present'
                    : 'absent',
                attendanceReasonId: student.status == AttendanceStatus.present
                    ? null
                    : student.attendanceReasonId,
                description: null,
              ),
          ],
        ),
      );
      emit(state.copyWith(status: AttendanceEntryStatus.success));
    } catch (error) {
      emit(
        state.copyWith(
          status: AttendanceEntryStatus.failure,
          message: error.toString(),
        ),
      );
    }
  }
}
