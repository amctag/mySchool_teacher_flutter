import 'package:equatable/equatable.dart';
import 'package:my_school_teacher/controllers/notifier_controller.dart';
import 'package:my_school_teacher/services/datasources/teacher_data_source.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';

enum ChangePasswordStatus { initial, invalid, submitting, success, failure }

enum PasswordFieldError { required, tooShort, mismatch, incorrectCurrent }

class ChangePasswordState extends Equatable {
  const ChangePasswordState({
    this.status = ChangePasswordStatus.initial,
    this.currentError,
    this.newError,
    this.confirmationError,
  });

  final ChangePasswordStatus status;
  final PasswordFieldError? currentError;
  final PasswordFieldError? newError;
  final PasswordFieldError? confirmationError;

  @override
  List<Object?> get props => [
    status,
    currentError,
    newError,
    confirmationError,
  ];
}

class ChangePasswordController extends NotifierController<ChangePasswordState> {
  ChangePasswordController({required TeacherRepository repository})
    : _repository = repository,
      super(const ChangePasswordState());

  static const minimumPasswordLength = 8;

  final TeacherRepository _repository;

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmation,
  }) async {
    final currentError = currentPassword.isEmpty
        ? PasswordFieldError.required
        : null;
    final newError = newPassword.isEmpty
        ? PasswordFieldError.required
        : newPassword.length < minimumPasswordLength
        ? PasswordFieldError.tooShort
        : null;
    final confirmationError = confirmation.isEmpty
        ? PasswordFieldError.required
        : confirmation != newPassword
        ? PasswordFieldError.mismatch
        : null;

    if (currentError != null || newError != null || confirmationError != null) {
      emit(
        ChangePasswordState(
          status: ChangePasswordStatus.invalid,
          currentError: currentError,
          newError: newError,
          confirmationError: confirmationError,
        ),
      );
      return;
    }

    emit(const ChangePasswordState(status: ChangePasswordStatus.submitting));
    try {
      await _repository.changePassword(currentPassword, newPassword);
      emit(const ChangePasswordState(status: ChangePasswordStatus.success));
    } on InvalidCurrentPasswordException {
      emit(
        const ChangePasswordState(
          status: ChangePasswordStatus.invalid,
          currentError: PasswordFieldError.incorrectCurrent,
        ),
      );
    } on PasswordUpdateException {
      emit(const ChangePasswordState(status: ChangePasswordStatus.failure));
    }
  }
}
