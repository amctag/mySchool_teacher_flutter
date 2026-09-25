// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'MS Teacher';

  @override
  String get schoolName => 'Makarem Preparatory School';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get loginSubtitle =>
      'Everything about your teaching day, in one place.';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign in';

  @override
  String get support => 'Support';

  @override
  String get supportSubtitle =>
      'Contact your school for help with your account.';

  @override
  String get supportId => 'ID';

  @override
  String get supportIdRequired => 'Enter your ID to contact support.';

  @override
  String get supportNoSchools =>
      'No school contact details were found for this ID.';

  @override
  String get supportLoadFailed => 'Could not load school support details.';

  @override
  String get supportLookup => 'Find school contact';

  @override
  String get credentialsRequired => 'Enter your ID and password.';

  @override
  String get accountInactiveTitle => 'Cannot sign in';

  @override
  String get accountInactiveBody =>
      'This account is inactive. You cannot log in. Contact support for help.';

  @override
  String get accountUnpaidTitle => 'Cannot sign in';

  @override
  String get accountUnpaidBody =>
      'Payment is required for this account. You cannot log in. Contact support for help.';

  @override
  String get contactSupport => 'Contact support';

  @override
  String get home => 'Home';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get yourSchoolDay => 'Your school day';

  @override
  String get switchChild => 'Switch child';

  @override
  String get selectedChild => 'Selected child';

  @override
  String get children => 'Children';

  @override
  String get allChildren => 'All children';

  @override
  String childrenCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count children',
      one: '1 child',
    );
    return '$_temp0';
  }

  @override
  String get childDetails => 'Child details';

  @override
  String get classLabel => 'Class';

  @override
  String get sectionLabel => 'Section';

  @override
  String get academicYear => 'Academic year';

  @override
  String get stage => 'Stage';

  @override
  String get dateOfBirth => 'Date of birth';

  @override
  String get motherName => 'Mother';

  @override
  String get weeklySchedule => 'Weekly schedule';

  @override
  String get courses => 'Courses';

  @override
  String get noCourses => 'No courses for this class.';

  @override
  String get agenda => 'Agenda';

  @override
  String get agendaDetails => 'Agenda details';

  @override
  String get grades => 'Grades';

  @override
  String get noGrades => 'No published grades yet.';

  @override
  String get notices => 'Remarque';

  @override
  String get noNotices => 'No remarques for this child.';

  @override
  String get examSchedule => 'Exam schedule';

  @override
  String get noExamSchedule => 'No published exam schedule.';

  @override
  String get directNotice => 'Direct remarque';

  @override
  String get sectionNotice => 'Section remarque';

  @override
  String get publishedOn => 'Published on';

  @override
  String durationMinutes(int count) {
    return '$count min';
  }

  @override
  String get announcements => 'Notice';

  @override
  String get announcementDetails => 'Notice details';

  @override
  String get attendance => 'Attendance';

  @override
  String get takeAttendance => 'Take attendance';

  @override
  String get noAttendanceRecords => 'No attendance recorded for this date.';

  @override
  String get attendanceViewOnly =>
      'You can view class attendance. Taking attendance is not enabled for teachers at this school.';

  @override
  String get noEligibleAttendance =>
      'You cannot take attendance for any class today.';

  @override
  String get attendanceDate => 'Attendance date';

  @override
  String get attendanceReasonRequired =>
      'Choose a reason for each absent student.';

  @override
  String get markAllPresent => 'Mark all present';

  @override
  String absentStudentsCount(int count) {
    return '$count absent';
  }

  @override
  String get activities => 'Activities';

  @override
  String get activityDetails => 'Activity details';

  @override
  String get albums => 'Albums';

  @override
  String get albumDetails => 'Album details';

  @override
  String get aboutSchool => 'About school';

  @override
  String get contactSchool => 'Contact school';

  @override
  String get contactSchoolSubtitle =>
      'Reach the school quickly using the option that works best for you.';

  @override
  String get callSchool => 'Call';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get directions => 'Directions';

  @override
  String get visitWebsite => 'Website';

  @override
  String get openContactFailed => 'Could not open that app. Please try again.';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get profileDetails => 'Profile details';

  @override
  String get role => 'Role';

  @override
  String get parentRole => 'Parent';

  @override
  String get changePassword => 'Change password';

  @override
  String get currentPassword => 'Current password';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get fieldRequired => 'This field is required.';

  @override
  String get passwordTooShort => 'Use at least 8 characters.';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match.';

  @override
  String get currentPasswordIncorrect => 'The current password is incorrect.';

  @override
  String get passwordUpdated => 'Password updated successfully.';

  @override
  String get passwordUpdateFailed => 'Password could not be updated.';

  @override
  String get logout => 'Log out';

  @override
  String get period => 'Period';

  @override
  String periodNumber(int number) {
    return 'Period $number';
  }

  @override
  String get note => 'Note';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get attachment => 'Attachment';

  @override
  String get attachPdf => 'Attach PDF';

  @override
  String get choosePdf => 'Choose a PDF file';

  @override
  String get pdfOnly => 'Please choose a PDF file.';

  @override
  String get pdf => 'PDF';

  @override
  String get attachImage => 'Attach image';

  @override
  String get chooseImage => 'Choose an image';

  @override
  String get imageOnly => 'Please choose an image.';

  @override
  String get uploading => 'Uploading…';

  @override
  String get uploadFailed => 'Could not upload that file. Please try again.';

  @override
  String get publish => 'Publish';

  @override
  String get published => 'Published';

  @override
  String get draft => 'Draft';

  @override
  String get you => 'You';

  @override
  String get image => 'Image';

  @override
  String get file => 'File';

  @override
  String publishedBy(String name) {
    return 'Published by $name';
  }

  @override
  String get noAgenda => 'No agenda entries for this date.';

  @override
  String get agendaAvailable => 'Agenda available';

  @override
  String get noAnnouncements => 'There are no notices yet.';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'No notifications yet.';

  @override
  String get tasks => 'Tasks';

  @override
  String get noTasks => 'No tasks yet.';

  @override
  String get openTasks => 'Open';

  @override
  String get completedTasks => 'Completed';

  @override
  String get markTaskDone => 'Mark done';

  @override
  String get noOpenTasks => 'You\'re all caught up.';

  @override
  String openTasksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count open tasks',
      one: '1 open task',
    );
    return '$_temp0';
  }

  @override
  String get noActivities => 'There are no activities yet.';

  @override
  String get noAlbums => 'There are no albums yet.';

  @override
  String get noPublishedPhotos =>
      'No photos have been published in this album.';

  @override
  String photos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos',
      one: '1 photo',
      zero: 'No photos',
    );
    return '$_temp0';
  }

  @override
  String get present => 'Present';

  @override
  String get absent => 'Absent';

  @override
  String get late => 'Late';

  @override
  String get excused => 'Excused';

  @override
  String get attendanceRate => 'Attendance rate';

  @override
  String get noAttendanceExceptions => 'No attendance exceptions this month.';

  @override
  String daysRecorded(int count) {
    return '$count days recorded';
  }

  @override
  String get reason => 'Reason';

  @override
  String get schoolInformation => 'School information';

  @override
  String get telephone => 'Telephone';

  @override
  String get mobile => 'Mobile';

  @override
  String get fax => 'Fax';

  @override
  String get address => 'Address';

  @override
  String get email => 'Email';

  @override
  String get website => 'Website';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get french => 'French';

  @override
  String get arabic => 'Arabic';

  @override
  String get theme => 'Theme';

  @override
  String get systemTheme => 'System';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get account => 'Account';

  @override
  String get appearance => 'Appearance';

  @override
  String get application => 'Application';

  @override
  String get version => 'Version 1.0.0';

  @override
  String get loading => 'Loading…';

  @override
  String get somethingWentWrong => 'Something went wrong.';

  @override
  String get retry => 'Try again';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get viewDetails => 'View details';

  @override
  String get today => 'Today';

  @override
  String get teacherHomeSubtitle => 'Your teaching tools for today';

  @override
  String get mySchedule => 'My schedule';

  @override
  String get noSchedule => 'No weekly schedule has been assigned yet.';

  @override
  String get myClasses => 'My classes';

  @override
  String get allClassSchedules => 'All class schedules';

  @override
  String get noAssignedClasses => 'No assigned classes yet.';

  @override
  String get noClassesAvailable => 'No classes available.';

  @override
  String get noClassDetails => 'No class details available.';

  @override
  String get students => 'Students';

  @override
  String get teachers => 'Teachers';

  @override
  String get yourAssignment => 'Your class';

  @override
  String get seatNumberLabel => 'Seat';

  @override
  String get room => 'Room';

  @override
  String get assignment => 'Assignment';

  @override
  String get addAgenda => 'Add agenda';

  @override
  String get addActivity => 'Add activity';

  @override
  String get activityDate => 'Activity date';

  @override
  String get activityContent => 'Activity details';

  @override
  String get editAgenda => 'Edit agenda';

  @override
  String get agendaDescription => 'Agenda details';

  @override
  String get agendaDate => 'Agenda date';

  @override
  String get noAgendaItems => 'No agenda items created yet.';

  @override
  String get showAll => 'All';

  @override
  String get attachments => 'Attachments';

  @override
  String get optional => 'Optional';

  @override
  String get parentsSeePublished => 'Parents only see published agenda items.';

  @override
  String get schoolPublishesAgenda =>
      'The school publishes agenda items. You can save drafts only.';

  @override
  String get addGrades => 'Add grades';

  @override
  String get editGrades => 'Edit grades';

  @override
  String get allStudentsAlreadyGraded =>
      'All students already have grades for this assessment.';

  @override
  String get assessmentAlreadyExists => 'Already graded';

  @override
  String get selectClassSectionCourseFirst =>
      'Select class, section, and course first.';

  @override
  String get noGradeAssessments => 'No grade assessments created yet.';

  @override
  String get entriesLabel => 'entries';

  @override
  String get assessmentTitle => 'Assessment title';

  @override
  String get assessmentType => 'Assessment type';

  @override
  String get maxGradeLabel => 'Maximum grade';

  @override
  String get scoreLabel => 'Score';

  @override
  String get atLeastOneGradeRequired =>
      'Enter a score for at least one student.';

  @override
  String get publishDateLabel => 'Publish date';

  @override
  String get addNotice => 'Add remarque';

  @override
  String get addAnnouncement => 'Add announcement';

  @override
  String get announcementAudience => 'Audience';

  @override
  String get audienceParent => 'Parents';

  @override
  String get audienceTeacher => 'Teachers';

  @override
  String get editNotice => 'Edit remarque';

  @override
  String get noNoticesCreated => 'No remarques created yet.';

  @override
  String get selectClass => 'Select class';

  @override
  String get selectSection => 'Select section';

  @override
  String get selectCourse => 'Select course';

  @override
  String get selectClassSectionCourse =>
      'Select your class, section, and course to load students.';

  @override
  String get coefficientLabel => 'Coefficient';

  @override
  String get allClasses => 'All classes';

  @override
  String get allSections => 'All sections';

  @override
  String get allCourses => 'All courses';

  @override
  String get allGradeTypes => 'All types';

  @override
  String get noMatchingGrades => 'No grade sheets match these filters.';

  @override
  String get loadGrades => 'Load';

  @override
  String get filters => 'Filters';

  @override
  String get loadMore => 'Load more';

  @override
  String get selectFiltersToLoadGrades =>
      'Select class, section, and course, then tap Load.';

  @override
  String get selectStudent => 'Select student';

  @override
  String get sendToEntireClass => 'Entire class';

  @override
  String get changeClass => 'Change class';

  @override
  String get noStudentsInClass => 'No students in this class.';

  @override
  String get targetTypeLabel => 'Target type';

  @override
  String get targetStudent => 'Student';

  @override
  String get targetSection => 'Section';

  @override
  String get noticeContent => 'Remarque content';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get deleteItemQuestion => 'Delete this item?';

  @override
  String get titleLabel => 'Title';

  @override
  String get departmentLabel => 'Department';
}
