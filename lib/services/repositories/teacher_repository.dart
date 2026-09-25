import 'package:my_school_teacher/services/datasources/teacher_data_source.dart';
import 'package:my_school_teacher/models/account.dart';
import 'package:my_school_teacher/models/class_details.dart';
import 'package:my_school_teacher/models/grade_assessment.dart';
import 'package:my_school_teacher/models/grade_entry_context.dart';
import 'package:my_school_teacher/models/grade_options.dart';
import 'package:my_school_teacher/models/paged_list.dart';
import 'package:my_school_teacher/models/request_models.dart';
import 'package:my_school_teacher/models/school_info.dart';
import 'package:my_school_teacher/models/teacher_agenda_item.dart';
import 'package:my_school_teacher/models/teacher_assignment.dart';
import 'package:my_school_teacher/models/teacher_class_summary.dart';
import 'package:my_school_teacher/models/teacher_announcement.dart';
import 'package:my_school_teacher/models/teacher_media.dart';
import 'package:my_school_teacher/models/teacher_notice.dart';
import 'package:my_school_teacher/models/teacher_attendance.dart';
import 'package:my_school_teacher/models/teacher_push_notification.dart';
import 'package:my_school_teacher/models/teacher_schedule.dart';
import 'package:my_school_teacher/models/teacher_task.dart';

class TeacherRepository {
  const TeacherRepository({required TeacherDataSource dataSource})
    : _dataSource = dataSource;

  final TeacherDataSource _dataSource;

  Future<Account> login(
    int id,
    String password, {
    String? deviceToken,
  }) async => Account.fromJson(
    await _dataSource.login(id, password, deviceToken: deviceToken),
  );

  Future<List<SchoolInfo>> fetchSupportSchools(int id) async {
    final rows = await _dataSource.fetchSupportSchools(id);
    return rows
        .map(SchoolInfo.fromSchoolDetailsApiJson)
        .toList(growable: false);
  }

  Future<Account> currentAccount() async =>
      Account.fromJson(await _dataSource.fetchMe());

  Future<void> logout() => _dataSource.logout();

  void clearReadCache() => _dataSource.clearReadCache();

  bool get teachersCanPublishAgenda => _dataSource.teachersCanPublishAgenda;

  Future<void> changePassword(String currentPassword, String newPassword) {
    return _dataSource.changePassword(currentPassword, newPassword);
  }

  Future<TeacherSchedule> teacherSchedule() async => TeacherSchedule.fromJson(
    await _dataSource.fetchTeacherSchedule(),
  );

  Future<List<TeacherAssignment>> teachingAssignments() async =>
      (await _dataSource.fetchTeachingAssignments())
          .map(TeacherAssignment.fromJson)
          .toList(growable: false);

  Future<List<TeacherClassSummary>> assignedClasses() async =>
      (await _dataSource.fetchAssignedClasses())
          .map(TeacherClassSummary.fromJson)
          .toList(growable: false);

  Future<List<TeacherClassSummary>> allClassSchedules() async =>
      (await _dataSource.fetchAllClassSchedules())
          .map(TeacherClassSummary.fromJson)
          .toList(growable: false);

  Future<ClassDetails> classDetails(int classId) async => ClassDetails.fromJson(
    await _dataSource.fetchClassDetails(classId),
  );

  Future<List<StudentSummary>> classStudents(int classId) async =>
      (await _dataSource.fetchClassStudents(classId))
          .map(StudentSummary.fromJson)
          .toList(growable: false);

  Future<List<TeacherAgendaItem>> agendaItems({
    DateTime? date,
    DateTime? month,
  }) async =>
      (await _dataSource.fetchTeacherAgendaItems(date: date, month: month))
          .map(TeacherAgendaItem.fromJson)
          .toList(growable: false);

  Future<void> createAgenda(UpsertAgendaRequest request) =>
      _dataSource.createAgenda(request);

  Future<String> uploadAgendaMedia({
    required List<int> bytes,
    required String filename,
    required String kind,
  }) => _dataSource.uploadAgendaMedia(
    bytes: bytes,
    filename: filename,
    kind: kind,
  );

  Future<void> publishAgenda(int agendaId) =>
      _dataSource.publishAgenda(agendaId);

  Future<void> updateAgenda(int agendaId, UpsertAgendaRequest request) =>
      _dataSource.updateAgenda(agendaId, request);

  Future<void> deleteAgenda(int agendaId) => _dataSource.deleteAgenda(agendaId);

