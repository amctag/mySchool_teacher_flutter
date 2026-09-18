import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_school_teacher/app.dart';
import 'package:my_school_teacher/core/persistence/app_preferences.dart';
import 'package:my_school_teacher/services/datasources/mock_teacher_data_source.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('class details shows students and highlights teacher roster', (
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
      find.byKey(const Key('login_id')),
      '501',
    );
    await tester.enterText(
      find.byKey(const Key('login_password')),
      'password123',
    );
    await tester.tap(find.byKey(const Key('login_submit')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('My classes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Grade 2 - Section A'));
    await tester.pumpAndSettle();

    expect(find.text('Eissa Ahmad Khalil'), findsOneWidget);
    expect(find.text('Stage: Primary'), findsOneWidget);
    expect(find.text('Academic year: 2025-2026'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Your class'),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Your class'), findsOneWidget);
    expect(find.text('Rana Hassan'), findsOneWidget);
  });
}
