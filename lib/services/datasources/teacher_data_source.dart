import 'package:my_school_teacher/models/request_models.dart';

class InvalidCurrentPasswordException implements Exception {
  const InvalidCurrentPasswordException();
}

class PasswordUpdateException implements Exception {
  const PasswordUpdateException();
}

class UnauthorizedTeacherActionException implements Exception {
  const UnauthorizedTeacherActionException();
}

abstract interface class TeacherDataSource {
  void clearReadCache();

  Future<Map<String, dynamic>> login(
    int id,
    String password, {
    String? deviceToken,
  });

  Future<List<Map<String, dynamic>>> fetchSupportSchools(int id);

  Future<Map<String, dynamic>> fetchMe();

  Future<void> logout();

  Future<void> changePassword(String currentPassword, String newPassword);

  Future<Map<String, dynamic>> fetchTeacherSchedule();

  Future<List<Map<String, dynamic>>> fetchTeachingAssignments();

  Future<List<Map<String, dynamic>>> fetchAssignedClasses();

  Future<List<Map<String, dynamic>>> fetchAllClassSchedules();

  Future<Map<String, dynamic>> fetchClassDetails(int classId);

  Future<List<Map<String, dynamic>>> fetchClassStudents(int classId);

  Future<List<Map<String, dynamic>>> fetchTeacherAgendaItems({
    DateTime? date,
    DateTime? month,
  });

  Future<void> createAgenda(UpsertAgendaRequest request);

  Future<String> uploadAgendaMedia({
    required List<int> bytes,
    required String filename,
    required String kind,
  });

  Future<void> publishAgenda(int agendaId);

  Future<void> updateAgenda(int agendaId, UpsertAgendaRequest request);

  Future<void> deleteAgenda(int agendaId);

  Future<Map<String, dynamic>> fetchGradeAssessments({
    int? classId,
    int? sectionId,
    int? courseId,
    int? gradeTypeId,
    int page = 1,
    int limit = 20,
  });

  Future<Map<String, dynamic>> fetchGradeOptions();

  Future<Map<String, dynamic>> fetchGradeEntryContext({
    required int sectionId,
    required int courseId,
    required int gradeTypeId,
  });

  Future<void> saveTeacherGrades(SaveTeacherGradesRequest request);

  Future<void> deleteGradeAssessment(int assessmentId);

  Future<Map<String, dynamic>> fetchAttendanceOptions({DateTime? date});

  Future<Map<String, dynamic>> fetchAttendances({
    required DateTime date,
    int page = 1,
    int limit = 20,
  });

  Future<Map<String, dynamic>> fetchAttendanceSheet({
    required int sectionId,
    required DateTime date,
    int? courseId,
  });

  Future<void> saveTeacherAttendance(SaveTeacherAttendanceRequest request);

  Future<List<Map<String, dynamic>>> fetchTeacherNotices();

  Future<void> createNotice(UpsertNoticeRequest request);

  Future<void> updateNotice(int noticeId, UpsertNoticeRequest request);

  Future<void> deleteNotice(int noticeId);

  Future<List<Map<String, dynamic>>> fetchTeacherAnnouncements({
    int? classId,
    int? sectionId,
    int page = 1,
    int limit = 20,
  });

  Future<List<Map<String, dynamic>>> fetchTeacherActivities();

  Future<void> createActivity(UpsertActivityRequest request);

  Future<List<Map<String, dynamic>>> fetchTeacherAlbums();
}
