import 'package:flutter_test/flutter_test.dart';
import 'package:my_school_teacher/controllers/auth_controller.dart';
import 'package:my_school_teacher/core/persistence/app_preferences.dart';
import 'package:my_school_teacher/services/datasources/mock_teacher_data_source.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppPreferences preferences;
  late TeacherRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = AppPreferences(await SharedPreferences.getInstance());
    repository = TeacherRepository(
      dataSource: MockTeacherDataSource(delay: Duration.zero),
    );
  });

  test('rejects empty credentials without authenticating', () async {
    final controller = AuthController(
      repository: repository,
      preferences: preferences,
    );

    await controller.login('', '');

    expect(controller.state.status, AuthStatus.failure);
    expect(controller.state.message, 'Username and password are required.');
  });

  test('authenticates teacher and persists session', () async {
    final controller = AuthController(
      repository: repository,
      preferences: preferences,
    );

    await controller.login('sara.nasser', 'password123');

    expect(controller.state.status, AuthStatus.authenticated);
    expect(controller.state.account?.username, 'teacher');
    expect(preferences.hasSession, isTrue);
  });

  test('logout clears session state', () async {
    await preferences.saveSession(true);
    final controller = AuthController(
      repository: repository,
      preferences: preferences,
    );

    await controller.logout();

    expect(preferences.hasSession, isFalse);
    expect(controller.state.status, AuthStatus.unauthenticated);
  });
}
