import 'package:flutter_test/flutter_test.dart';
import 'package:my_school_teacher/services/datasources/mock_teacher_data_source.dart';
import 'package:my_school_teacher/models/grade_assessment.dart';
import 'package:my_school_teacher/models/request_models.dart';
import 'package:my_school_teacher/models/teacher_agenda_item.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';

void main() {
  late TeacherRepository repository;

  setUp(() {
    repository = TeacherRepository(
      dataSource: MockTeacherDataSource(delay: Duration.zero),
    );
  });

  test('logs in the seeded teacher account', () async {
    final account = await repository.login(501, 'password123');

    expect(account.fullName, 'Rana Hassan');
    expect(account.title, 'Mathematics Teacher');
    expect(account.roles, contains('teacher'));
  });

  test('returns assigned classes only for teacher dashboard', () async {
    final classes = await repository.assignedClasses();

    expect(classes, hasLength(2));
    expect(classes.first.label, 'Grade 2 - Section A');
    expect(classes.every((item) => item.isAssignedToCurrentTeacher), isTrue);
  });

  test('maps class details with students and highlighted roster', () async {
    final details = await repository.classDetails(201);

    expect(details.students, hasLength(4));
    expect(details.students.first.fullName, 'Eissa Ahmad Khalil');
    expect(details.roster.any((item) => item.isCurrentTeacher), isTrue);
    expect(details.schedule.days.first.entries.first.courseTitle, 'Mathematics');
  });

  test('creates and persists a new agenda item', () async {
    final before = await repository.agendaItems();

    await repository.createAgenda(
      UpsertAgendaRequest(
        assignmentId: 1001,
        classId: 201,
        title: 'Notebook check',
        description: 'Bring the corrected notebook tomorrow.',
        date: DateTime(2026, 8, 8),
      ),
    );

    final after = await repository.agendaItems();
    expect(after, hasLength(before.length + 1));
    expect(after.first.title, 'Notebook check');
    expect(after.first.published, isFalse);

    await repository.publishAgenda(after.first.id);
    final published = await repository.agendaItems();
    expect(published.first.published, isTrue);
  });

  test('uploadAgendaMedia returns a public url from the mock', () async {
    final url = await repository.uploadAgendaMedia(
      bytes: [1, 2, 3],
      filename: 'photo.jpg',
      kind: 'image',
    );

    expect(url, 'https://st79068.ispot.cc/myschool/images/mock-photo.jpg');
  });

  test('creates agenda items with uploaded image and file urls', () async {
    await repository.createAgenda(
      UpsertAgendaRequest(
        assignmentId: 1001,
        classId: 201,
        title: 'Workbook page',
        description: 'Complete page 12.',
        date: DateTime(2026, 8, 8),
        imageLink: 'https://st79068.ispot.cc/myschool/images/x.jpg',
        fileLink: 'https://st79068.ispot.cc/myschool/images/notes.pdf',
      ),
    );

    final item = (await repository.agendaItems()).first;
    expect(item.imageLink, 'https://st79068.ispot.cc/myschool/images/x.jpg');
    expect(item.fileLink, 'https://st79068.ispot.cc/myschool/images/notes.pdf');
  });

  test('filters agenda items by date through the query', () async {
    final items = await repository.agendaItems(date: DateTime(2026, 8, 6));

    expect(items, hasLength(1));
    expect(items.single.title, 'Fractions practice');
  });

  test('filters agenda items by month through the query', () async {
    final august = await repository.agendaItems(month: DateTime(2026, 8));
    final september = await repository.agendaItems(month: DateTime(2026, 9));

    expect(august, hasLength(2));
    expect(september, isEmpty);
  });

  test('maps camelCase agenda payloads from the teacher API', () {
    final item = TeacherAgendaItem.fromJson({
      'id': 21,
      'assignmentId': 12,
      'classId': 5,
      'classLabel': 'Grade 4 - Section A',
      'courseTitle': 'Mathematics',
      'title': 'Fractions practice',
      'description': 'Solve workbook page 17.',
      'date': '2026-09-08',
      'publishDate': '2026-09-07T08:00:00.000Z',
      'time': '08:00',
      'imageLink': 'https://cdn.example.com/agendas/math-homework.jpg',
      'fileLink': '',
      'published': true,
    });

    expect(item.classId, 5);
    expect(item.assignmentId, 12);
    expect(item.title, 'Fractions practice');
    expect(item.imageLink, 'https://cdn.example.com/agendas/math-homework.jpg');
    expect(item.fileLink, isNull);
    expect(item.published, isTrue);
  });

  test('exposes only assigned class section and course grade options', () async {
    final options = await repository.gradeOptions();

    expect(options.classes.map((item) => item.name), ['Grade 2', 'Grade 3']);
    expect(options.classes.first.sections.single.title, 'A');
    expect(options.classes.first.sections.single.courses.single.title, 'Mathematics');
    expect(options.classes.first.sections.single.courses.single.coefficient, 2);
    expect(
      options.gradeTypes.map((item) => (item.id, item.isMain)),
      [(1, true), (2, false)],
    );
  });

  test('filters grade sheets through class section course and type', () async {
    final all = await repository.gradeAssessments();
    final byClass = await repository.gradeAssessments(classId: 2);
    final bySection = await repository.gradeAssessments(sectionId: 201);
    final byType = await repository.gradeAssessments(gradeTypeId: 2);

    expect(all.items, hasLength(2));
    expect(byClass.items.map((item) => item.sectionId), [201]);
    expect(bySection.items.single.courseTitle, 'Mathematics');
    expect(byType.items.single.gradeTypeTitle, 'Assessment');
  });

  test('loads students and saves a score for an assigned course', () async {
    final context = await repository.gradeEntryContext(
      sectionId: 201,
      courseId: 11,
      gradeTypeId: 1,
    );

    expect(context.coefficient, 2);
    expect(context.students, isNotEmpty);

    await repository.saveTeacherGrades(
      SaveTeacherGradesRequest(
        sectionId: 201,
        courseId: 11,
        gradeTypeId: 1,
        maxGrade: 20,
        publishDate: DateTime(2026, 9, 10),
        entries: [
          for (final student in context.students)
            StudentGradeInput(
              registrationId: student.registrationId,
              studentId: student.studentId,
              score: student.registrationId == 1 ? 19 : student.score,
            ),
        ],
      ),
    );

    final saved = await repository.gradeEntryContext(
      sectionId: 201,
      courseId: 11,
      gradeTypeId: 1,
    );
    expect(
      saved.students.firstWhere((item) => item.registrationId == 1).score,
      19,
    );
  });

  test('lists school announcements for the teacher', () async {
    final items = await repository.announcements();

    expect(items, hasLength(2));
    expect(items.first.title, 'Staff briefing');
    expect(items.first.isGlobal, isTrue);
  });

  test('filters announcements by class on the data source', () async {
    final items = await repository.announcements(classId: 2);

    expect(items, hasLength(1));
    expect(items.single.title, 'Grade 2 assembly');
  });

  test('lists activities and albums for the teacher', () async {
    final activities = await repository.activities();
    final albums = await repository.albums();

    expect(activities.single.title, 'Science fair');
    expect(albums.single.title, 'Opening day');
    expect(albums.single.images, hasLength(2));
  });
}
