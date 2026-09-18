import 'package:flutter/material.dart';
import 'package:my_school_teacher/core/notifications/app_notification.dart';
import 'package:my_school_teacher/controllers/activity_composer_controller.dart';
import 'package:my_school_teacher/controllers/announcements_controller.dart';
import 'package:my_school_teacher/controllers/media_controllers.dart';
import 'package:my_school_teacher/controllers/agenda_composer_controller.dart';
import 'package:my_school_teacher/controllers/agenda_controller.dart';
import 'package:my_school_teacher/controllers/all_class_schedules_controller.dart';
import 'package:my_school_teacher/controllers/change_password_controller.dart';
import 'package:my_school_teacher/controllers/class_details_controller.dart';
import 'package:my_school_teacher/controllers/grade_entry_controller.dart';
import 'package:my_school_teacher/controllers/grades_controller.dart';
import 'package:my_school_teacher/controllers/my_classes_controller.dart';
import 'package:my_school_teacher/controllers/notice_composer_controller.dart';
import 'package:my_school_teacher/controllers/notices_controller.dart';
import 'package:my_school_teacher/controllers/schedule_controller.dart';
import 'package:my_school_teacher/models/account.dart';
import 'package:my_school_teacher/models/grade_assessment.dart';
import 'package:my_school_teacher/models/teacher_announcement.dart';
import 'package:my_school_teacher/models/teacher_media.dart';
import 'package:my_school_teacher/models/teacher_agenda_item.dart';
import 'package:my_school_teacher/models/teacher_class_summary.dart';
import 'package:my_school_teacher/models/teacher_notice.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';
import 'package:my_school_teacher/views/announcements/announcement_details_page.dart';
import 'package:my_school_teacher/views/announcements/announcements_page.dart';
import 'package:my_school_teacher/views/activities/activities_page.dart';
import 'package:my_school_teacher/views/activities/activity_editor_page.dart';
import 'package:my_school_teacher/views/albums/albums_page.dart';
import 'package:my_school_teacher/views/agenda/agenda_details_page.dart';
import 'package:my_school_teacher/views/agenda/agenda_editor_page.dart';
import 'package:my_school_teacher/views/agenda/agenda_page.dart';
import 'package:my_school_teacher/views/classes/all_class_schedules_page.dart';
import 'package:my_school_teacher/views/classes/class_details_page.dart';
import 'package:my_school_teacher/views/classes/my_classes_page.dart';
import 'package:my_school_teacher/views/grades/grade_entry_page.dart';
import 'package:my_school_teacher/views/grades/grades_page.dart';
import 'package:my_school_teacher/views/notices/notice_editor_page.dart';
import 'package:my_school_teacher/views/notices/notices_page.dart';
import 'package:my_school_teacher/views/profile/change_password_page.dart';
import 'package:my_school_teacher/views/profile/profile_page.dart';
import 'package:my_school_teacher/views/profile/teacher_profile_page.dart';
import 'package:my_school_teacher/views/schedule/schedule_page.dart';
import 'package:my_school_teacher/views/settings/language_page.dart';
import 'package:my_school_teacher/views/settings/settings_page.dart';
import 'package:provider/provider.dart';

abstract final class AppNavigator {
  static TeacherRepository _repository(BuildContext context) {
    return Provider.of<TeacherRepository>(
      Navigator.of(context).context,
      listen: false,
    );
  }

  static Future<void> profile(BuildContext context) =>
      _push(context, const ProfilePage());

  static Future<void> teacherProfile(BuildContext context, Account account) =>
      _push(context, TeacherProfilePage(account: account));

  static Future<void> changePassword(BuildContext context) {
    final repository = _repository(context);
    return _push(
      context,
      ChangeNotifierProvider(
        create: (_) => ChangePasswordController(repository: repository),
        child: const ChangePasswordPage(),
      ),
    );
  }

  static Future<void> schedule(BuildContext context) {
    final repository = _repository(context);
    return _push(
      context,
      ChangeNotifierProvider(
        create: (_) => ScheduleController(repository: repository)..load(),
        child: const SchedulePage(),
      ),
    );
  }

  static Future<void> agenda(BuildContext context) {
    final repository = _repository(context);
    return _push(
      context,
      ChangeNotifierProvider(
        create: (_) => AgendaController(repository: repository)..load(),
        child: const AgendaPage(),
      ),
    );
  }

  static Future<void> agendaDetails(
    BuildContext context,
    TeacherAgendaItem item,
  ) {
    return _push(context, AgendaDetailsPage(item: item));
  }

