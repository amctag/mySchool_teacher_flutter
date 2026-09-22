import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_school_teacher/app.dart';
import 'package:my_school_teacher/controllers/notifications_controller.dart';
import 'package:my_school_teacher/core/persistence/app_preferences.dart';
import 'package:my_school_teacher/l10n/app_localizations.dart';
import 'package:my_school_teacher/services/datasources/mock_teacher_data_source.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';
import 'package:my_school_teacher/views/notifications/notifications_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('home shows unread badge then clears after opening inbox', (
    tester,
  ) async {
    await _pumpAuthenticatedApp(tester);

    final button = find.byKey(const Key('home_notifications'));
    expect(button, findsOneWidget);
    expect(
      tester.getCenter(button).dx,
      greaterThan(tester.getSize(find.byType(AppBar)).width / 2),
    );
    expect(find.text('1'), findsOneWidget);

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('Notifications'), findsWidgets);
    expect(find.text('New notice'), findsOneWidget);
    expect(find.text('School meeting tomorrow at 10:00.'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home_notifications')), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });

  testWidgets('notifications page lists saved push items', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = AppPreferences(await SharedPreferences.getInstance());
    final repository = TeacherRepository(
      dataSource: MockTeacherDataSource(delay: Duration.zero),
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChangeNotifierProvider(
          create: (_) => NotificationsController(
            repository: repository,
            preferences: preferences,
            personId: 501,
          )..load(),
          child: const NotificationsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('New notice'), findsOneWidget);
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
  await tester.enterText(find.byKey(const Key('login_id')), '501');
  await tester.enterText(
    find.byKey(const Key('login_password')),
    'password123',
  );
  await tester.tap(find.byKey(const Key('login_submit')));
  await tester.pumpAndSettle();
}
