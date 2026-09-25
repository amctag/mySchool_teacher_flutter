import 'dart:async';

import 'package:my_school_teacher/services/datasources/teacher_data_source.dart';
import 'package:my_school_teacher/models/request_models.dart';
import 'package:my_school_teacher/models/teacher_notice.dart';
import 'package:my_school_teacher/services/network/teacher_api_client.dart';

class MockTeacherDataSource implements TeacherDataSource {
  MockTeacherDataSource({
    this.delay = const Duration(milliseconds: 150),
    this.teachersCanPublishAgenda = true,
  });

  final Duration delay;

  @override
  final bool teachersCanPublishAgenda;

  final Map<String, dynamic> _teacher = {
    'id': 501,
    'full_name': 'Rana Hassan',
    'username': 'teacher',
    'email': 'rana.hassan@makarem.edu',
    'roles': ['teacher'],
    'title': 'Mathematics Teacher',
    'department': 'Primary Section',
    'phone': '+961 70 123 456',
    'is_supervisor': true,
    'supervised_class_ids': [201],
  };

  final List<Map<String, dynamic>> _assignments = [
    {
      'id': 1001,
      'class_id': 201,
      'class_name': 'Grade 2',
      'section_title': 'A',
      'year_title': '2025-2026',
      'stage': 'Primary',
      'course_title': 'Mathematics',
      'day_name': 'Monday',
      'period_number': 1,
      'period_label': 'Period 1',
      'start_time': '08:00',
      'end_time': '08:45',
      'room': 'Room 12',
    },
    {
      'id': 1002,
      'class_id': 201,
      'class_name': 'Grade 2',
      'section_title': 'A',
      'year_title': '2025-2026',
      'stage': 'Primary',
      'course_title': 'Mathematics',
      'day_name': 'Wednesday',
      'period_number': 2,
      'period_label': 'Period 2',
      'start_time': '08:55',
      'end_time': '09:40',
      'room': 'Room 12',
    },
    {
      'id': 1003,
      'class_id': 202,
      'class_name': 'Grade 3',
      'section_title': 'B',
      'year_title': '2025-2026',
      'stage': 'Primary',
      'course_title': 'Mathematics',
      'day_name': 'Tuesday',
      'period_number': 3,
      'period_label': 'Period 3',
      'start_time': '09:50',
      'end_time': '10:35',
      'room': 'Room 18',
    },
    {
      'id': 1004,
      'class_id': 202,
      'class_name': 'Grade 3',
      'section_title': 'B',
      'year_title': '2025-2026',
      'stage': 'Primary',
      'course_title': 'Mathematics',
      'day_name': 'Thursday',
      'period_number': 1,
      'period_label': 'Period 1',
      'start_time': '08:00',
      'end_time': '08:45',
      'room': 'Room 18',
    },
  ];

  final List<Map<String, dynamic>> _allClasses = [
    {
      'id': 201,
      'class_name': 'Grade 2',
      'section_title': 'A',
      'year_title': '2025-2026',
      'stage': 'Primary',
      'primary_course_title': 'Mathematics',
      'course_titles': ['Mathematics', 'Arabic', 'Science'],
      'is_assigned_to_current_teacher': true,
    },
    {
      'id': 202,
      'class_name': 'Grade 3',
      'section_title': 'B',
      'year_title': '2025-2026',
      'stage': 'Primary',
      'primary_course_title': 'Mathematics',
      'is_assigned_to_current_teacher': true,
    },
    {
      'id': 203,
      'class_name': 'Grade 2',
      'section_title': 'B',
      'year_title': '2025-2026',
      'stage': 'Primary',
      'primary_course_title': 'Science',
      'is_assigned_to_current_teacher': false,
    },
    {
      'id': 204,
      'class_name': 'Grade 4',
      'section_title': 'A',
      'year_title': '2025-2026',
      'stage': 'Primary',
      'primary_course_title': 'Arabic',
      'is_assigned_to_current_teacher': false,
    },
  ];

  final Map<int, List<Map<String, dynamic>>> _studentsByClass = {
    201: const [
      {'id': 1, 'full_name': 'Eissa Ahmad Khalil', 'seat_number': 4},
      {'id': 2, 'full_name': 'Lina Moussa', 'seat_number': 7},
      {'id': 3, 'full_name': 'Omar Nader', 'seat_number': 10},
      {'id': 4, 'full_name': 'Mira Farah', 'seat_number': 14},
    ],
    202: const [
      {'id': 5, 'full_name': 'Khaled Ahmad Khalil', 'seat_number': 3},
      {'id': 6, 'full_name': 'Rita Salameh', 'seat_number': 8},
      {'id': 7, 'full_name': 'Jad Hage', 'seat_number': 12},
      {'id': 8, 'full_name': 'Noor Tarek', 'seat_number': 16},
    ],
    203: const [
      {'id': 9, 'full_name': 'Mona Ahmad Khalil', 'seat_number': 5},
      {'id': 10, 'full_name': 'Youssef Chami', 'seat_number': 11},
    ],
    204: const [
      {'id': 11, 'full_name': 'Farah Hanna', 'seat_number': 6},
      {'id': 12, 'full_name': 'Sami Nassar', 'seat_number': 9},
    ],
  };

