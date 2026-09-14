import 'package:flutter_test/flutter_test.dart';
import 'package:my_school_teacher/controllers/grade_entry_controller.dart';
import 'package:my_school_teacher/services/datasources/mock_teacher_data_source.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';

void main() {
  late GradeEntryController controller;

  setUp(() {
    controller = GradeEntryController(
      repository: TeacherRepository(
        dataSource: MockTeacherDataSource(delay: Duration.zero),
      ),
    );
  });

  test('loads only the teacher assigned classes sections and courses', () async {
    await controller.initialize();

    expect(controller.state.options.classes.map((item) => item.name), [
      'Grade 2',
      'Grade 3',
    ]);
    expect(
      controller.state.options.classes.expand((item) => item.sections).map(
        (item) => item.title,
      ),
      ['A', 'B'],
    );
    expect(controller.state.context, isNull);

    await controller.selectClass(2);
    expect(controller.state.selectedSectionId, 201);
    expect(controller.state.selectedCourseId, 11);
    expect(controller.state.sections.map((item) => item.title), ['A']);
    expect(controller.state.courses.single.title, 'Mathematics');
    expect(controller.state.context, isNotNull);
    expect(controller.state.context!.students, isNotEmpty);
    expect(controller.state.context!.coefficient, 2);
    expect(
      controller.state.context!.students.map((item) => item.fullName),
      contains('Eissa Ahmad Khalil'),
    );
  });

  test('does not expose unassigned classes or sections', () async {
    await controller.initialize();

    expect(
      controller.state.options.classes.map((item) => item.name),
      isNot(contains('Grade 4')),
    );
    await controller.selectClass(2);
    expect(
      controller.state.sections.map((item) => item.title),
      isNot(contains('B')),
    );
  });
}
