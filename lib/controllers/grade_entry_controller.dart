import 'package:equatable/equatable.dart';
import 'package:my_school_teacher/controllers/notifier_controller.dart';
import 'package:my_school_teacher/models/grade_assessment.dart';
import 'package:my_school_teacher/models/grade_entry_context.dart';
import 'package:my_school_teacher/models/grade_options.dart';
import 'package:my_school_teacher/models/request_models.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';

enum GradeEntryStatus { initial, loading, ready, submitting, success, failure }

class GradeEntryState extends Equatable {
  const GradeEntryState({
    this.status = GradeEntryStatus.initial,
    this.options = const GradeOptions(classes: [], gradeTypes: []),
    this.context,
    this.selectedClassId,
    this.selectedSectionId,
    this.selectedCourseId,
    this.selectedGradeTypeId,
    this.usedGradeTypeIds = const {},
    this.message,
  });

  final GradeEntryStatus status;
  final GradeOptions options;
  final GradeEntryContext? context;
  final int? selectedClassId;
  final int? selectedSectionId;
  final int? selectedCourseId;
  final int? selectedGradeTypeId;
  final Set<int> usedGradeTypeIds;
  final String? message;

  List<GradeSectionOption> get sections {
    final classId = selectedClassId;
    if (classId == null) {
      return const [];
    }
    return options.classes
        .where((item) => item.id == classId)
        .expand((item) => item.sections)
        .toList(growable: false);
  }

  List<GradeCourseOption> get courses {
    final sectionId = selectedSectionId;
    if (sectionId == null) {
      return const [];
    }
    return sections
        .where((item) => item.id == sectionId)
        .expand((item) => item.courses)
        .toList(growable: false);
  }

  GradeCourseOption? get selectedCourse {
    final courseId = selectedCourseId;
    if (courseId == null) {
      return null;
    }
    for (final course in courses) {
      if (course.id == courseId) {
        return course;
      }
    }
    return null;
  }

  GradeTypeOption? get selectedGradeType {
    final typeId = selectedGradeTypeId;
    if (typeId == null) {
      return null;
    }
    for (final type in options.gradeTypes) {
      if (type.id == typeId) {
        return type;
      }
    }
    return null;
  }

  bool get selectedTypeIsMain =>
      selectedGradeType?.isMain ?? context?.isMain ?? false;

  bool get canChooseAssessmentType =>
      selectedClassId != null &&
      selectedSectionId != null &&
      selectedCourseId != null;

  bool isGradeTypeUsed(int gradeTypeId) =>
      usedGradeTypeIds.contains(gradeTypeId);

  bool get canLoadStudents =>
      selectedSectionId != null &&
      selectedCourseId != null &&
      selectedGradeTypeId != null;

  @override
  List<Object?> get props => [
    status,
    options,
    context,
    selectedClassId,
    selectedSectionId,
    selectedCourseId,
    selectedGradeTypeId,
    usedGradeTypeIds,
    message,
  ];
}

class GradeEntryController extends NotifierController<GradeEntryState> {
  GradeEntryController({required TeacherRepository repository})
    : _repository = repository,
      super(const GradeEntryState());

  final TeacherRepository _repository;
  int _loadSeq = 0;
  int _usedTypesSeq = 0;
  bool _editingExisting = false;

