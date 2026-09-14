import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_school_teacher/app.dart';
import 'package:my_school_teacher/core/persistence/app_preferences.dart';
import 'package:my_school_teacher/services/datasources/mock_teacher_data_source.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('my schedule shows each course with its class and section', (
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

    await tester.enterText(
      find.byKey(const Key('login_username')),
      'sara.nasser',
    );
    await tester.enterText(
      find.byKey(const Key('login_password')),
      'password123',
    );
    await tester.tap(find.byKey(const Key('login_submit')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('My schedule'));
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Something went wrong.'), findsNothing);
    expect(
      find.text('No weekly schedule has been assigned yet.'),
      findsNothing,
    );
    expect(find.byType(DataTable), findsOneWidget);
    expect(find.text('Period'), findsOneWidget);
    expect(find.text('Mon'), findsOneWidget);
    expect(find.text('Tue'), findsOneWidget);
    expect(find.text('Sat'), findsOneWidget);
    expect(find.text('Sun'), findsOneWidget);
    expect(find.textContaining('Mathematics'), findsAtLeastNWidgets(1));
    expect(find.text('Grade 2 / A'), findsAtLeastNWidgets(1));
    expect(find.text('Grade 3 / B'), findsAtLeastNWidgets(1));
  });
}
