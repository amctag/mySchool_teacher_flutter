import 'package:my_school_teacher/services/datasources/school_data_source.dart';

class MockSchoolDataSource implements SchoolDataSource {
  const MockSchoolDataSource({this.delay = const Duration(milliseconds: 450)});

  final Duration delay;

  Future<void> _wait() async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
  }

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    await _wait();
    if (username.trim().isEmpty || password.isEmpty) {
      throw const FormatException('Username and password are required.');
    }
    return {
      'id': 1394,
      'full_name': 'Ahmad Khalil',
      'username': username.trim(),
      'email': 'parent@makarem.edu',
      'roles': ['parent'],
    };
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await _wait();
    if (currentPassword != 'school') {
      throw const InvalidCurrentPasswordException();
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchChildren() async {
    await _wait();
    return [
      {
        'id': 1,
        'full_name': 'Eissa Ahmad Khalil',
        'first_name': 'Eissa',
        'mother_name': 'Maya',
        'birthday': '2017-03-15',
        'picture': null,
        'enrollment': {
          'id': 101,
          'class_name': 'Grade 2',
          'section_title': 'A',
          'year_title': '2025–2026',
          'stage': 'Primary',
        },
      },
      {
        'id': 2,
        'full_name': 'Khaled Ahmad Khalil',
        'first_name': 'Khaled',
        'mother_name': 'Maya',
        'birthday': '2014-09-08',
        'picture': null,
        'enrollment': {
          'id': 102,
          'class_name': 'Grade 5',
          'section_title': 'B',
          'year_title': '2025–2026',
          'stage': 'Primary',
        },
      },
      {
        'id': 3,
        'full_name': 'Mona Ahmad Khalil',
        'first_name': 'Mona',
        'mother_name': 'Maya',
        'birthday': '2018-12-02',
        'picture': null,
        'enrollment': {
          'id': 103,
          'class_name': 'Grade 1',
          'section_title': 'A',
          'year_title': '2025–2026',
          'stage': 'Primary',
        },
      },
    ];
  }

  @override
  Future<Map<String, dynamic>> fetchSchedule(int childId) async {
    await _wait();
    final childNames = {
      1: 'Eissa Ahmad Khalil',
      2: 'Khaled Ahmad Khalil',
      3: 'Mona Ahmad Khalil',
    };
    final firstCourses = {1: 'Mathematics', 2: 'Arabic', 3: 'English'};
    final courses = [
      firstCourses[childId] ?? 'Mathematics',
      'English',
      'Science',
      'Arabic',
      'Art',
      'Physical Education',
      'Computing',
    ];
    final dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    return {
      'child_id': childId,
      'child_name': childNames[childId] ?? 'Student',
      'days': [
        for (var dayIndex = 0; dayIndex < dayNames.length; dayIndex++)
          {
            'day_name': dayNames[dayIndex],
            'position': dayIndex + 1,
            'sessions': [
              for (var sessionIndex = 0; sessionIndex < 7; sessionIndex++)
                {
                  'position': sessionIndex + 1,
                  'session_name': 'Period ${sessionIndex + 1}',
                  'course': courses[(sessionIndex + dayIndex) % courses.length],
                  'note': sessionIndex == 3 && dayIndex == 1
                      ? 'Bring workbook'
                      : null,
                },
            ],
          },
      ],
    };
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAgenda(
    int childId,
    DateTime month,
  ) async {
    await _wait();
    final entries = <Map<String, dynamic>>[
      {
        'id': childId * 100 + 1,
        'description': 'Complete exercises 4–8 and review today’s examples.',
        'date': '2026-07-06',
        'creator': 'Ms. Rana',
        'course': childId == 2 ? 'Arabic' : 'Mathematics',
        'image_link': null,
        'file_link': 'worksheet.pdf',
        'published_date': '2026-07-05',
        'time': '09:15',
      },
      {
        'id': childId * 100 + 2,
        'description': 'Read the assigned chapter and prepare three questions.',
        'date': '2026-07-09',
        'creator': 'Mr. Sami',
        'course': 'English',
        'image_link': 'reading-card',
        'file_link': null,
        'published_date': '2026-07-08',
        'time': '11:30',
      },
      {
        'id': childId * 100 + 3,
        'description': 'Revise the water cycle before the classroom activity.',
        'date': '2026-07-14',
        'creator': 'Ms. Nour',
        'course': 'Science',
        'image_link': null,
        'file_link': null,
        'published_date': '2026-07-13',
        'time': '13:00',
      },
    ];
    return entries
        .where((entry) {
          final date = DateTime.parse(entry['date'] as String);
          return date.year == month.year && date.month == month.month;
        })
        .map(Map<String, dynamic>.from)
        .toList(growable: false);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchGrades(int childId) async {
    await _wait();
    final gradesByChild = <int, List<Map<String, dynamic>>>{
      1: [
        {
          'course_title': 'Mathematics',
          'grade_type_title': 'Quiz',
          'score': 18,
          'max_grade': 20,
          'publish_date': '2026-07-17',
          'year_title': '2025–2026',
          'comment': 'Great progress in problem solving.',
        },
        {
          'course_title': 'English',
          'grade_type_title': 'Homework',
          'score': 9,
          'max_grade': 10,
          'publish_date': '2026-07-12',
          'year_title': '2025–2026',
          'comment': null,
        },
        {
          'course_title': 'Science',
          'grade_type_title': 'Worksheet',
          'score': 14,
          'max_grade': 15,
          'publish_date': '2026-07-08',
          'year_title': '2025–2026',
          'comment': 'Needs clearer labels on diagrams.',
        },
      ],
      2: [
        {
          'course_title': 'Arabic',
          'grade_type_title': 'Quiz',
          'score': 17,
          'max_grade': 20,
          'publish_date': '2026-07-16',
          'year_title': '2025–2026',
          'comment': 'Strong reading comprehension.',
        },
        {
          'course_title': 'Mathematics',
          'grade_type_title': 'Homework',
          'score': 10,
          'max_grade': 10,
          'publish_date': '2026-07-11',
          'year_title': '2025–2026',
          'comment': null,
        },
      ],
      3: [
        {
          'course_title': 'English',
          'grade_type_title': 'Reading',
          'score': 8,
          'max_grade': 10,
          'publish_date': '2026-07-15',
          'year_title': '2025–2026',
          'comment': 'Reads aloud with confidence.',
        },
        {
          'course_title': 'Art',
          'grade_type_title': 'Project',
          'score': 19,
          'max_grade': 20,
          'publish_date': '2026-07-09',
          'year_title': '2025–2026',
          'comment': null,
        },
      ],
    };

    return (gradesByChild[childId] ?? const [])
        .map(Map<String, dynamic>.from)
        .toList(growable: false);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchNotices(int childId) async {
    await _wait();
    final noticesByChild = <int, List<Map<String, dynamic>>>{
      1: [
        {
          'id': 1001,
          'scope': 'direct',
          'scope_label': 'Direct',
          'title': 'Library book reminder',
          'content':
              'Please return the reading book by Monday so the next group can borrow it.',
          'creator': 'Ms. Hiba',
          'publish_date': '2026-07-18',
        },
        {
          'id': 1002,
          'scope': 'section',
          'scope_label': 'Section A',
          'title': 'Section A handwriting materials',
          'content':
              'Students in Section A should bring a ruled notebook for Thursday handwriting practice.',
          'creator': 'Grade 2 Team',
          'publish_date': '2026-07-14',
        },
      ],
      2: [
        {
          'id': 2001,
          'scope': 'direct',
          'scope_label': 'Direct',
          'title': 'Arabic reading follow-up',
          'content':
              'Khaled should revise lesson 6 aloud and mark unfamiliar words before Wednesday.',
          'creator': 'Mr. Kareem',
          'publish_date': '2026-07-17',
        },
        {
          'id': 2002,
          'scope': 'section',
          'scope_label': 'Section B',
          'title': 'Section B science model materials',
          'content':
              'Section B students should bring a small cardboard base for the water cycle model.',
          'creator': 'Grade 5 Team',
          'publish_date': '2026-07-13',
        },
      ],
      3: [
        {
          'id': 3001,
          'scope': 'direct',
          'scope_label': 'Direct',
          'title': 'Reading folder check',
          'content':
              'Please sign Mona\'s reading folder after tonight\'s practice page.',
          'creator': 'Ms. Lina',
          'publish_date': '2026-07-16',
        },
        {
          'id': 3002,
          'scope': 'section',
          'scope_label': 'Section A',
          'title': 'Section A color day note',
          'content':
              'Section A will wear green on Tuesday for the classroom plants activity.',
          'creator': 'Grade 1 Team',
          'publish_date': '2026-07-12',
        },
      ],
    };

    return (noticesByChild[childId] ?? const [])
        .map(Map<String, dynamic>.from)
        .toList(growable: false);
  }

  @override
  Future<Map<String, dynamic>> fetchExamSchedule(int childId) async {
    await _wait();
    final schedulesByChild = <int, Map<String, dynamic>>{
      1: {
        'child_id': 1,
        'year_title': '2025–2026',
        'days': [
          {
            'date': '2026-07-21',
            'items': [
              {
                'position': 1,
                'course_title': 'Mathematics',
                'start_time': '08:30',
                'end_time': '09:30',
                'room': 'Room 12',
                'note': 'Bring ruler and pencil.',
              },
              {
                'position': 2,
                'course_title': 'Science',
                'start_time': '10:00',
                'end_time': '11:00',
                'room': 'Lab 1',
                'note': null,
              },
            ],
          },
          {
            'date': '2026-07-23',
            'items': [
              {
                'position': 1,
                'course_title': 'Arabic',
                'start_time': '08:30',
                'end_time': '09:30',
                'room': 'Room 12',
                'note': null,
              },
            ],
          },
        ],
      },
      2: {
        'child_id': 2,
        'year_title': '2025–2026',
        'days': [
          {
            'date': '2026-07-20',
            'items': [
              {
                'position': 1,
                'course_title': 'Arabic',
                'start_time': '08:30',
                'end_time': '09:30',
                'room': 'Room 21',
                'note': 'Bring textbook.',
              },
              {
                'position': 2,
                'course_title': 'Mathematics',
                'start_time': '10:00',
                'end_time': '11:00',
                'room': 'Room 21',
                'note': null,
              },
            ],
          },
          {
            'date': '2026-07-22',
            'items': [
              {
                'position': 1,
                'course_title': 'English',
                'start_time': '08:30',
                'end_time': '09:30',
                'room': 'Room 21',
                'note': null,
              },
            ],
          },
        ],
      },
      3: {
        'child_id': 3,
        'year_title': '2025–2026',
        'days': [
          {
            'date': '2026-07-21',
            'items': [
              {
                'position': 1,
                'course_title': 'English',
                'start_time': '08:30',
                'end_time': '09:15',
                'room': 'Room 7',
                'note': 'Bring reading folder.',
              },
            ],
          },
          {
            'date': '2026-07-23',
            'items': [
              {
                'position': 1,
                'course_title': 'Art',
                'start_time': '08:30',
                'end_time': '09:15',
                'room': 'Art Room',
                'note': null,
              },
            ],
          },
        ],
      },
    };

    final schedule =
        schedulesByChild[childId] ??
        {
          'child_id': childId,
          'year_title': '2025–2026',
          'days': const <Map<String, dynamic>>[],
        };

    return {
      'child_id': schedule['child_id'],
      'year_title': schedule['year_title'],
      'days': [
        for (final day in schedule['days'] as List<dynamic>)
          {
            'date': (day as Map<String, dynamic>)['date'],
            'items': [
              for (final item in day['items'] as List<dynamic>)
                Map<String, dynamic>.from(item as Map<String, dynamic>),
            ],
          },
      ],
    };
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAnnouncements() async {
    await _wait();
    return [
      {
        'id': 1,
        'title': 'Parent meeting',
        'content':
            'Parents are invited to meet class teachers on Thursday from 3:30 PM to 5:30 PM.',
        'creator': 'School Administration',
        'publish_date': '2026-07-16',
      },
      {
        'id': 2,
        'title': 'Summer activity week',
        'content':
            'Registration is open for the school science, reading, and sports activity week.',
        'creator': 'Activities Office',
        'publish_date': '2026-07-10',
      },
      {
        'id': 3,
        'title': 'Updated arrival time',
        'content':
            'The school gates open at 7:20 AM. Students should be in class before 7:45 AM.',
        'creator': 'School Administration',
        'publish_date': '2026-07-02',
      },
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> fetchActivities() async {
    await _wait();
    return [
      {
        'id': 1,
        'title': 'Young Scientists Day',
        'content':
            'Students presented hands-on experiments exploring light, plants, and clean energy.',
        'date': '2026-07-18',
        'image': 'science',
        'creator': 'Science Department',
      },
      {
        'id': 2,
        'title': 'Reading Garden',
        'content':
            'Primary classes shared stories and recommendations in the school garden.',
        'date': '2026-07-12',
        'image': 'reading',
        'creator': 'Languages Department',
      },
      {
        'id': 3,
        'title': 'Sports Morning',
        'content':
            'A friendly morning of relay races, team games, and movement challenges.',
        'date': '2026-07-05',
        'image': 'sports',
        'creator': 'Physical Education Department',
      },
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAlbums() async {
    await _wait();
    return [
      {
        'id': 1,
        'title': 'Young Scientists Day',
        'description': 'Highlights from student science presentations.',
        'date': '2026-07-18',
        'status': 1,
        'year_title': '2025–2026',
        'photo_count': 0,
      },
      {
        'id': 2,
        'title': 'Reading Garden',
        'description': 'Shared reading moments from the school garden.',
        'date': '2026-07-12',
        'status': 1,
        'year_title': '2025–2026',
        'photo_count': 0,
      },
      {
        'id': 3,
        'title': 'Sports Morning',
        'description': 'Team activities and friendly class competitions.',
        'date': '2026-07-05',
        'status': 1,
        'year_title': '2025–2026',
        'photo_count': 0,
      },
    ];
  }

  @override
  Future<Map<String, dynamic>> fetchAttendance(
    int childId,
    DateTime month,
  ) async {
    await _wait();
    final absentDay = 8 + childId;
    final lateDay = 15 + childId;
    final records = [
      for (var day = 1; day <= 24; day++)
        {
          'date':
              '${month.year}-${month.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}',
          'status': day == absentDay
              ? 'absent'
              : day == lateDay
              ? 'late'
              : 'present',
          'reason': day == absentDay
              ? 'Sick'
              : day == lateDay
              ? 'Transport delay'
              : null,
          'description': day == absentDay
              ? 'Parent informed the school.'
              : null,
        },
    ];
    return {
      'child_id': childId,
      'month': '${month.year}-${month.month.toString().padLeft(2, '0')}',
      'summary': {
        'present': 22,
        'absent': 1,
        'late': 1,
        'excused': 0,
        'total': 24,
        'percentage': 91.7,
      },
      'records': records,
    };
  }

  @override
  Future<Map<String, dynamic>> fetchSchoolInfo() async {
    await _wait();
    return {
      'name': 'Makarem Preparatory School',
      'telephone': '+961 1 555 014',
      'phone': '+961 70 555 014',
      'fax': '+961 1 555 015',
      'address': 'Main School Road, Beirut, Lebanon',
      'email': 'info@makarem-school.edu',
      'website': 'www.makarem-school.edu',
      'about':
          'Makarem Preparatory School supports every learner through strong academic foundations, thoughtful guidance, and an active school community.',
    };
  }
}
