import 'package:flutter_test/flutter_test.dart';
import 'package:my_school_teacher/controllers/grades_controller.dart';
import 'package:my_school_teacher/core/state/load_state.dart';
import 'package:my_school_teacher/services/datasources/mock_teacher_data_source.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';

void main() {
  late GradesController controller;

  setUp(() {
    controller = GradesController(
      repository: TeacherRepository(
        dataSource: MockTeacherDataSource(delay: Duration.zero),
      ),
    );
  });

  test('loads grade sheets on first open', () async {
    await controller.load();

    expect(controller.options.classes, isNotEmpty);
    expect(controller.state.status, LoadStatus.success);
    expect(controller.state.data, hasLength(2));
    expect(controller.page, 1);
    expect(controller.hasMore, isFalse);
  });

  test('filters grade sheets without requiring every dropdown', () async {
    await controller.load();
    await controller.selectClass(2);
    await controller.selectSection(201);

    expect(controller.state.data, hasLength(1));
    expect(controller.state.data!.single.sectionId, 201);

    await controller.selectCourse(11);
    expect(controller.state.data, hasLength(1));

    await controller.selectGradeType(2);
    expect(controller.state.status, LoadStatus.empty);
    expect(controller.state.data, isNull);
  });

  test('loads later pages until the last page', () async {
    controller = GradesController(
      pageSize: 1,
      repository: TeacherRepository(
        dataSource: MockTeacherDataSource(delay: Duration.zero),
      ),
    );

    await controller.load();
    expect(controller.state.data, hasLength(1));
    expect(controller.hasMore, isTrue);

    await controller.loadMore();
    expect(controller.state.data, hasLength(2));
    expect(controller.hasMore, isFalse);
  });
}