  final Map<int, List<Map<String, dynamic>>> _rosterByClass = {
    201: const [
      {
        'teacher_name': 'Rana Hassan',
        'course_title': 'Mathematics',
        'is_current_teacher': true,
      },
      {
        'teacher_name': 'Hiba Nasser',
        'course_title': 'Arabic',
        'is_current_teacher': false,
      },
      {
        'teacher_name': 'Karim Toma',
        'course_title': 'Science',
        'is_current_teacher': false,
      },
    ],
    202: const [
      {
        'teacher_name': 'Rana Hassan',
        'course_title': 'Mathematics',
        'is_current_teacher': true,
      },
      {
        'teacher_name': 'Maya Saad',
        'course_title': 'English',
        'is_current_teacher': false,
      },
      {
        'teacher_name': 'Nabil Asmar',
        'course_title': 'Arabic',
        'is_current_teacher': false,
      },
    ],
    203: const [
      {
        'teacher_name': 'Karim Toma',
        'course_title': 'Science',
        'is_current_teacher': false,
      },
      {
        'teacher_name': 'Dania Saade',
        'course_title': 'French',
        'is_current_teacher': false,
      },
    ],
    204: const [
      {
        'teacher_name': 'Samar Haddad',
        'course_title': 'Arabic',
        'is_current_teacher': false,
      },
      {
        'teacher_name': 'Joe Younes',
        'course_title': 'Mathematics',
        'is_current_teacher': false,
      },
    ],
  };

  final List<Map<String, dynamic>> _agendaItems = [
    {
      'id': 3001,
      'assignment_id': 1001,
      'class_id': 201,
      'class_label': 'Grade 2 - Section A',
      'course_title': 'Mathematics',
      'title': 'Fractions practice',
      'description': 'Solve workbook page 17 and bring your ruler.',
      'date': '2026-08-06',
      'publish_date': '2026-08-05',
      'time': '07:30',
      'image_link': null,
      'file_link': null,
      'published': true,
    },
    {
      'id': 3002,
      'assignment_id': 1003,
      'class_id': 202,
      'class_label': 'Grade 3 - Section B',
      'course_title': 'Mathematics',
      'title': 'Times tables revision',
      'description': 'Review 6 to 9 times tables before Tuesday quiz.',
      'date': '2026-08-07',
      'publish_date': '2026-08-05',
      'time': '08:10',
      'image_link': 'times-tables.png',
      'file_link': 'multiplication-sheet.pdf',
      'published': true,
    },
  ];

  final List<Map<String, dynamic>> _gradeAssessments = [
    {
      'id': 4001,
      'class_id': 2,
      'class_name': 'Grade 2',
      'section_id': 201,
      'section_title': 'A',
      'class_label': 'Grade 2 - Section A',
      'course_id': 11,
      'course_title': 'Mathematics',
      'grade_type_id': 1,
      'grade_type_title': 'Quiz',
      'max_grade': 20,
      'coefficient': 2,
      'publish_date': '2026-08-05',
      'entries_count': 4,
    },
    {
      'id': 4002,
      'class_id': 3,
      'class_name': 'Grade 3',
      'section_id': 202,
      'section_title': 'B',
      'class_label': 'Grade 3 - Section B',
      'course_id': 11,
      'course_title': 'Mathematics',
      'grade_type_id': 2,
      'grade_type_title': 'Assessment',
      'max_grade': 10,
      'coefficient': 2,
      'publish_date': '2026-08-04',
      'entries_count': 4,
    },
  ];

  final Map<int, List<Map<String, dynamic>>> _gradeEntries = {
    4001: [
      {'registration_id': 1, 'student_id': 1, 'score': 18, 'comment': 'Strong work'},
      {'registration_id': 2, 'student_id': 2, 'score': 16, 'comment': null},
      {'registration_id': 3, 'student_id': 3, 'score': 14, 'comment': null},
      {'registration_id': 4, 'student_id': 4, 'score': 19, 'comment': 'Excellent'},
    ],
    4002: [
      {'registration_id': 5, 'student_id': 5, 'score': 8, 'comment': null},
      {'registration_id': 6, 'student_id': 6, 'score': 9, 'comment': 'Fast recall'},
      {'registration_id': 7, 'student_id': 7, 'score': 7, 'comment': null},
      {'registration_id': 8, 'student_id': 8, 'score': 10, 'comment': 'Perfect'},
    ],
  };

