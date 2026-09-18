import 'package:equatable/equatable.dart';
import 'package:my_school_teacher/controllers/notifier_controller.dart';
import 'package:my_school_teacher/models/school_info.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';

enum SupportLoadStatus { initial, loading, success, empty, failure }

class SupportSchoolsState extends Equatable {
  const SupportSchoolsState({
    this.status = SupportLoadStatus.initial,
    this.schools = const [],
    this.message,
  });

  final SupportLoadStatus status;
  final List<SchoolInfo> schools;
  final String? message;

  bool get isLoading => status == SupportLoadStatus.loading;

  @override
  List<Object?> get props => [status, schools, message];
}

class SupportSchoolsController extends NotifierController<SupportSchoolsState> {
  SupportSchoolsController({
    required TeacherRepository repository,
    required this.personId,
  }) : _repository = repository,
       super(const SupportSchoolsState());

  final TeacherRepository _repository;
  final int personId;

  Future<void> load() async {
    emit(const SupportSchoolsState(status: SupportLoadStatus.loading));
    try {
      final schools = await _repository.fetchSupportSchools(personId);
      if (schools.isEmpty) {
        emit(const SupportSchoolsState(status: SupportLoadStatus.empty));
        return;
      }
      emit(
        SupportSchoolsState(
          status: SupportLoadStatus.success,
          schools: schools,
        ),
      );
    } catch (error) {
      emit(
        SupportSchoolsState(
          status: SupportLoadStatus.failure,
          message: error.toString(),
        ),
      );
    }
  }
}
