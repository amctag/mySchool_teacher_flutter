class InvalidCurrentPasswordException implements Exception {
  const InvalidCurrentPasswordException();
}

class PasswordUpdateException implements Exception {
  const PasswordUpdateException();
}

abstract interface class SchoolDataSource {
  Future<Map<String, dynamic>> login(String username, String password);

  Future<void> changePassword(String currentPassword, String newPassword);

  Future<List<Map<String, dynamic>>> fetchChildren();

  Future<Map<String, dynamic>> fetchSchedule(int childId);

  Future<List<Map<String, dynamic>>> fetchAgenda(int childId, DateTime month);

  Future<List<Map<String, dynamic>>> fetchGrades(int childId);

  Future<List<Map<String, dynamic>>> fetchNotices(int childId);

  Future<Map<String, dynamic>> fetchExamSchedule(int childId);

  Future<List<Map<String, dynamic>>> fetchAnnouncements();

  Future<List<Map<String, dynamic>>> fetchActivities();

  Future<List<Map<String, dynamic>>> fetchAlbums();

  Future<Map<String, dynamic>> fetchAttendance(int childId, DateTime month);

  Future<Map<String, dynamic>> fetchSchoolInfo();
}