  final List<Map<String, dynamic>> _attendanceSheets = [
    {
      'id': 9001,
      'date': '2026-09-18',
      'sectionId': 201,
      'classLabel': 'Grade 2 - Section A',
      'courseId': null,
      'courseTitle': null,
      'studentCount': 4,
      'absentCount': 1,
      'students': [
        {
          'studentId': 1,
          'registrationId': 1,
          'studentName': 'Eissa Ahmad Khalil',
          'status': 'present',
          'attendanceReasonId': null,
          'attendanceReasonTitle': null,
          'description': null,
        },
        {
          'studentId': 2,
          'registrationId': 2,
          'studentName': 'Lina Moussa',
          'status': 'absent',
          'attendanceReasonId': 1,
          'attendanceReasonTitle': 'Sick',
          'description': null,
        },
        {
          'studentId': 3,
          'registrationId': 3,
          'studentName': 'Omar Nader',
          'status': 'present',
          'attendanceReasonId': null,
          'attendanceReasonTitle': null,
          'description': null,
        },
        {
          'studentId': 4,
          'registrationId': 4,
          'studentName': 'Mira Farah',
          'status': 'late',
          'attendanceReasonId': null,
          'attendanceReasonTitle': null,
          'description': null,
        },
      ],
    },
  ];
  int _nextAttendanceId = 9002;

  final List<Map<String, dynamic>> _notices = [
    {
      'id': 5001,
      'assignment_id': 1001,
      'class_id': 201,
      'target_type': 'student',
      'target_id': 1,
      'target_label': 'Eissa Ahmad Khalil',
      'class_label': 'Grade 2 - Section A',
      'title': 'Missing notebook',
      'content': 'Please bring the mathematics notebook tomorrow.',
      'creator': 'Rana Hassan',
      'publish_date': '2026-08-05',
    },
    {
      'id': 5002,
      'assignment_id': 1003,
      'class_id': 202,
      'target_type': 'section',
      'target_id': 202,
      'target_label': 'Section B',
      'class_label': 'Grade 3 - Section B',
      'title': 'Bring geometry set',
      'content': 'All students should bring a geometry set on Thursday.',
      'creator': 'Rana Hassan',
      'publish_date': '2026-08-04',
    },
  ];

  final List<Map<String, dynamic>> _announcements = [
    {
      'id': 9001,
      'title': 'Staff briefing',
      'content': 'Please join the teachers briefing in the hall at 2 PM.',
      'isGlobal': true,
      'scopeLabel': 'All school',
      'publishedAt': '2026-09-12T08:00:00.000Z',
    },
    {
      'id': 9002,
      'title': 'Grade 2 assembly',
      'content': 'Grade 2 teachers should prepare students for Friday assembly.',
      'isGlobal': false,
      'scopeLabel': 'Grade 2 - Section A',
      'classId': 2,
      'sectionId': 201,
      'publishedAt': '2026-09-11T07:30:00.000Z',
    },
  ];

  final List<Map<String, dynamic>> _activities = [
    {
      'id': 9101,
      'assignmentId': 0,
      'classId': 0,
      'title': 'Science fair',
      'content': 'Students present their science projects in the hall.',
      'date': '2026-09-20',
      'image': '',
      'isGlobal': true,
      'scopeLabel': 'All school',
      'classLabel': null,
      'courseTitle': null,
      'isOwn': false,
    },
  ];