  Future<void> initialize({GradeAssessmentSummary? assessment}) async {
    _loadSeq++;
    _editingExisting = assessment != null;
    emit(const GradeEntryState(status: GradeEntryStatus.loading));
    try {
      final options = await _repository.gradeOptions();
      var selectedClassId = assessment?.classId;
      var selectedSectionId = assessment?.sectionId;
      var selectedCourseId = assessment?.courseId;
      var selectedGradeTypeId = assessment?.gradeTypeId;
      if (assessment == null) {
        final unique = _uniquePath(
          options: options,
          classId: selectedClassId,
          sectionId: selectedSectionId,
          courseId: selectedCourseId,
        );
        selectedClassId = unique.classId;
        selectedSectionId = unique.sectionId;
        selectedCourseId = unique.courseId;
      }

      var usedGradeTypeIds = <int>{};
      if (selectedSectionId != null && selectedCourseId != null) {
        usedGradeTypeIds = await _fetchUsedGradeTypeIds(
          classId: selectedClassId,
          sectionId: selectedSectionId,
          courseId: selectedCourseId,
        );
      }

      // Add grades: leave assessment type empty until the teacher picks one.
      if (assessment == null) {
        selectedGradeTypeId = null;
      }

      GradeEntryContext? context;
      if (selectedSectionId != null &&
          selectedCourseId != null &&
          selectedGradeTypeId != null) {
        context = await _repository.gradeEntryContext(
          sectionId: selectedSectionId,
          courseId: selectedCourseId,
          gradeTypeId: selectedGradeTypeId,
        );
      }
      emit(
        GradeEntryState(
          status: GradeEntryStatus.ready,
          options: options,
          selectedClassId: selectedClassId,
          selectedSectionId: selectedSectionId,
          selectedCourseId: selectedCourseId,
          selectedGradeTypeId: selectedGradeTypeId,
          usedGradeTypeIds: usedGradeTypeIds,
          context: context,
        ),
      );
    } catch (error) {
      emit(
        GradeEntryState(
          status: GradeEntryStatus.failure,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> selectClass(int? classId) {
    final unique = _uniquePath(options: state.options, classId: classId);
    emit(
      GradeEntryState(
        status: GradeEntryStatus.ready,
        options: state.options,
        selectedClassId: unique.classId,
        selectedSectionId: unique.sectionId,
        selectedCourseId: unique.courseId,
        selectedGradeTypeId: null,
        usedGradeTypeIds: const {},
      ),
    );
    return _refreshUsedTypesAndStudents();
  }

  Future<void> selectSection(int? sectionId) {
    final unique = _uniquePath(
      options: state.options,
      classId: state.selectedClassId,
      sectionId: sectionId,
    );
    emit(
      GradeEntryState(
        status: GradeEntryStatus.ready,
        options: state.options,
        selectedClassId: unique.classId,
        selectedSectionId: unique.sectionId,
        selectedCourseId: unique.courseId,
        selectedGradeTypeId: null,
        usedGradeTypeIds: const {},
      ),
    );
    return _refreshUsedTypesAndStudents();
  }

  Future<void> selectCourse(int? courseId) {
    emit(
      GradeEntryState(
        status: GradeEntryStatus.ready,
        options: state.options,
        selectedClassId: state.selectedClassId,
        selectedSectionId: state.selectedSectionId,
        selectedCourseId: courseId,
        selectedGradeTypeId: null,
        usedGradeTypeIds: const {},
      ),
    );
    return _refreshUsedTypesAndStudents();
  }

  Future<void> selectGradeType(int? gradeTypeId) {
    if (gradeTypeId != null &&
        !_editingExisting &&
        state.isGradeTypeUsed(gradeTypeId)) {
      return Future.value();
    }
    emit(
      GradeEntryState(
        status: GradeEntryStatus.ready,
        options: state.options,
        selectedClassId: state.selectedClassId,
        selectedSectionId: state.selectedSectionId,
        selectedCourseId: state.selectedCourseId,
        selectedGradeTypeId: gradeTypeId,
        usedGradeTypeIds: state.usedGradeTypeIds,
      ),
    );
    return _loadStudentsIfReady();
  }

  Future<void> save(SaveTeacherGradesRequest request) async {
    emit(
      GradeEntryState(
        status: GradeEntryStatus.submitting,
        options: state.options,
        selectedClassId: state.selectedClassId,
        selectedSectionId: state.selectedSectionId,
        selectedCourseId: state.selectedCourseId,
        selectedGradeTypeId: state.selectedGradeTypeId,
        usedGradeTypeIds: state.usedGradeTypeIds,
        context: state.context,
      ),
    );
    try {
      await _repository.saveTeacherGrades(request);
      emit(
        GradeEntryState(
          status: GradeEntryStatus.success,
          options: state.options,
          selectedClassId: state.selectedClassId,
          selectedSectionId: state.selectedSectionId,
          selectedCourseId: state.selectedCourseId,
          selectedGradeTypeId: state.selectedGradeTypeId,
          usedGradeTypeIds: state.usedGradeTypeIds,
          context: state.context,
        ),
      );
    } catch (error) {
      emit(
        GradeEntryState(
          status: GradeEntryStatus.failure,
          options: state.options,
          selectedClassId: state.selectedClassId,
          selectedSectionId: state.selectedSectionId,
          selectedCourseId: state.selectedCourseId,
          selectedGradeTypeId: state.selectedGradeTypeId,
          usedGradeTypeIds: state.usedGradeTypeIds,
          context: state.context,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> publish(int assessmentId) async {
    emit(
      GradeEntryState(
        status: GradeEntryStatus.submitting,
        options: state.options,
        selectedClassId: state.selectedClassId,
        selectedSectionId: state.selectedSectionId,
        selectedCourseId: state.selectedCourseId,
        selectedGradeTypeId: state.selectedGradeTypeId,
        usedGradeTypeIds: state.usedGradeTypeIds,
        context: state.context,
      ),
    );
    try {
      await _repository.publishTeacherGrades(assessmentId);
      emit(
        GradeEntryState(
          status: GradeEntryStatus.success,
          options: state.options,
          selectedClassId: state.selectedClassId,
          selectedSectionId: state.selectedSectionId,
          selectedCourseId: state.selectedCourseId,
          selectedGradeTypeId: state.selectedGradeTypeId,
          usedGradeTypeIds: state.usedGradeTypeIds,
          context: state.context,
        ),
      );
    } catch (error) {
      emit(
        GradeEntryState(
          status: GradeEntryStatus.failure,
          options: state.options,
          selectedClassId: state.selectedClassId,
          selectedSectionId: state.selectedSectionId,
          selectedCourseId: state.selectedCourseId,
          selectedGradeTypeId: state.selectedGradeTypeId,
          usedGradeTypeIds: state.usedGradeTypeIds,
          context: state.context,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> delete(int assessmentId) async {
    emit(
      GradeEntryState(
        status: GradeEntryStatus.submitting,
        options: state.options,
        selectedClassId: state.selectedClassId,
        selectedSectionId: state.selectedSectionId,
        selectedCourseId: state.selectedCourseId,
        selectedGradeTypeId: state.selectedGradeTypeId,
        usedGradeTypeIds: state.usedGradeTypeIds,
        context: state.context,
      ),
    );
    try {
      await _repository.deleteGradeAssessment(assessmentId);
      emit(
        GradeEntryState(
          status: GradeEntryStatus.success,
          options: state.options,
          selectedClassId: state.selectedClassId,
          selectedSectionId: state.selectedSectionId,
          selectedCourseId: state.selectedCourseId,
          selectedGradeTypeId: state.selectedGradeTypeId,
          usedGradeTypeIds: state.usedGradeTypeIds,
        ),
      );
    } catch (error) {
      emit(
        GradeEntryState(
          status: GradeEntryStatus.failure,
          options: state.options,
          selectedClassId: state.selectedClassId,
          selectedSectionId: state.selectedSectionId,
          selectedCourseId: state.selectedCourseId,
          selectedGradeTypeId: state.selectedGradeTypeId,
          usedGradeTypeIds: state.usedGradeTypeIds,
          context: state.context,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> _refreshUsedTypesAndStudents() async {
    final classId = state.selectedClassId;
    final sectionId = state.selectedSectionId;
    final courseId = state.selectedCourseId;
    if (sectionId == null || courseId == null) {
      return;
    }

    final seq = ++_usedTypesSeq;
    try {
      final used = await _fetchUsedGradeTypeIds(
        classId: classId,
        sectionId: sectionId,
        courseId: courseId,
      );
      if (seq != _usedTypesSeq) {
        return;
      }

      var gradeTypeId = state.selectedGradeTypeId;
      if (!_editingExisting) {
        if (gradeTypeId != null && used.contains(gradeTypeId)) {
          gradeTypeId = null;
        }
        // Do not auto-pick an assessment type on Add grades.
      }

      emit(
        GradeEntryState(
          status: GradeEntryStatus.ready,
          options: state.options,
          selectedClassId: classId,
          selectedSectionId: sectionId,
          selectedCourseId: courseId,
          selectedGradeTypeId: gradeTypeId,
          usedGradeTypeIds: used,
        ),
      );
      await _loadStudentsIfReady();
    } catch (_) {
      if (seq != _usedTypesSeq) {
        return;
      }
      emit(
        GradeEntryState(
          status: GradeEntryStatus.ready,
          options: state.options,
          selectedClassId: classId,
          selectedSectionId: sectionId,
          selectedCourseId: courseId,
          selectedGradeTypeId: state.selectedGradeTypeId,
          usedGradeTypeIds: const {},
        ),
      );
      await _loadStudentsIfReady();
    }
  }

  Future<Set<int>> _fetchUsedGradeTypeIds({
    int? classId,
    required int sectionId,
    required int courseId,
  }) async {
    final page = await _repository.gradeAssessments(
      classId: classId,
      sectionId: sectionId,
      courseId: courseId,
      page: 1,
      limit: 100,
    );
    return {
      for (final item in page.items) item.gradeTypeId,
    };
  }

  Future<void> _loadStudentsIfReady() async {
    if (!state.canLoadStudents) {
      return;
    }
    final sectionId = state.selectedSectionId!;
    final courseId = state.selectedCourseId!;
    final gradeTypeId = state.selectedGradeTypeId!;
    final current = state.context;
    if (current != null &&
        current.sectionId == sectionId &&
        current.courseId == courseId &&
        current.gradeTypeId == gradeTypeId) {
      return;
    }
    final seq = ++_loadSeq;
    emit(
      GradeEntryState(
        status: GradeEntryStatus.loading,
        options: state.options,
        selectedClassId: state.selectedClassId,
        selectedSectionId: sectionId,
        selectedCourseId: courseId,
        selectedGradeTypeId: gradeTypeId,
        usedGradeTypeIds: state.usedGradeTypeIds,
      ),
    );
    try {
      final context = await _repository.gradeEntryContext(
        sectionId: sectionId,
        courseId: courseId,
        gradeTypeId: gradeTypeId,
      );
      if (seq != _loadSeq) {
        return;
      }
      emit(
        GradeEntryState(
          status: GradeEntryStatus.ready,
          options: state.options,
          selectedClassId: state.selectedClassId,
          selectedSectionId: sectionId,
          selectedCourseId: courseId,
          selectedGradeTypeId: gradeTypeId,
          usedGradeTypeIds: state.usedGradeTypeIds,
          context: context,
        ),
      );
    } catch (error) {
      if (seq != _loadSeq) {
        return;
      }
      emit(
        GradeEntryState(
          status: GradeEntryStatus.failure,
          options: state.options,
          selectedClassId: state.selectedClassId,
          selectedSectionId: sectionId,
          selectedCourseId: courseId,
          selectedGradeTypeId: gradeTypeId,
          usedGradeTypeIds: state.usedGradeTypeIds,
          message: error.toString(),
        ),
      );
    }
  }

  ({int? classId, int? sectionId, int? courseId}) _uniquePath({
    required GradeOptions options,
    int? classId,
    int? sectionId,
    int? courseId,
  }) {
    if (classId == null && options.classes.length == 1) {
      classId = options.classes.first.id;
    }
    final sections = classId == null
        ? const <GradeSectionOption>[]
        : options.classes
              .where((item) => item.id == classId)
              .expand((item) => item.sections)
              .toList(growable: false);
    if (sectionId == null && sections.length == 1) {
      sectionId = sections.first.id;
    }
    final courses = sectionId == null
        ? const <GradeCourseOption>[]
        : sections
              .where((item) => item.id == sectionId)
              .expand((item) => item.courses)
              .toList(growable: false);
    if (courseId == null && courses.length == 1) {
      courseId = courses.first.id;
    }
    return (classId: classId, sectionId: sectionId, courseId: courseId);
  }
}
