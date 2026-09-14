import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_school_teacher/core/theme/app_theme.dart';
import 'package:my_school_teacher/services/datasources/mock_teacher_data_source.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';
import 'package:my_school_teacher/controllers/agenda_composer_controller.dart';
import 'package:my_school_teacher/controllers/grade_entry_controller.dart';
import 'package:my_school_teacher/views/agenda/agenda_editor_page.dart';
import 'package:my_school_teacher/views/grades/grade_entry_page.dart';
import 'package:my_school_teacher/views/widgets/app_select_field.dart';
import 'package:my_school_teacher/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('agenda editor does not overflow on compact width', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await SharedPreferences.getInstance();
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(320, 800));

    final repository = TeacherRepository(
      dataSource: MockTeacherDataSource(delay: Duration.zero),
    );

    await tester.pumpWidget(
      Provider<TeacherRepository>.value(
        value: repository,
        child: ChangeNotifierProvider(
          create: (_) =>
              AgendaComposerController(repository: repository)..load(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            home: const AgendaEditorPage(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Assignment'), findsWidgets);
    expect(find.byType(AppSelectField<int>), findsOneWidget);
    expect(find.text('Attach PDF'), findsOneWidget);
    expect(find.text('Attach image'), findsOneWidget);
  });

  testWidgets('grade entry empty state does not overflow on compact height', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await SharedPreferences.getInstance();
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(360, 640));

    final repository = TeacherRepository(
      dataSource: MockTeacherDataSource(delay: Duration.zero),
    );

    await tester.pumpWidget(
      Provider<TeacherRepository>.value(
        value: repository,
        child: ChangeNotifierProvider(
          create: (_) =>
              GradeEntryController(repository: repository)..initialize(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            home: const GradeEntryPage(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Select your class, section, and course to load students.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