  static Future<bool> agendaEditor(
    BuildContext context, {
    TeacherAgendaItem? item,
  }) async {
    final repository = _repository(context);
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => Provider<TeacherRepository>.value(
          value: repository,
          child: ChangeNotifierProvider(
            create: (_) =>
                AgendaComposerController(repository: repository)..load(),
            child: AgendaEditorPage(item: item),
          ),
        ),
      ),
    );
    return saved == true;
  }

  static Future<void> grades(BuildContext context) {
    final repository = _repository(context);
    return _push(
      context,
      ChangeNotifierProvider(
        create: (_) => GradesController(repository: repository)..load(),
        child: const GradesPage(),
      ),
    );
  }

  static Future<void> gradeEntry(
    BuildContext context, {
    GradeAssessmentSummary? assessment,
  }) {
    final repository = _repository(context);
    return _push(
      context,
      ChangeNotifierProvider(
        create: (_) => GradeEntryController(repository: repository)
          ..initialize(assessment: assessment),
        child: GradeEntryPage(assessment: assessment),
      ),
    );
  }

  static Future<void> notices(BuildContext context) {
    final repository = _repository(context);
    return _push(
      context,
      ChangeNotifierProvider(
        create: (_) => NoticesController(repository: repository)..load(),
        child: const NoticesPage(),
      ),
    );
  }

  static Future<void> announcements(BuildContext context) {
    final repository = _repository(context);
    return _push(
      context,
      ChangeNotifierProvider(
        create: (_) =>
            AnnouncementsController(repository: repository)..load(),
        child: const AnnouncementsPage(),
      ),
    );
  }

  static Future<void> announcementDetails(
    BuildContext context,
    TeacherAnnouncement announcement,
  ) {
    return _push(context, AnnouncementDetailsPage(announcement: announcement));
  }

  static Future<void> activities(BuildContext context) {
    final repository = _repository(context);
    return _push(
      context,
      ChangeNotifierProvider(
        create: (_) => ActivitiesController(repository: repository)..load(),
        child: const ActivitiesPage(),
      ),
    );
  }

  static Future<bool> activityEditor(BuildContext context) async {
    final repository = _repository(context);
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => Provider<TeacherRepository>.value(
          value: repository,
          child: ChangeNotifierProvider(
            create: (_) =>
                ActivityComposerController(repository: repository)..load(),
            child: const ActivityEditorPage(),
          ),
        ),
      ),
    );
    return saved == true;
  }

  static Future<void> activityDetails(
    BuildContext context,
    TeacherActivity activity,
  ) {
    return _push(context, ActivityDetailsPage(activity: activity));
  }

  static Future<void> albums(BuildContext context) {
    final repository = _repository(context);
    return _push(
      context,
      ChangeNotifierProvider(
        create: (_) => AlbumsController(repository: repository)..load(),
        child: const AlbumsPage(),
      ),
    );
  }

  static Future<void> albumDetails(BuildContext context, TeacherAlbum album) {
    return _push(context, AlbumDetailsPage(album: album));
  }

  static Future<void> noticeEditor(
    BuildContext context, {
    TeacherNotice? notice,
  }) {
    final repository = _repository(context);
    return _push(
      context,
      ChangeNotifierProvider(
        create: (_) =>
            NoticeComposerController(repository: repository)..load(),
        child: NoticeEditorPage(notice: notice),
      ),
    );
  }

  static Future<void> myClasses(BuildContext context) {
    final repository = _repository(context);
    return _push(
      context,
      ChangeNotifierProvider(
        create: (_) => MyClassesController(repository: repository)..load(),
        child: const MyClassesPage(),
      ),
    );
  }

  static Future<void> allClassSchedules(BuildContext context) {
    final repository = _repository(context);
    return _push(
      context,
      ChangeNotifierProvider(
        create: (_) =>
            AllClassSchedulesController(repository: repository)..load(),
        child: const AllClassSchedulesPage(),
      ),
    );
  }

  static Future<void> classDetails(
    BuildContext context,
    TeacherClassSummary classSummary,
  ) {
    final repository = _repository(context);
    return _push(
      context,
      ChangeNotifierProvider(
        create: (_) => ClassDetailsController(repository: repository)
          ..load(classSummary.id),
        child: ClassDetailsPage(classSummary: classSummary),
      ),
    );
  }

  static Future<void> settings(BuildContext context) =>
      _push(context, const SettingsPage());

  static Future<void> language(BuildContext context) =>
      _push(context, const LanguagePage());

  static Future<void> routeFromNotification(
    BuildContext context,
    AppNotification notification,
  ) async {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.popUntil((route) => route.isFirst);
    }

    switch (notification.route) {
      case 'schedule':
        await schedule(context);
      case 'agenda':
        await agenda(context);
      case 'grades':
        await grades(context);
      case 'notices' || 'notice':
        await notices(context);
      case 'announcements' || 'announcement':
        await announcements(context);
      case 'activities' || 'activity':
        await activities(context);
      case 'albums' || 'album':
        await albums(context);
      case 'classes' || 'my-classes':
        await myClasses(context);
      case 'class-schedules':
        await allClassSchedules(context);
      default:
        return;
    }
  }

  static Future<void> _push(BuildContext context, Widget page) {
    final repository = _repository(context);
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => Provider<TeacherRepository>.value(
          value: repository,
          child: page,
        ),
      ),
    );
  }
}
