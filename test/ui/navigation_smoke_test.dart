import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_school_teacher/app.dart';
import 'package:my_school_teacher/core/persistence/app_preferences.dart';
import 'package:my_school_teacher/services/datasources/mock_teacher_data_source.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('every teacher home destination opens a feature route', (
    tester,
  ) async {
    await _pumpAuthenticatedApp(tester);

    const destinations = [
      'Agenda',
      'Grades',
      'Attendance',
      'Remarque',
      'Notice',
      'Activities',
      'Albums',
      'My classes',
      'My schedule',
    ];

    expect(find.text('Settings'), findsNothing);

    for (final label in destinations) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();

      expect(
        find.byType(BrandAppBar),
        findsOneWidget,
        reason: '$label should open a real feature route.',
      );

      await tester.pageBack();
      await tester.pumpAndSettle();
    }
  });
}

Future<void> _pumpAuthenticatedApp(WidgetTester tester) async {
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
}