  final List<Map<String, dynamic>> _albums = [
    {
      'id': 9201,
      'title': 'Opening day',
      'description': 'Photos from the first day of school.',
      'date': '2026-09-05',
      'yearTitle': '2025-2026',
      'photoCount': 2,
      'coverImage': '',
      'images': [
        {
          'id': 1,
          'imageLink': '',
          'caption': 'Welcome',
          'position': 1,
        },
        {
          'id': 2,
          'imageLink': '',
          'caption': null,
          'position': 2,
        },
      ],
    },
  ];

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'title': 'New notice',
      'body': 'School meeting tomorrow at 10:00.',
      'type': 'announcement',
      'route': 'announcements',
      'data': {'type': 'announcement', 'route': 'announcements'},
      'createdAt': '2026-09-15T10:00:00.000Z',
    },
  ];

  final List<Map<String, dynamic>> _tasks = [
    {
      'id': 1,
      'title': 'Submit midterm grades',
      'description': 'Please enter all midterm grades in the grades section.',
      'createdAt': '2026-09-22T10:00:00.000Z',
      'isCompleted': false,
      'completedAt': null,
    },
    {
      'id': 2,
      'title': 'Confirm weekly schedule',
      'description': 'Review your weekly schedule and report any conflicts.',
      'createdAt': '2026-09-20T08:00:00.000Z',
      'isCompleted': true,
      'completedAt': '2026-09-20T12:00:00.000Z',
    },
  ];

  String _password = 'school';

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await _pause();
    if (currentPassword != _password) {
      throw const InvalidCurrentPasswordException();
    }
    if (newPassword.trim().isEmpty) {
      throw const PasswordUpdateException();
    }
    _password = newPassword;
  }

  @override
  Future<String> uploadAgendaMedia({
    required List<int> bytes,
    required String filename,
    required String kind,
  }) async {
    await _pause();
    if (bytes.isEmpty) {
      throw StateError('File bytes are required');
    }
    if (kind != 'image' && kind != 'file') {
      throw ArgumentError.value(kind, 'kind');
    }
    return 'https://st79068.ispot.cc/myschool/images/mock-$filename';
  }

  @override
  Future<void> createAgenda(UpsertAgendaRequest request) async {
    await _pause();
    _assertAssignment(request.assignmentId, request.classId);
    _agendaItems.insert(0, {
      'id': _nextId(_agendaItems),
      'assignment_id': request.assignmentId,
      'class_id': request.classId,
      'class_label': _classLabel(request.classId),
      'course_title': _assignmentFor(request.assignmentId)['course_title'],
      'title': request.title,
      'description': request.description,
      'date': _dateOnly(request.date),
      'publish_date': _dateOnly(DateTime(2026, 8, 5)),
      'time': '08:00',
      'image_link': request.imageLink,
      'file_link': request.fileLink,
      'published': request.published && teachersCanPublishAgenda,
    });
  }

  @override
  Future<void> publishAgenda(int agendaId) async {
    await _pause();
    if (!teachersCanPublishAgenda) {
      throw const UnauthorizedTeacherActionException();
    }
    final index = _agendaItems.indexWhere((item) => item['id'] == agendaId);
    if (index == -1) {
      return;
    }
    _agendaItems[index] = {
      ..._agendaItems[index],
      'published': true,
      'publish_date': _dateOnly(DateTime.now()),
    };
  }

  @override
  Future<void> saveTeacherGrades(SaveTeacherGradesRequest request) async {
    await _pause();
    final existingIndex = _gradeAssessments.indexWhere(
      (item) =>
          item['section_id'] == request.sectionId &&
          item['course_id'] == request.courseId &&
          item['grade_type_id'] == request.gradeTypeId,
    );
    final option = _gradeCourse(
      request.sectionId,
      request.courseId,
    );
    final section = _allClasses.firstWhere(
      (item) => item['id'] == request.sectionId,
    );
    final typeTitle = request.gradeTypeId == 2 ? 'Assessment' : 'Quiz';
    final sheet = {
      'id': existingIndex == -1
          ? _nextId(_gradeAssessments)
          : _gradeAssessments[existingIndex]['id'],
      'class_id': option.classId,
      'class_name': section['class_name'],
      'section_id': request.sectionId,
      'section_title': section['section_title'],
      'class_label': _classLabel(request.sectionId),
      'course_id': request.courseId,
      'course_title': option.title,
      'grade_type_id': request.gradeTypeId,
      'grade_type_title': typeTitle,
      'max_grade': request.maxGrade,
      'coefficient': option.coefficient,
      'publish_date': request.publishDate == null
          ? null
          : _dateOnly(request.publishDate!),
      'published': request.publishDate != null,
      'can_publish': teachersCanPublishAgenda,
      'entries_count': request.entries.where((entry) => entry.score != null).length,
    };
    if (existingIndex == -1) {
      _gradeAssessments.insert(0, sheet);
    } else {
      _gradeAssessments[existingIndex] = sheet;
    }
    _gradeEntries[sheet['id'] as int] = [
      for (final entry in request.entries)
        {
          'registration_id': entry.registrationId,
          'student_id': entry.studentId,
          'score': entry.score,
          'comment': entry.comment,
        },
    ];
  }

  @override
  Future<void> createNotice(UpsertNoticeRequest request) async {
    await _pause();
    _assertNoticeTarget(request);
    _notices.insert(0, {
      'id': _nextId(_notices),
      'assignment_id': request.assignmentId,
      'class_id': request.classId,
      'target_type': request.targetType.name,
      'target_id': request.targetId,
      'target_label': _targetLabel(request),
      'class_label': _classLabel(request.classId),
      'title': request.title,
      'content': request.content,
      'creator': _teacher['full_name'],
      'publish_date': _dateOnly(request.publishDate),
    });
  }

  @override
  Future<void> createAnnouncement(CreateAnnouncementRequest request) async {
    await _pause();
  }

  @override
  Future<void> deleteAgenda(int agendaId) async {
    await _pause();
    _agendaItems.removeWhere((item) => item['id'] == agendaId);
  }

  @override
  Future<void> publishTeacherGrades(int assessmentId) async {
    await _pause();
    final index =
        _gradeAssessments.indexWhere((item) => item['id'] == assessmentId);
    if (index == -1) {
      throw const TeacherApiException('Grade sheet not found');
    }
    _gradeAssessments[index] = {
      ..._gradeAssessments[index],
      'publish_date': _dateOnly(DateTime.now()),
      'published': true,
    };
  }

  @override
  Future<void> deleteGradeAssessment(int assessmentId) async {
    await _pause();
    _gradeAssessments.removeWhere((item) => item['id'] == assessmentId);
    _gradeEntries.remove(assessmentId);
  }

  @override
  Future<void> deleteNotice(int noticeId) async {
    await _pause();
    _notices.removeWhere((item) => item['id'] == noticeId);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAllClassSchedules() async {
    await _pause();
    return _copyList(_allClasses);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAssignedClasses() async {
    await _pause();
    return _copyList(
      _allClasses.where(
        (item) => item['is_assigned_to_current_teacher'] as bool,
      ),
    );
  }

  @override
  Future<Map<String, dynamic>> fetchClassDetails(int classId) async {
    await _pause();
    final summary = _allClasses.firstWhere((item) => item['id'] == classId);
    return {
      'summary': Map<String, dynamic>.from(summary),
      'students': _copyList(_studentsByClass[classId] ?? const []),
      'schedule': _scheduleForClass(classId),
      'roster': _copyList(_rosterByClass[classId] ?? const []),
    };
  }

  @override
  Future<List<Map<String, dynamic>>> fetchClassStudents(int classId) async {
    await _pause();
    return _copyList(_studentsByClass[classId] ?? const []);
  }

  @override
  Future<Map<String, dynamic>> fetchGradeOptions() async {
    await _pause();
    return {
      'classes': [
        {
          'id': 2,
          'name': 'Grade 2',
          'sections': [
            {
              'id': 201,
              'title': 'A',
              'courses': [
                {
                  'id': 11,
                  'title': 'Mathematics',
                  'assignmentId': 1001,
                  'coefficient': 2,
                },
              ],
            },
          ],
        },
        {
          'id': 3,
          'name': 'Grade 3',
          'sections': [
            {
              'id': 202,
              'title': 'B',
              'courses': [
                {
                  'id': 11,
                  'title': 'Mathematics',
                  'assignmentId': 1003,
                  'coefficient': 2,
                },
              ],
            },
          ],
        },
      ],
      'gradeTypes': [
        {'id': 1, 'title': 'Quiz', 'isMain': true},
        {'id': 2, 'title': 'Assessment', 'isMain': false},
      ],
    };
  }

  @override
  Future<Map<String, dynamic>> fetchAttendanceOptions({DateTime? date}) async {
    await _pause();
    return {
      'attendancePerCourse': false,
      'canTakeAttendance': true,
      'classes': [
        {
          'id': 2,
          'name': 'Grade 2',
          'sections': [
            {
              'id': 201,
              'title': 'A',
              'courses': [
                {'id': 11, 'title': 'Mathematics'},
              ],
            },
          ],
        },
        {
          'id': 3,
          'name': 'Grade 3',
          'sections': [
            {
              'id': 202,
              'title': 'B',
              'courses': [
                {'id': 11, 'title': 'Mathematics'},
              ],
            },
          ],
        },
      ],
      'reasons': [
        {'id': 1, 'title': 'Sick'},
        {'id': 2, 'title': 'Family'},
      ],
    };
  }

  @override
  Future<Map<String, dynamic>> fetchAttendances({
    required DateTime date,
    int page = 1,
    int limit = 20,
  }) async {
    await _pause();
    final day = _dateOnly(date);
    final filtered = _attendanceSheets
        .where((item) => item['date'] == day)
        .map(
          (item) => {
            'id': item['id'],
            'date': item['date'],
            'sectionId': item['sectionId'],
            'classLabel': item['classLabel'],
            'courseId': item['courseId'],
            'courseTitle': item['courseTitle'],
            'studentCount': item['studentCount'],
            'absentCount': item['absentCount'],
          },
        )
        .toList(growable: false);
    return {
      'items': filtered,
      'pagination': {
        'page': page,
        'limit': limit,
        'total': filtered.length,
        'totalPages': filtered.isEmpty ? 0 : 1,
      },
    };
  }

  @override
  Future<Map<String, dynamic>> fetchAttendanceSheet({
    required int sectionId,
    required DateTime date,
    int? courseId,
  }) async {
    await _pause();
    final day = _dateOnly(date);
    Map<String, dynamic>? existing;
    for (final item in _attendanceSheets) {
      if (item['sectionId'] == sectionId &&
          item['date'] == day &&
          item['courseId'] == courseId) {
        existing = item;
        break;
      }
    }
    final classLabel = _classLabel(sectionId);
    final students = existing == null
        ? [
            for (final student in _studentsByClass[sectionId] ?? const [])
              {
                'studentId': student['id'],
                'registrationId': student['id'],
                'studentName': student['full_name'],
                'status': 'present',
                'attendanceReasonId': null,
                'attendanceReasonTitle': null,
                'description': null,
              },
          ]
        : List<Map<String, dynamic>>.from(
            (existing['students'] as List).map(
              (item) => Map<String, dynamic>.from(item as Map),
            ),
          );
    return {
      'attendanceId': existing?['id'],
      'date': day,
      'sectionId': sectionId,
      'classLabel': classLabel,
      'courseId': courseId,
      'courseTitle': courseId == 11 ? 'Mathematics' : null,
      'attendancePerCourse': false,
      'canTakeAttendance': true,
      'students': students,
    };
  }

  @override
  Future<void> saveTeacherAttendance(
    SaveTeacherAttendanceRequest request,
  ) async {
    await _pause();
    final day = _dateOnly(request.date);
    final studentsById = {
      for (final student in _studentsByClass[request.sectionId] ?? const [])
        student['id'] as int: student,
    };
    final students = [
      for (final detail in request.details)
        {
          'studentId': detail.studentId,
          'registrationId': detail.studentId,
          'studentName':
              studentsById[detail.studentId]?['full_name'] ?? 'Student',
          'status': detail.status,
          'attendanceReasonId': detail.attendanceReasonId,
          'attendanceReasonTitle': detail.attendanceReasonId == 1
              ? 'Sick'
              : detail.attendanceReasonId == 2
              ? 'Family'
              : null,
          'description': detail.description,
        },
    ];
    final absentCount = students
        .where((item) => item['status'] == 'absent')
        .length;
    final existingIndex = _attendanceSheets.indexWhere(
      (item) =>
          item['sectionId'] == request.sectionId &&
          item['date'] == day &&
          item['courseId'] == request.courseId,
    );
    final record = {
      'id': existingIndex >= 0
          ? _attendanceSheets[existingIndex]['id']
          : _nextAttendanceId++,
      'date': day,
      'sectionId': request.sectionId,
      'classLabel': _classLabel(request.sectionId),
      'courseId': request.courseId,
      'courseTitle': request.courseId == 11 ? 'Mathematics' : null,
      'studentCount': students.length,
      'absentCount': absentCount,
      'students': students,
    };
    if (existingIndex >= 0) {
      _attendanceSheets[existingIndex] = record;
    } else {
      _attendanceSheets.add(record);
    }
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
    await _pause();
    final filtered = _copyList(
      _gradeAssessments.where((item) {
        if (classId != null && item['class_id'] != classId) {
          return false;
        }
        if (sectionId != null && item['section_id'] != sectionId) {
          return false;
        }
        if (courseId != null && item['course_id'] != courseId) {
          return false;
        }
        if (gradeTypeId != null && item['grade_type_id'] != gradeTypeId) {
          return false;
        }
        return true;
      }),
    );
    final safePage = page < 1 ? 1 : page;
    final safeLimit = limit < 1 ? 20 : limit;
    final total = filtered.length;
    final totalPages = total == 0 ? 0 : (total / safeLimit).ceil();
    final skip = (safePage - 1) * safeLimit;
    final items = skip >= total
        ? <Map<String, dynamic>>[]
        : filtered.skip(skip).take(safeLimit).toList(growable: false);
    return {
      'items': items,
      'pagination': {
        'page': safePage,
        'limit': safeLimit,
        'total': total,
        'totalPages': totalPages,
      },
    };
  }

  @override
  Future<Map<String, dynamic>> fetchGradeEntryContext({
    required int sectionId,
    required int courseId,
    required int gradeTypeId,
  }) async {
    await _pause();
    final option = _gradeCourse(sectionId, courseId);
    final section = _allClasses.firstWhere((item) => item['id'] == sectionId);
    final matched = _gradeAssessments.where(
      (item) =>
          item['section_id'] == sectionId &&
          item['course_id'] == courseId &&
          item['grade_type_id'] == gradeTypeId,
    );
    final sheet = matched.isEmpty ? null : matched.first;
    final students = _studentsByClass[sectionId] ?? const [];
    final sheetId = sheet?['id'] as int?;
    final savedEntries = sheetId == null
        ? const <Map<String, dynamic>>[]
        : (_gradeEntries[sheetId] ?? const <Map<String, dynamic>>[]);
    final saved = {
      for (final entry in savedEntries) entry['student_id'] as int: entry,
    };
    return {
      'gradeSheetId': sheet?['id'],
      'assignmentId': option.assignmentId,
      'classId': option.classId,
      'className': section['class_name'],
      'sectionId': sectionId,
      'sectionTitle': section['section_title'],
      'classLabel': _classLabel(sectionId),
      'courseId': courseId,
      'courseTitle': option.title,
      'gradeTypeId': gradeTypeId,
      'gradeTypeTitle': gradeTypeId == 2 ? 'Assessment' : 'Quiz',
      'isMain': gradeTypeId != 2,
      'coefficient': option.coefficient,
      'maxGrade': gradeTypeId == 2
          ? (sheet?['max_grade'] ?? 100)
          : option.coefficient,
      'publishDate': sheet?['publish_date'] ?? _dateOnly(DateTime.now()),
      'students': [
        for (final student in students)
          {
            'registrationId': student['id'],
            'studentId': student['id'],
            'fullName': student['full_name'],
            'seatNumber': student['seat_number'],
            'score': saved[student['id']]?['score'],
            'comment': saved[student['id']]?['comment'],
          },
      ],
    };
  }

  @override
  Future<List<Map<String, dynamic>>> fetchTeacherAgendaItems({
    DateTime? date,
    DateTime? month,
  }) async {
    await _pause();
    final items = _agendaItems.where((item) {
      final rawDate = item['date'] as String;
      if (date != null) {
        return rawDate == _dateOnly(date);
      }
      if (month != null) {
        return rawDate.startsWith(_yearMonth(month));
      }
      return true;
    }).toList();
    return _copyList(items)
        .map((item) => {...item, 'can_publish': teachersCanPublishAgenda})
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchTeacherNotices() async {
    await _pause();
    return _copyList(_notices);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchTeacherAnnouncements({
    int? classId,
    int? sectionId,
    int page = 1,
    int limit = 20,
  }) async {
    await _pause();
    return _copyList(
      _announcements.where((item) {
        if (sectionId != null && item['sectionId'] != sectionId) {
          return false;
        }
        if (classId != null && item['classId'] != classId) {
          return false;
        }
        return true;
      }),
    );
  }

  @override
  Future<List<Map<String, dynamic>>> fetchTeacherActivities() async {
    await _pause();
    return _copyList(_activities);
  }

  @override
  Future<void> createActivity(UpsertActivityRequest request) async {
    await _pause();
    _activities.insert(0, {
      'id': 9100 + _activities.length + 1,
      'assignmentId': request.assignmentId,
      'classId': request.classId,
      'title': request.title,
      'content': request.content,
      'date':
          '${request.date.year.toString().padLeft(4, '0')}-${request.date.month.toString().padLeft(2, '0')}-${request.date.day.toString().padLeft(2, '0')}',
      'image': request.image ?? '',
      'isGlobal': false,
      'scopeLabel': 'Class ${request.classId}',
      'classLabel': 'Class ${request.classId}',
      'courseTitle': null,
      'isOwn': true,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> fetchTeacherAlbums() async {
    await _pause();
    return _copyList(_albums);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchNotifications({
    bool forceRefresh = false,
  }) async {
    await _pause();
    return _copyList(_notifications);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchTeacherTasks({
    bool forceRefresh = false,
  }) async {
    await _pause();
    return _copyList(_tasks);
  }

  @override
  Future<Map<String, dynamic>> completeTeacherTask(int taskId) async {
    await _pause();
    final index = _tasks.indexWhere((item) => item['id'] == taskId);
    if (index < 0) {
      throw StateError('Task not found');
    }
    final now = DateTime.now().toUtc().toIso8601String();
    _tasks[index] = {
      ..._tasks[index],
      'isCompleted': true,
      'completedAt': now,
    };
    return Map<String, dynamic>.from(_tasks[index]);
  }

  @override
  Future<Map<String, dynamic>> fetchTeacherSchedule() async {
    await _pause();
    return {
      'owner_label': _teacher['full_name'],
      'days': _buildScheduleDays(
        _assignments.map(
          (item) => {
            'day_name': item['day_name'],
            'assignment_id': item['id'],
            'class_id': item['class_id'],
            'class_label': _classLabel(item['class_id'] as int),
            'course_title': item['course_title'],
            'period_number': item['period_number'],
            'period_label': item['period_label'],
            'start_time': item['start_time'],
            'end_time': item['end_time'],
            'room': item['room'],
          },
        ),
      ),
    };
  }

  @override
  Future<List<Map<String, dynamic>>> fetchTeachingAssignments() async {
    await _pause();
    return _copyList(_assignments);
  }

  @override
  Future<Map<String, dynamic>> login(
    int id,
    String password, {
    String? deviceToken,
  }) async {
    await _pause();
    final allowedIds = {501, 1};
    final allowedPasswords = {_password, 'password123', 'restored-session'};
    if (allowedIds.contains(id) && allowedPasswords.contains(password)) {
      return Map<String, dynamic>.from(_teacher);
    }
    throw Exception('Invalid ID or password.');
  }

  @override
  Future<List<Map<String, dynamic>>> fetchSupportSchools(int id) async {
    await _pause();
    if (id < 1) {
      throw Exception('Enter your ID.');
    }
    return [
      {
        'schoolName': 'Makarem Preparatory School',
        'telephone': '+961 1 234 567',
        'phone': '+961 70 123 456',
        'fax': '+961 1 234 568',
        'address': 'Main Street, Beirut',
        'email': 'support@makarem.edu',
        'website': 'https://makarem.edu',
        'about': 'School support desk',
        'logo': '',
      },
    ];
  }

  @override
  Future<Map<String, dynamic>> fetchMe() async {
    await _pause();
    return Map<String, dynamic>.from(_teacher);
  }

  @override
  Future<void> logout() async {
    await _pause();
  }

  @override
  void clearReadCache() {}

  @override
  Future<void> updateAgenda(int agendaId, UpsertAgendaRequest request) async {
    await _pause();
    _assertAssignment(request.assignmentId, request.classId);
    final index = _agendaItems.indexWhere((item) => item['id'] == agendaId);
    if (index == -1) {
      return;
    }
    _agendaItems[index] = {
      ..._agendaItems[index],
      'assignment_id': request.assignmentId,
      'class_id': request.classId,
      'class_label': _classLabel(request.classId),
      'course_title': _assignmentFor(request.assignmentId)['course_title'],
      'title': request.title,
      'description': request.description,
      'date': _dateOnly(request.date),
      'image_link': request.imageLink,
      'file_link': request.fileLink,
      if (request.published) 'published': true,
    };
  }

  @override
  Future<void> updateNotice(int noticeId, UpsertNoticeRequest request) async {
    await _pause();
    _assertNoticeTarget(request);
    final index = _notices.indexWhere((item) => item['id'] == noticeId);
    if (index == -1) {
      return;
    }
    _notices[index] = {
      ..._notices[index],
      'assignment_id': request.assignmentId,
      'class_id': request.classId,
      'target_type': request.targetType.name,
      'target_id': request.targetId,
      'target_label': _targetLabel(request),
      'class_label': _classLabel(request.classId),
      'title': request.title,
      'content': request.content,
      'publish_date': _dateOnly(request.publishDate),
    };
  }

  List<Map<String, dynamic>> _copyList(Iterable<Map<String, dynamic>> source) {
    return source.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  Future<void> _pause() => Future<void>.delayed(delay);

  int _nextId(List<Map<String, dynamic>> items) {
    final ids = items.map((item) => item['id'] as int);
    return (ids.isEmpty ? 1000 : ids.reduce((a, b) => a > b ? a : b)) + 1;
  }

  Map<String, dynamic> _assignmentFor(int assignmentId) {
    return _assignments.firstWhere((item) => item['id'] == assignmentId);
  }

  void _assertAssignment(int assignmentId, int classId) {
    final assignment = _assignments.where(
      (item) => item['id'] == assignmentId && item['class_id'] == classId,
    );
    if (assignment.isEmpty) {
      throw const UnauthorizedTeacherActionException();
    }
  }

  void _assertNoticeTarget(UpsertNoticeRequest request) {
    final assignedClass = _allClasses.any(
      (item) =>
          item['id'] == request.classId &&
          item['is_assigned_to_current_teacher'] == true,
    );
    if (!assignedClass) {
      throw const UnauthorizedTeacherActionException();
    }
    if (request.targetType == NoticeTargetType.student) {
      final studentExists = (_studentsByClass[request.classId] ?? const []).any(
        (student) => student['id'] == request.targetId,
      );
      if (!studentExists) {
        throw const UnauthorizedTeacherActionException();
      }
    }
  }

  String _classLabel(int classId) {
    final classData = _allClasses.firstWhere((item) => item['id'] == classId);
    return '${classData['class_name']} - Section ${classData['section_title']}';
  }

  ({int classId, int assignmentId, String title, double coefficient}) _gradeCourse(
    int sectionId,
    int courseId,
  ) {
    if (sectionId == 201 && courseId == 11) {
      return (classId: 2, assignmentId: 1001, title: 'Mathematics', coefficient: 2);
    }
    if (sectionId == 202 && courseId == 11) {
      return (classId: 3, assignmentId: 1003, title: 'Mathematics', coefficient: 2);
    }
    throw const UnauthorizedTeacherActionException();
  }

  String _dateOnly(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';

  String _yearMonth(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}';

  String _targetLabel(UpsertNoticeRequest request) {
    if (request.targetType == NoticeTargetType.section) {
      final classData = _allClasses.firstWhere(
        (item) => item['id'] == request.classId,
      );
      return 'Section ${classData['section_title']}';
    }
    final student = (_studentsByClass[request.classId] ?? const []).firstWhere(
      (item) => item['id'] == request.targetId,
    );
    return student['full_name'] as String;
  }

  Map<String, dynamic> _scheduleForClass(int classId) {
    final classData = _allClasses.firstWhere((item) => item['id'] == classId);
    final ownAssignments = _assignments.where(
      (item) => item['class_id'] == classId,
    );
    final baseEntries = ownAssignments
        .map(
          (item) => {
            'day_name': item['day_name'],
            'position': _dayPosition(item['day_name'] as String),
            'assignment_id': item['id'],
            'class_id': classId,
            'class_label': _classLabel(classId),
            'course_title': item['course_title'],
            'period_number': item['period_number'],
            'period_label': item['period_label'],
            'start_time': item['start_time'],
            'end_time': item['end_time'],
            'room': item['room'],
          },
        )
        .toList();

    if (baseEntries.isEmpty) {
      baseEntries.addAll([
        {
          'day_name': 'Monday',
          'position': 1,
          'assignment_id': 0,
          'class_id': classId,
          'class_label': _classLabel(classId),
          'course_title': classData['primary_course_title'],
          'period_number': 2,
          'period_label': 'Period 2',
          'start_time': '08:55',
          'end_time': '09:40',
          'room': 'Room 20',
        },
      ]);
    }

    return {
      'owner_label': _classLabel(classId),
      'days': _buildScheduleDays(baseEntries),
    };
  }

  List<Map<String, dynamic>> _buildScheduleDays(
    Iterable<Map<String, dynamic>> entries,
  ) {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final entry in entries) {
      grouped.putIfAbsent(entry['day_name'] as String, () => []).add(entry);
    }
    return grouped.entries.map((group) {
      final items = [...group.value]
        ..sort(
          (left, right) => (left['period_number'] as int).compareTo(
            right['period_number'] as int,
          ),
        );
      return {
        'day_name': group.key,
        'position': _dayPosition(group.key),
        'entries': items
            .map(
              (item) => {
                'assignment_id': item['assignment_id'],
                'class_id': item['class_id'],
                'class_label':
                    item['class_label'] ?? _classLabel(item['class_id'] as int),
                'course_title': item['course_title'],
                'period_number': item['period_number'],
                'period_label': item['period_label'],
                'start_time': item['start_time'],
                'end_time': item['end_time'],
                'room': item['room'],
              },
            )
            .toList(growable: false),
      };
    }).toList()..sort(
      (left, right) =>
          (left['position'] as int).compareTo(right['position'] as int),
    );
  }

  int _dayPosition(String dayName) {
    const order = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    final index = order.indexOf(dayName);
    return index == -1 ? 99 : index + 1;
  }
}
