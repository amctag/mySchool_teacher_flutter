import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_school_teacher/app.dart';
import 'package:my_school_teacher/core/persistence/app_preferences.dart';
import 'package:my_school_teacher/services/datasources/mock_teacher_data_source.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';
import 'package:my_school_teacher/views/widgets/app_select_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('agenda lists items, opens details, and can create', (
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

    await tester.tap(find.text('Agenda'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Add agenda'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);

    await tester.tap(find.byKey(const Key('agenda_filter_all')));
    await tester.pumpAndSettle();

    await tester.drag(find.byKey(const Key('agenda_list')), const Offset(0, -420));
    await tester.pumpAndSettle();

    expect(find.text('Fractions practice'), findsOneWidget);

    await tester.tap(find.text('Fractions practice'));
    await tester.pumpAndSettle();

    expect(find.text('Agenda details'), findsOneWidget);
    expect(
      find.text('Solve workbook page 17 and bring your ruler.'),
      findsOneWidget,
    );

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.drag(find.byKey(const Key('agenda_list')), const Offset(0, -420));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Times tables revision'));
    await tester.pumpAndSettle();
    expect(find.text('PDF'), findsOneWidget);
    expect(find.text('Image'), findsOneWidget);
    expect(find.text('multiplication-sheet.pdf'), findsOneWidget);
    expect(find.text('times-tables.png'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('brand_app_bar_action')));
    await tester.pumpAndSettle();

    expect(find.text('Add agenda'), findsWidgets);
    expect(find.text('Assignment'), findsWidgets);
    expect(find.text('Attach PDF'), findsOneWidget);
    expect(find.text('Attach image'), findsOneWidget);
    expect(find.byType(AppSelectField<int>), findsOneWidget);
  });
}