  Future<PagedList<GradeAssessmentSummary>> gradeAssessments({
    int? classId,
    int? sectionId,
    int? courseId,
    int? gradeTypeId,
    int page = 1,
    int limit = 20,
  }) async {
    final json = await _dataSource.fetchGradeAssessments(
      classId: classId,
      sectionId: sectionId,
      courseId: courseId,
      gradeTypeId: gradeTypeId,
      page: page,
      limit: limit,
    );
    final items = ((json['items'] as List<dynamic>?) ?? [])
        .map(
          (item) => GradeAssessmentSummary.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList(growable: false);
    return PagedList.fromMeta(
      items: items,
      pagination: json['pagination'] as Map<String, dynamic>?,
      fallbackPage: page,
      fallbackLimit: limit,
    );
  }

  Future<GradeOptions> gradeOptions() async =>
      GradeOptions.fromJson(await _dataSource.fetchGradeOptions());

  Future<GradeEntryContext> gradeEntryContext({
    required int sectionId,
    required int courseId,
    required int gradeTypeId,
  }) async => GradeEntryContext.fromJson(
    await _dataSource.fetchGradeEntryContext(
      sectionId: sectionId,
      courseId: courseId,
      gradeTypeId: gradeTypeId,
    ),
  );

  Future<void> saveTeacherGrades(SaveTeacherGradesRequest request) =>
      _dataSource.saveTeacherGrades(request);

  Future<void> publishTeacherGrades(int assessmentId) =>
      _dataSource.publishTeacherGrades(assessmentId);

  Future<void> deleteGradeAssessment(int assessmentId) {
    return _dataSource.deleteGradeAssessment(assessmentId);
  }

  Future<TeacherAttendanceOptions> attendanceOptions({DateTime? date}) async =>
      TeacherAttendanceOptions.fromJson(
        await _dataSource.fetchAttendanceOptions(date: date),
      );

  Future<PagedList<TeacherAttendanceListItem>> attendances({
    required DateTime date,
    int page = 1,
    int limit = 20,
  }) async {
    final json = await _dataSource.fetchAttendances(
      date: date,
      page: page,
      limit: limit,
    );
    final items = ((json['items'] as List<dynamic>?) ?? [])
        .map(
          (item) => TeacherAttendanceListItem.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList(growable: false);
    return PagedList.fromMeta(
      items: items,
      pagination: json['pagination'] as Map<String, dynamic>?,
      fallbackPage: page,
      fallbackLimit: limit,
    );
  }

  Future<TeacherAttendanceSheet> attendanceSheet({
    required int sectionId,
    required DateTime date,
    int? courseId,
  }) async => TeacherAttendanceSheet.fromJson(
    await _dataSource.fetchAttendanceSheet(
      sectionId: sectionId,
      date: date,
      courseId: courseId,
    ),
  );

  Future<void> saveTeacherAttendance(SaveTeacherAttendanceRequest request) =>
      _dataSource.saveTeacherAttendance(request);

  Future<List<TeacherNotice>> notices() async =>
      (await _dataSource.fetchTeacherNotices())
          .map(TeacherNotice.fromJson)
          .toList(growable: false);

  Future<void> createNotice(UpsertNoticeRequest request) =>
      _dataSource.createNotice(request);

  Future<void> createAnnouncement(CreateAnnouncementRequest request) =>
      _dataSource.createAnnouncement(request);

  Future<void> updateNotice(int noticeId, UpsertNoticeRequest request) =>
      _dataSource.updateNotice(noticeId, request);

  Future<void> deleteNotice(int noticeId) => _dataSource.deleteNotice(noticeId);

  Future<List<TeacherAnnouncement>> announcements({
    int? classId,
    int? sectionId,
    int page = 1,
    int limit = 20,
  }) async =>
      (await _dataSource.fetchTeacherAnnouncements(
        classId: classId,
        sectionId: sectionId,
        page: page,
        limit: limit,
      )).map(TeacherAnnouncement.fromJson).toList(growable: false);

  Future<List<TeacherActivity>> activities() async =>
      (await _dataSource.fetchTeacherActivities())
          .map(TeacherActivity.fromJson)
          .toList(growable: false);

  Future<void> createActivity(UpsertActivityRequest request) =>
      _dataSource.createActivity(request);

  Future<List<TeacherAlbum>> albums() async =>
      (await _dataSource.fetchTeacherAlbums())
          .map(TeacherAlbum.fromJson)
          .toList(growable: false);

  Future<List<TeacherPushNotification>> notifications({
    bool force = false,
  }) async {
    final rows = await _dataSource.fetchNotifications(forceRefresh: force);
    final items = <TeacherPushNotification>[];
    for (final row in rows) {
      try {
        items.add(TeacherPushNotification.fromApiJson(row));
      } catch (_) {
        // Skip malformed rows so one bad item cannot empty the inbox.
      }
    }
    return items;
  }

  Future<List<TeacherTask>> tasks({bool force = false}) async {
    final rows = await _dataSource.fetchTeacherTasks(forceRefresh: force);
    return rows
        .map(TeacherTask.fromApiJson)
        .toList(growable: false);
  }

  Future<TeacherTask> completeTask(int taskId) async {
    final row = await _dataSource.completeTeacherTask(taskId);
    return TeacherTask.fromApiJson(row);
  }
}
