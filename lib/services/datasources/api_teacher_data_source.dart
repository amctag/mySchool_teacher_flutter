import 'package:my_school_teacher/services/network/teacher_api_client.dart';
import 'package:my_school_teacher/services/datasources/teacher_data_source.dart';
import 'package:my_school_teacher/models/request_models.dart';

class ApiTeacherDataSource implements TeacherDataSource {
  ApiTeacherDataSource({required TeacherApiClient api}) : _api = api;

  final TeacherApiClient _api;

  @override
  void clearReadCache() => _api.clearGetCache();

  @override
  Future<Map<String, dynamic>> login(
    String username,
    String password, {
    String? deviceToken,
  }) async {
    final data = await _api.post(
      '/teacher/login',
      body: {
        'username': username.trim(),
        'password': password,
        if (deviceToken != null && deviceToken.isNotEmpty)
          'fcmToken': deviceToken,
      },
    );
    await _api.saveLoginTokens(data);
    return _mapAccount(data);
  }

  @override
  Future<Map<String, dynamic>> fetchMe() async {
    return _mapAccount(await _api.get('/teacher/me'));
  }

  @override
  Future<void> logout() async {
    try {
      await _api.post('/teacher/logout', auth: true);
    } on TeacherApiException {
      // Local session is still cleared by the auth controller.
    } finally {
      await _api.clearTokens();
    }
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await _api.post(
        '/teacher/me/change-password',
        body: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmPassword': newPassword,
        },
        auth: true,
      );
    } on TeacherApiException catch (error) {
      if (error.statusCode == 401) {
        throw const InvalidCurrentPasswordException();
      }
      throw const PasswordUpdateException();
    }
  }

  @override
  Future<Map<String, dynamic>> fetchTeacherSchedule() async {
    return _mapSchedule(await _api.get('/teacher/me/schedule'));
  }

  @override
  Future<List<Map<String, dynamic>>> fetchTeachingAssignments() async {
    return _mapAssignmentItems(
      await _api.get('/teacher/me/assignments?page=1&limit=20'),
    );
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAssignedClasses() async {
    return _mapClassItems(
      await _api.get('/teacher/me/classes?page=1&limit=20'),
    );
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAllClassSchedules() async {
    return _mapClassItems(
      await _api.get('/teacher/me/class-schedules?page=1&limit=20'),
    );
  }

  @override
  Future<Map<String, dynamic>> fetchClassDetails(int classId) async {
    final json = await _api.get('/teacher/me/classes/$classId');
    return {
      'summary': _mapClass(json['summary'] as Map<String, dynamic>? ?? json),
      'students': ((json['students'] as List<dynamic>?) ?? [])
          .map((item) => _mapStudent(item as Map<String, dynamic>))
          .toList(),
      'schedule': _mapSchedule(
        json['schedule'] as Map<String, dynamic>? ?? const {},
      ),
      'roster': ((json['roster'] as List<dynamic>?) ?? [])
          .map((item) => _mapRoster(item as Map<String, dynamic>))
          .toList(),
    };
  }

  @override
  Future<List<Map<String, dynamic>>> fetchClassStudents(int classId) async {
    final json = await _api.get('/teacher/me/classes/$classId/students');
    return ((json['students'] as List<dynamic>?) ?? [])
        .map((item) => _mapStudent(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchTeacherAgendaItems({
    DateTime? date,
    DateTime? month,
  }) async {
    return _mapAgendaItems(await _api.get(_agendaListPath(date: date, month: month)));
  }

  @override
  Future<void> createAgenda(UpsertAgendaRequest request) async {
    await _api.post(
      '/teacher/me/agendas',
      body: _agendaBody(request),
      auth: true,
    );
  }

  @override
  Future<String> uploadAgendaMedia({
    required List<int> bytes,
    required String filename,
    required String kind,
  }) async {
    final json = await _api.postMultipart(
      '/teacher/me/uploads?kind=$kind',
      bytes: bytes,
      filename: filename,
      fields: {'kind': kind},
    );
    final url = json['url'] as String?;
    if (url == null || url.isEmpty) {
      throw const TeacherApiException('Upload did not return a URL.');
    }
    return url;
  }

  @override
  Future<void> publishAgenda(int agendaId) async {
    await _api.post('/teacher/me/agendas/$agendaId/publish', auth: true);
  }

  @override
  Future<void> updateAgenda(int agendaId, UpsertAgendaRequest request) async {
    await _api.patch(
      '/teacher/me/agendas/$agendaId',
      body: _agendaBody(request),
    );
  }

  @override
  Future<void> deleteAgenda(int agendaId) async {
    await _api.delete('/teacher/me/agendas/$agendaId');
  }

  @override
  Future<Map<String, dynamic>> fetchGradeAssessments({
    int? classId,
    int? sectionId,
    int? courseId,
    int? gradeTypeId,
    int page = 1,
    int limit = 20,
  }) async {
    final json = await _api.get(
      _gradesListPath(
        classId: classId,
        sectionId: sectionId,
        courseId: courseId,
        gradeTypeId: gradeTypeId,
        page: page,
        limit: limit,
      ),
    );
    final items = _mapGradeSheetItems(json);
    return {
      'items': items,
      'pagination': json['pagination'] ??
          {
            'page': page,
            'limit': limit,
            'total': items.length,
            'totalPages': items.isEmpty ? 0 : 1,
          },
    };
  }

  @override
  Future<Map<String, dynamic>> fetchGradeOptions() async {
    return await _api.get('/teacher/me/grades/options');
  }

  @override
  Future<Map<String, dynamic>> fetchGradeEntryContext({
    required int sectionId,
    required int courseId,
    required int gradeTypeId,
  }) async {
    return await _api.get(
      '/teacher/me/grades/entry?sectionId=$sectionId&courseId=$courseId&gradeTypeId=$gradeTypeId',
    );
  }

  @override
  Future<void> saveTeacherGrades(SaveTeacherGradesRequest request) async {
    await _api.post(
      '/teacher/me/grades',
      body: request.toJson(),
      auth: true,
    );
  }

  @override
  Future<void> deleteGradeAssessment(int assessmentId) async {
    await _api.delete('/teacher/me/grades/$assessmentId');
  }

  @override
  Future<List<Map<String, dynamic>>> fetchTeacherNotices() async {
    return _mapNoticeItems(
      await _api.get('/teacher/me/notices?page=1&limit=20'),
    );
  }

  @override
  Future<List<Map<String, dynamic>>> fetchTeacherAnnouncements({
    int? classId,
    int? sectionId,
    int page = 1,
    int limit = 20,
  }) async {
    return _mapAnnouncementItems(
      await _api.get(
        _announcementsListPath(
          classId: classId,
          sectionId: sectionId,
          page: page,
          limit: limit,
        ),
      ),
    );
  }

  @override
  Future<List<Map<String, dynamic>>> fetchTeacherActivities() async {
    return _mapAnnouncementItems(
      await _api.get('/teacher/me/activities?page=1&limit=20'),
    );
  }

  @override
  Future<List<Map<String, dynamic>>> fetchTeacherAlbums() async {
    return _mapAnnouncementItems(
      await _api.get('/teacher/me/albums?page=1&limit=20'),
    );
  }

  @override
  Future<void> createNotice(UpsertNoticeRequest request) async {
    await _api.post(
      '/teacher/me/notices',
      body: _noticeBody(request),
      auth: true,
    );
  }

  @override
  Future<void> updateNotice(int noticeId, UpsertNoticeRequest request) async {
    await _api.patch(
      '/teacher/me/notices/$noticeId',
      body: _noticeBody(request),
    );
  }

  @override
  Future<void> deleteNotice(int noticeId) async {
    await _api.delete('/teacher/me/notices/$noticeId');
  }

  Map<String, dynamic> _mapAccount(Map<String, dynamic> json) {
    return {
      'id': json['teacherId'] ?? json['id'] ?? json['personId'],
      'full_name': json['name'] ?? json['full_name'],
      'username': json['username'],
      'email': json['email'],
      'roles': json['roles'] ?? const ['teacher'],
      'title': json['schoolName'] ?? json['title'],
      'department': json['department'],
      'phone': json['phoneNumber'] ?? json['phone'],
    };
  }

  Map<String, dynamic> _mapSchedule(Map<String, dynamic> json) {
    return {
      'owner_label': json['ownerLabel'] ?? json['owner_label'] ?? '',
      'days': ((json['days'] as List<dynamic>?) ?? []).map((day) {
        final item = day as Map<String, dynamic>;
        return {
          'day_name': item['dayName'] ?? item['day_name'],
          'position': item['position'],
          'entries': ((item['entries'] as List<dynamic>?) ?? []).map((entry) {
            final cell = entry as Map<String, dynamic>;
            return {
              'assignment_id':
                  cell['assignmentId'] ?? cell['assignment_id'] ?? 0,
              'class_id': cell['classId'] ?? cell['class_id'],
              'class_label': cell['classLabel'] ?? cell['class_label'],
              'course_title': cell['courseTitle'] ?? cell['course_title'],
              'period_number': cell['periodNumber'] ?? cell['period_number'],
              'period_label': cell['periodLabel'] ?? cell['period_label'],
              'start_time': cell['startTime'] ?? cell['start_time'] ?? '',
              'end_time': cell['endTime'] ?? cell['end_time'] ?? '',
              'room': cell['room'] ?? '',
            };
          }).toList(),
        };
      }).toList(),
    };
  }

  List<Map<String, dynamic>> _mapClassItems(Map<String, dynamic> json) {
    return ((json['items'] as List<dynamic>?) ?? [])
        .map((item) => _mapClass(item as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> _mapClass(Map<String, dynamic> json) {
    return {
      'id': json['id'],
      'class_name': json['className'] ?? json['class_name'],
      'section_title': json['sectionTitle'] ?? json['section_title'],
      'year_title': json['yearTitle'] ?? json['year_title'],
      'stage': json['stage'],
      'primary_course_title':
          json['primaryCourseTitle'] ?? json['primary_course_title'] ?? '',
      'is_assigned_to_current_teacher':
          json['isAssignedToCurrentTeacher'] ??
          json['is_assigned_to_current_teacher'] ??
          false,
    };
  }

  Map<String, dynamic> _mapStudent(Map<String, dynamic> json) {
    return {
      'id': json['id'],
      'full_name': json['fullName'] ?? json['full_name'],
      'seat_number': json['seatNumber'] ?? json['seat_number'],
    };
  }

  Map<String, dynamic> _mapRoster(Map<String, dynamic> json) {
    return {
      'teacher_name': json['teacherName'] ?? json['teacher_name'],
      'course_title': json['courseTitle'] ?? json['course_title'],
      'is_current_teacher':
          json['isCurrentTeacher'] ?? json['is_current_teacher'] ?? false,
    };
  }

  List<Map<String, dynamic>> _mapAssignmentItems(Map<String, dynamic> json) {
    return ((json['items'] as List<dynamic>?) ?? [])
        .map((item) => _mapAssignment(item as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> _mapAssignment(Map<String, dynamic> json) {
    return {
      'id': json['id'],
      'class_id': json['classId'] ?? json['class_id'],
      'class_name': json['className'] ?? json['class_name'] ?? '',
      'section_title': json['sectionTitle'] ?? json['section_title'] ?? '',
      'year_title': json['yearTitle'] ?? json['year_title'] ?? '',
      'stage': json['stage'] ?? '',
      'course_title': json['courseTitle'] ?? json['course_title'] ?? '',
      'day_name': json['dayName'] ?? json['day_name'] ?? '',
      'period_number': json['periodNumber'] ?? json['period_number'] ?? 0,
      'period_label': json['periodLabel'] ?? json['period_label'] ?? '',
      'start_time': json['startTime'] ?? json['start_time'] ?? '',
      'end_time': json['endTime'] ?? json['end_time'] ?? '',
      'room': json['room'] ?? '',
    };
  }

  List<Map<String, dynamic>> _mapGradeSheetItems(Map<String, dynamic> json) {
    return ((json['items'] as List<dynamic>?) ?? [])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  List<Map<String, dynamic>> _mapAgendaItems(Map<String, dynamic> json) {
    return ((json['items'] as List<dynamic>?) ?? [])
        .map((item) => _mapAgenda(item as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> _mapAgenda(Map<String, dynamic> json) {
    return {
      'id': json['id'],
      'assignment_id': json['assignmentId'] ?? json['assignment_id'] ?? 0,
      'class_id': json['classId'] ?? json['class_id'],
      'class_label': json['classLabel'] ?? json['class_label'] ?? '',
      'course_title': json['courseTitle'] ?? json['course_title'] ?? '',
      'title': json['title'] ?? json['courseTitle'] ?? json['course_title'] ?? '',
      'description': json['description'] ?? '',
      'date': json['date'],
      'publish_date': json['publishDate'] ?? json['publish_date'] ?? json['date'],
      'time': json['time'] ?? '',
      'image_link': json['imageLink'] ?? json['image_link'],
      'file_link':
          json['fileLink'] ??
          json['file_link'] ??
          json['attachmentUrl'] ??
          json['attachment_url'],
      'published': json['published'] ?? json['status'] == 1,
    };
  }

  Map<String, dynamic> _agendaBody(UpsertAgendaRequest request) {
    return {
      'assignmentId': request.assignmentId,
      'classId': request.classId,
      'title': request.title,
      'description': request.description,
      'date': _dateOnly(request.date),
      'published': request.published,
      'imageLink': request.imageLink ?? '',
      'fileLink': request.fileLink ?? '',
    };
  }

  String _agendaListPath({DateTime? date, DateTime? month}) {
    final query = StringBuffer('/teacher/me/agendas?page=1&limit=20');
    if (date != null) {
      query.write('&agendaDate=${_dateOnly(date)}');
    } else if (month != null) {
      query.write('&month=${_yearMonth(month)}');
    }
    return query.toString();
  }

  String _yearMonth(DateTime month) {
    final local = month.toLocal();
    return '${local.year.toString().padLeft(4, '0')}-${local.month.toString().padLeft(2, '0')}';
  }

  String _dateOnly(DateTime date) {
    final local = date.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '${local.year}-$month-$day';
  }

  List<Map<String, dynamic>> _mapNoticeItems(Map<String, dynamic> json) {
    return ((json['items'] as List<dynamic>?) ?? [])
        .map((item) => _mapNotice(item as Map<String, dynamic>))
        .toList();
  }

  List<Map<String, dynamic>> _mapAnnouncementItems(Map<String, dynamic> json) {
    return ((json['items'] as List<dynamic>?) ?? [])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  Map<String, dynamic> _mapNotice(Map<String, dynamic> json) {
    return {
      'id': json['id'],
      'assignment_id': json['assignmentId'] ?? json['assignment_id'],
      'class_id': json['classId'] ?? json['class_id'],
      'target_type': json['targetType'] ?? json['target_type'],
      'target_id': json['targetId'] ?? json['target_id'],
      'target_label': json['targetLabel'] ?? json['target_label'] ?? '',
      'class_label': json['classLabel'] ?? json['class_label'] ?? '',
      'title': json['title'] ?? 'Notice',
      'content': json['content'] ?? json['description'] ?? '',
      'creator': json['creator'] ?? '',
      'publish_date': json['publishDate'] ?? json['publish_date'],
    };
  }

  Map<String, dynamic> _noticeBody(UpsertNoticeRequest request) {
    return {
      'classId': request.classId,
      'targetType': request.targetType.name,
      'targetId': request.targetId,
      'title': request.title,
      'content': request.content,
      'publishDate': request.publishDate.toIso8601String().substring(0, 10),
      if (request.assignmentId != null) 'assignmentId': request.assignmentId,
    };
  }

  String _gradesListPath({
    int? classId,
    int? sectionId,
    int? courseId,
    int? gradeTypeId,
    int page = 1,
    int limit = 20,
  }) {
    final params = <String, String>{
      'page': '$page',
      'limit': '$limit',
    };
    if (classId != null) {
      params['classId'] = '$classId';
    }
    if (sectionId != null) {
      params['sectionId'] = '$sectionId';
    }
    if (courseId != null) {
      params['courseId'] = '$courseId';
    }
    if (gradeTypeId != null) {
      params['gradeTypeId'] = '$gradeTypeId';
    }
    return '/teacher/me/grades?${params.entries.map((entry) => '${entry.key}=${entry.value}').join('&')}';
  }

  String _announcementsListPath({
    int? classId,
    int? sectionId,
    int page = 1,
    int limit = 20,
  }) {
    final params = <String, String>{
      'page': '$page',
      'limit': '$limit',
    };
    if (classId != null) {
      params['classId'] = '$classId';
    }
    if (sectionId != null) {
      params['sectionId'] = '$sectionId';
    }
    return '/teacher/me/announcements?${params.entries.map((entry) => '${entry.key}=${entry.value}').join('&')}';
  }
}
