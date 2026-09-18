import 'package:equatable/equatable.dart';
import 'package:my_school_teacher/controllers/notifier_controller.dart';
import 'package:my_school_teacher/core/persistence/app_preferences.dart';
import 'package:my_school_teacher/models/account.dart';
import 'package:my_school_teacher/services/network/teacher_api_client.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';

enum AuthStatus { initial, loading, unauthenticated, authenticated, failure }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.account,
    this.message,
    this.accountInactive = false,
    this.paymentRequired = false,
  });

  final AuthStatus status;
  final Account? account;
  final String? message;
  final bool accountInactive;
  final bool paymentRequired;

  @override
  List<Object?> get props => [
    status,
    account,
    message,
    accountInactive,
    paymentRequired,
  ];
}

class AuthController extends NotifierController<AuthState> {
  AuthController({
    required TeacherRepository repository,
    required AppPreferences preferences,
  }) : _repository = repository,
       _preferences = preferences,
       super(const AuthState());

  final TeacherRepository _repository;
  final AppPreferences _preferences;

  Future<void> restore() async {
    if (!_preferences.hasSession) {
      emit(const AuthState(status: AuthStatus.unauthenticated));
      return;
    }
    emit(const AuthState(status: AuthStatus.loading));
    try {
      final account = await _repository.currentAccount();
      emit(AuthState(status: AuthStatus.authenticated, account: account));
    } catch (_) {
      await _preferences.clearSession();
      emit(const AuthState(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> login(
    int id,
    String password, {
    String? deviceToken,
  }) async {
    if (id < 1 || password.isEmpty) {
      emit(
        const AuthState(
          status: AuthStatus.failure,
          message: 'Enter your ID and password.',
        ),
      );
      return;
    }

    emit(const AuthState(status: AuthStatus.loading));
    try {
      final account = await _repository.login(
        id,
        password,
        deviceToken: deviceToken,
      );
      await _preferences.saveSession(true);
      emit(AuthState(status: AuthStatus.authenticated, account: account));
    } on TeacherApiException catch (error) {
      await _preferences.clearSession();
      emit(
        AuthState(
          status: AuthStatus.failure,
          message: error.message,
          accountInactive: error.accountInactive,
          paymentRequired: error.paymentRequired,
        ),
      );
    } catch (error) {
      await _preferences.clearSession();
      emit(AuthState(status: AuthStatus.failure, message: error.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
    } catch (_) {
      // Always drop the local session, even if the API call fails.
    }
    await _preferences.clearSession();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
