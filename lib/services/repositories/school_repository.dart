import 'package:my_school_teacher/services/datasources/school_data_source.dart';
import 'package:my_school_teacher/models/account.dart';
import 'package:my_school_teacher/models/activity.dart';
import 'package:my_school_teacher/models/agenda.dart';
import 'package:my_school_teacher/models/album.dart';
import 'package:my_school_teacher/models/announcement.dart';
import 'package:my_school_teacher/models/attendance.dart';
import 'package:my_school_teacher/models/child.dart';
import 'package:my_school_teacher/models/exam_schedule.dart';
import 'package:my_school_teacher/models/grade_overview.dart';
import 'package:my_school_teacher/models/notice.dart';
import 'package:my_school_teacher/models/schedule.dart';
import 'package:my_school_teacher/models/school_info.dart';

class SchoolRepository {
  const SchoolRepository({required SchoolDataSource dataSource})
    : _dataSource = dataSource;

  final SchoolDataSource _dataSource;

  Future<Account> login(String username, String password) async =>
      Account.fromJson(await _dataSource.login(username, password));

  Future<void> changePassword(String currentPassword, String newPassword) =>
      _dataSource.changePassword(currentPassword, newPassword);

  Future<List<Child>> children() async => (await _dataSource.fetchChildren())
      .map(Child.fromJson)
      .toList(growable: false);

  Future<WeeklySchedule> schedule(int childId) async =>
      WeeklySchedule.fromJson(await _dataSource.fetchSchedule(childId));

  Future<List<AgendaEntry>> agenda(int childId, DateTime month) async =>
      (await _dataSource.fetchAgenda(
        childId,
        month,
      )).map(AgendaEntry.fromJson).toList(growable: false);

  Future<List<GradeOverview>> grades(int childId) async =>
      (await _dataSource.fetchGrades(
        childId,
      )).map(GradeOverview.fromJson).toList(growable: false);

  Future<List<ParentNotice>> notices(int childId) async =>
      (await _dataSource.fetchNotices(
        childId,
      )).map(ParentNotice.fromJson).toList(growable: false);

  Future<ChildExamSchedule> examSchedule(int childId) async =>
      ChildExamSchedule.fromJson(await _dataSource.fetchExamSchedule(childId));

  Future<List<Announcement>> announcements() async =>
      (await _dataSource.fetchAnnouncements())
          .map(Announcement.fromJson)
          .toList(growable: false);

  Future<List<SchoolActivity>> activities() async =>
      (await _dataSource.fetchActivities())
          .map(SchoolActivity.fromJson)
          .toList(growable: false);

  Future<List<SchoolAlbum>> albums() async => (await _dataSource.fetchAlbums())
      .map(SchoolAlbum.fromJson)
      .toList(growable: false);

  Future<AttendanceMonth> attendance(int childId, DateTime month) async =>
      AttendanceMonth.fromJson(
        await _dataSource.fetchAttendance(childId, month),
      );

  Future<SchoolInfo> schoolInfo() async =>
      SchoolInfo.fromJson(await _dataSource.fetchSchoolInfo());
}
