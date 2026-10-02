import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_school_teacher/app.dart';
import 'package:my_school_teacher/core/persistence/app_preferences.dart';
import 'package:my_school_teacher/services/datasources/mock_teacher_data_source.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Blocks only the login call so the test can observe the loading state
/// deterministically; everything else responds immediately (delay zero).
class _GatedLoginDataSource extends MockTeacherDataSource {
  _GatedLoginDataSource({required this.loginGate})
    : super(delay: Duration.zero);

  final Completer<void> loginGate;

  @override
  Future<Map<String, dynamic>> login(
    int id,
    String password, {
    String? deviceToken,
  }) async {
    await loginGate.future;
    return super.login(id, password, deviceToken: deviceToken);
  }
}

void main() {
  testWidgets(
    'manual login loading keeps LoginPage visible instead of Splash',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = AppPreferences(
        await SharedPreferences.getInstance(),
      );
      final loginGate = Completer<void>();

      await tester.pumpWidget(
        SchoolTeacherApp(
          repository: TeacherRepository(
            dataSource: _GatedLoginDataSource(loginGate: loginGate),
          ),
          preferences: preferences,
        ),
      );
      await tester.pumpAndSettle();

      // Reached LoginPage after session-restore check (no saved session).
      expect(find.text('Welcome back'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('login_id')), '501');
      await tester.enterText(
        find.byKey(const Key('login_password')),
        'password123',
      );
      await tester.tap(find.byKey(const Key('login_submit')));
      await tester.pump();

      // LoginPage must remain visible while the login request is in flight:
      // no navigation to the orange splash screen.
      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.byKey(const Key('login_id')), findsOneWidget);
      expect(find.byKey(const Key('login_password')), findsOneWidget);

      // Sign In button disabled with spinner inside.
      final button = tester.widget<FilledButton>(
        find.byKey(const Key('login_submit')),
      );
      expect(button.onPressed, isNull);
      expect(
        find.descendant(
          of: find.byKey(const Key('login_submit')),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );

      // Release the blocked login and verify success navigates home.
      loginGate.complete();
      await tester.pumpAndSettle();

      expect(find.text('My schedule'), findsOneWidget);
    },
  );

  testWidgets('failed login stays on LoginPage and shows backend error', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = AppPreferences(await SharedPreferences.getInstance());

    await tester.pumpWidget(
      SchoolTeacherApp(
        repository: TeacherRepository(
          dataSource: MockTeacherDataSource(delay: Duration.zero),
        ),
        preferences: preferences,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('login_id')), '501');
    await tester.enterText(
      find.byKey(const Key('login_password')),
      'wrong-password',
    );
    await tester.tap(find.byKey(const Key('login_submit')));
    await tester.pumpAndSettle();

    // Still on LoginPage, never navigated to Home.
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('My schedule'), findsNothing);
    expect(find.byKey(const Key('login_submit')), findsOneWidget);

    // Button re-enabled after failure.
    final button = tester.widget<FilledButton>(
      find.byKey(const Key('login_submit')),
    );
    expect(button.onPressed, isNotNull);
  });
}
