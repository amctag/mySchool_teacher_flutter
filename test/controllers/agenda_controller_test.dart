import 'package:flutter_test/flutter_test.dart';
import 'package:my_school_teacher/controllers/agenda_controller.dart';
import 'package:my_school_teacher/services/datasources/mock_teacher_data_source.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';

void main() {
  late AgendaController controller;

  setUp(() {
    controller = AgendaController(
      repository: TeacherRepository(
        dataSource: MockTeacherDataSource(delay: Duration.zero),
      ),
    );
  });

  test('load fetches today agenda items', () async {
    await controller.load();

    expect(controller.isTodaySelected, isTrue);
    expect(controller.selectedDate, isNotNull);
  });

  test('selectDate loads that day from the repository, not a local filter', () async {
    await controller.load();

    await controller.selectDate(DateTime(2026, 8, 6));

    expect(controller.state.data, hasLength(1));
    expect(controller.state.data!.single.title, 'Fractions practice');

    await controller.selectDate(DateTime(2026, 9, 10));

    expect(controller.state.data, isEmpty);

    await controller.selectDate(null);

    expect(controller.state.data, hasLength(2));
  });

  test('showMonth loads activity markers for that month', () async {
    await controller.load();
    await controller.showMonth(DateTime(2026, 8));

    expect(
      controller.activityDates.map((date) => date.day).toSet(),
      {6, 7},
    );

    await controller.showMonth(DateTime(2026, 9));

    expect(controller.activityDates, isEmpty);
  });
}
