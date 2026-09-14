import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'My School Teacher'**
  String get appName;

  /// No description provided for @schoolName.
  ///
  /// In en, this message translates to:
  /// **'Makarem Preparatory School'**
  String get schoolName;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Everything about your teaching day, in one place.'**
  String get loginSubtitle;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @credentialsRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your username and password.'**
  String get credentialsRequired;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @yourSchoolDay.
  ///
  /// In en, this message translates to:
  /// **'Your school day'**
  String get yourSchoolDay;

  /// No description provided for @switchChild.
  ///
  /// In en, this message translates to:
  /// **'Switch child'**
  String get switchChild;

  /// No description provided for @selectedChild.
  ///
  /// In en, this message translates to:
  /// **'Selected child'**
  String get selectedChild;

  /// No description provided for @children.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get children;

  /// No description provided for @allChildren.
  ///
  /// In en, this message translates to:
  /// **'All children'**
  String get allChildren;

  /// No description provided for @childrenCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 child} other{{count} children}}'**
  String childrenCount(int count);

  /// No description provided for @childDetails.
  ///
  /// In en, this message translates to:
  /// **'Child details'**
  String get childDetails;

  /// No description provided for @classLabel.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get classLabel;

  /// No description provided for @sectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get sectionLabel;

  /// No description provided for @academicYear.
  ///
  /// In en, this message translates to:
  /// **'Academic year'**
  String get academicYear;

  /// No description provided for @stage.
  ///
  /// In en, this message translates to:
  /// **'Stage'**
  String get stage;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirth;

  /// No description provided for @motherName.
  ///
  /// In en, this message translates to:
  /// **'Mother'**
  String get motherName;

  /// No description provided for @weeklySchedule.
  ///
  /// In en, this message translates to:
  /// **'Weekly schedule'**
  String get weeklySchedule;

  /// No description provided for @agenda.
  ///
  /// In en, this message translates to:
  /// **'Agenda'**
  String get agenda;

  /// No description provided for @agendaDetails.
  ///
  /// In en, this message translates to:
  /// **'Agenda details'**
  String get agendaDetails;

  /// No description provided for @grades.
  ///
  /// In en, this message translates to:
  /// **'Grades'**
  String get grades;

  /// No description provided for @noGrades.
  ///
  /// In en, this message translates to:
  /// **'No published grades yet.'**
  String get noGrades;

  /// No description provided for @notices.
  ///
  /// In en, this message translates to:
  /// **'Notices'**
  String get notices;

  /// No description provided for @noNotices.
  ///
  /// In en, this message translates to:
  /// **'No notices for this child.'**
  String get noNotices;

  /// No description provided for @examSchedule.
  ///
  /// In en, this message translates to:
  /// **'Exam schedule'**
  String get examSchedule;

  /// No description provided for @noExamSchedule.
  ///
  /// In en, this message translates to:
  /// **'No published exam schedule.'**
  String get noExamSchedule;

  /// No description provided for @directNotice.
  ///
  /// In en, this message translates to:
  /// **'Direct notice'**
  String get directNotice;

  /// No description provided for @sectionNotice.
  ///
  /// In en, this message translates to:
  /// **'Section notice'**
  String get sectionNotice;

  /// No description provided for @publishedOn.
  ///
  /// In en, this message translates to:
  /// **'Published on'**
  String get publishedOn;

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String durationMinutes(int count);

  /// No description provided for @announcements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get announcements;

  /// No description provided for @announcementDetails.
  ///
  /// In en, this message translates to:
  /// **'Announcement details'**
  String get announcementDetails;

  /// No description provided for @attendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendance;

  /// No description provided for @activities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get activities;

  /// No description provided for @activityDetails.
  ///
  /// In en, this message translates to:
  /// **'Activity details'**
  String get activityDetails;

  /// No description provided for @albums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get albums;

  /// No description provided for @albumDetails.
  ///
  /// In en, this message translates to:
  /// **'Album details'**
  String get albumDetails;

  /// No description provided for @aboutSchool.
  ///
  /// In en, this message translates to:
  /// **'About school'**
  String get aboutSchool;

  /// No description provided for @contactSchool.
  ///
  /// In en, this message translates to:
  /// **'Contact school'**
  String get contactSchool;

  /// No description provided for @contactSchoolSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reach the school quickly using the option that works best for you.'**
  String get contactSchoolSubtitle;

  /// No description provided for @callSchool.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get callSchool;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @directions.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directions;

  /// No description provided for @visitWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get visitWebsite;

  /// No description provided for @openContactFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open that app. Please try again.'**
  String get openContactFailed;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profileDetails.
  ///
  /// In en, this message translates to:
  /// **'Profile details'**
  String get profileDetails;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @parentRole.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get parentRole;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPassword;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get fieldRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters.'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @currentPasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'The current password is incorrect.'**
  String get currentPasswordIncorrect;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully.'**
  String get passwordUpdated;

  /// No description provided for @passwordUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Password could not be updated.'**
  String get passwordUpdateFailed;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @periodNumber.
  ///
  /// In en, this message translates to:
  /// **'Period {number}'**
  String periodNumber(int number);

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @previousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get nextMonth;

  /// No description provided for @attachment.
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get attachment;

  /// No description provided for @attachPdf.
  ///
  /// In en, this message translates to:
  /// **'Attach PDF'**
  String get attachPdf;

  /// No description provided for @choosePdf.
  ///
  /// In en, this message translates to:
  /// **'Choose a PDF file'**
  String get choosePdf;

  /// No description provided for @pdfOnly.
  ///
  /// In en, this message translates to:
  /// **'Please choose a PDF file.'**
  String get pdfOnly;

  /// No description provided for @pdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// No description provided for @attachImage.
  ///
  /// In en, this message translates to:
  /// **'Attach image'**
  String get attachImage;

  /// No description provided for @chooseImage.
  ///
  /// In en, this message translates to:
  /// **'Choose an image'**
  String get chooseImage;

  /// No description provided for @imageOnly.
  ///
  /// In en, this message translates to:
  /// **'Please choose an image.'**
  String get imageOnly;

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading…'**
  String get uploading;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not upload that file. Please try again.'**
  String get uploadFailed;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @published.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get published;

  /// No description provided for @draft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draft;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// No description provided for @publishedBy.
  ///
  /// In en, this message translates to:
  /// **'Published by {name}'**
  String publishedBy(String name);

  /// No description provided for @noAgenda.
  ///
  /// In en, this message translates to:
  /// **'No agenda entries for this date.'**
  String get noAgenda;

  /// No description provided for @agendaAvailable.
  ///
  /// In en, this message translates to:
  /// **'Agenda available'**
  String get agendaAvailable;

  /// No description provided for @noAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'There are no announcements yet.'**
  String get noAnnouncements;

  /// No description provided for @noActivities.
  ///
  /// In en, this message translates to:
  /// **'There are no activities yet.'**
  String get noActivities;

  /// No description provided for @noAlbums.
  ///
  /// In en, this message translates to:
  /// **'There are no albums yet.'**
  String get noAlbums;

  /// No description provided for @noPublishedPhotos.
  ///
  /// In en, this message translates to:
  /// **'No photos have been published in this album.'**
  String get noPublishedPhotos;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No photos} =1{1 photo} other{{count} photos}}'**
  String photos(int count);

  /// No description provided for @present.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get present;

  /// No description provided for @absent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get absent;

  /// No description provided for @late.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get late;

  /// No description provided for @excused.
  ///
  /// In en, this message translates to:
  /// **'Excused'**
  String get excused;

  /// No description provided for @attendanceRate.
  ///
  /// In en, this message translates to:
  /// **'Attendance rate'**
  String get attendanceRate;

  /// No description provided for @noAttendanceExceptions.
  ///
  /// In en, this message translates to:
  /// **'No attendance exceptions this month.'**
  String get noAttendanceExceptions;

  /// No description provided for @daysRecorded.
  ///
  /// In en, this message translates to:
  /// **'{count} days recorded'**
  String daysRecorded(int count);

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @schoolInformation.
  ///
  /// In en, this message translates to:
  /// **'School information'**
  String get schoolInformation;

  /// No description provided for @telephone.
  ///
  /// In en, this message translates to:
  /// **'Telephone'**
  String get telephone;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// No description provided for @fax.
  ///
  /// In en, this message translates to:
  /// **'Fax'**
  String get fax;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @application.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get application;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get somethingWentWrong;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get viewDetails;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @teacherHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your teaching tools for today'**
  String get teacherHomeSubtitle;

  /// No description provided for @mySchedule.
  ///
  /// In en, this message translates to:
  /// **'My schedule'**
  String get mySchedule;

  /// No description provided for @noSchedule.
  ///
  /// In en, this message translates to:
  /// **'No weekly schedule has been assigned yet.'**
  String get noSchedule;

  /// No description provided for @myClasses.
  ///
  /// In en, this message translates to:
  /// **'My classes'**
  String get myClasses;

  /// No description provided for @allClassSchedules.
  ///
  /// In en, this message translates to:
  /// **'All class schedules'**
  String get allClassSchedules;

  /// No description provided for @noAssignedClasses.
  ///
  /// In en, this message translates to:
  /// **'No assigned classes yet.'**
  String get noAssignedClasses;

  /// No description provided for @noClassesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No classes available.'**
  String get noClassesAvailable;

  /// No description provided for @noClassDetails.
  ///
  /// In en, this message translates to:
  /// **'No class details available.'**
  String get noClassDetails;

  /// No description provided for @students.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get students;

  /// No description provided for @teachers.
  ///
  /// In en, this message translates to:
  /// **'Teachers'**
  String get teachers;

  /// No description provided for @yourAssignment.
  ///
  /// In en, this message translates to:
  /// **'Your class'**
  String get yourAssignment;

  /// No description provided for @seatNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Seat'**
  String get seatNumberLabel;

  /// No description provided for @room.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get room;

  /// No description provided for @assignment.
  ///
  /// In en, this message translates to:
  /// **'Assignment'**
  String get assignment;

  /// No description provided for @addAgenda.
  ///
  /// In en, this message translates to:
  /// **'Add agenda'**
  String get addAgenda;

  /// No description provided for @editAgenda.
  ///
  /// In en, this message translates to:
  /// **'Edit agenda'**
  String get editAgenda;

  /// No description provided for @agendaDescription.
  ///
  /// In en, this message translates to:
  /// **'Agenda details'**
  String get agendaDescription;

  /// No description provided for @agendaDate.
  ///
  /// In en, this message translates to:
  /// **'Agenda date'**
  String get agendaDate;

  /// No description provided for @noAgendaItems.
  ///
  /// In en, this message translates to:
  /// **'No agenda items created yet.'**
  String get noAgendaItems;

  /// No description provided for @showAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get showAll;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @parentsSeePublished.
  ///
  /// In en, this message translates to:
  /// **'Parents only see published agenda items.'**
  String get parentsSeePublished;

  /// No description provided for @addGrades.
  ///
  /// In en, this message translates to:
  /// **'Add grades'**
  String get addGrades;

  /// No description provided for @editGrades.
  ///
  /// In en, this message translates to:
  /// **'Edit grades'**
  String get editGrades;

  /// No description provided for @allStudentsAlreadyGraded.
  ///
  /// In en, this message translates to:
  /// **'All students already have grades for this assessment.'**
  String get allStudentsAlreadyGraded;

  /// No description provided for @noGradeAssessments.
  ///
  /// In en, this message translates to:
  /// **'No grade assessments created yet.'**
  String get noGradeAssessments;

  /// No description provided for @entriesLabel.
  ///
  /// In en, this message translates to:
  /// **'entries'**
  String get entriesLabel;

  /// No description provided for @assessmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Assessment title'**
  String get assessmentTitle;

  /// No description provided for @assessmentType.
  ///
  /// In en, this message translates to:
  /// **'Assessment type'**
  String get assessmentType;

  /// No description provided for @maxGradeLabel.
  ///
  /// In en, this message translates to:
  /// **'Maximum grade'**
  String get maxGradeLabel;

  /// No description provided for @scoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get scoreLabel;

  /// No description provided for @atLeastOneGradeRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a score for at least one student.'**
  String get atLeastOneGradeRequired;

  /// No description provided for @publishDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Publish date'**
  String get publishDateLabel;

  /// No description provided for @addNotice.
  ///
  /// In en, this message translates to:
  /// **'Add notice'**
  String get addNotice;

  /// No description provided for @editNotice.
  ///
  /// In en, this message translates to:
  /// **'Edit notice'**
  String get editNotice;

  /// No description provided for @noNoticesCreated.
  ///
  /// In en, this message translates to:
  /// **'No notices created yet.'**
  String get noNoticesCreated;

  /// No description provided for @selectClass.
  ///
  /// In en, this message translates to:
  /// **'Select class'**
  String get selectClass;

  /// No description provided for @selectSection.
  ///
  /// In en, this message translates to:
  /// **'Select section'**
  String get selectSection;

  /// No description provided for @selectCourse.
  ///
  /// In en, this message translates to:
  /// **'Select course'**
  String get selectCourse;

  /// No description provided for @selectClassSectionCourse.
  ///
  /// In en, this message translates to:
  /// **'Select your class, section, and course to load students.'**
  String get selectClassSectionCourse;

  /// No description provided for @coefficientLabel.
  ///
  /// In en, this message translates to:
  /// **'Coefficient'**
  String get coefficientLabel;

  /// No description provided for @allClasses.
  ///
  /// In en, this message translates to:
  /// **'All classes'**
  String get allClasses;

  /// No description provided for @allSections.
  ///
  /// In en, this message translates to:
  /// **'All sections'**
  String get allSections;

  /// No description provided for @allCourses.
  ///
  /// In en, this message translates to:
  /// **'All courses'**
  String get allCourses;

  /// No description provided for @allGradeTypes.
  ///
  /// In en, this message translates to:
  /// **'All types'**
  String get allGradeTypes;

  /// No description provided for @noMatchingGrades.
  ///
  /// In en, this message translates to:
  /// **'No grade sheets match these filters.'**
  String get noMatchingGrades;

  /// No description provided for @loadGrades.
  ///
  /// In en, this message translates to:
  /// **'Load'**
  String get loadGrades;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// No description provided for @selectFiltersToLoadGrades.
  ///
  /// In en, this message translates to:
  /// **'Select class, section, and course, then tap Load.'**
  String get selectFiltersToLoadGrades;

  /// No description provided for @selectStudent.
  ///
  /// In en, this message translates to:
  /// **'Select student'**
  String get selectStudent;

  /// No description provided for @sendToEntireClass.
  ///
  /// In en, this message translates to:
  /// **'Entire class'**
  String get sendToEntireClass;

  /// No description provided for @changeClass.
  ///
  /// In en, this message translates to:
  /// **'Change class'**
  String get changeClass;

  /// No description provided for @noStudentsInClass.
  ///
  /// In en, this message translates to:
  /// **'No students in this class.'**
  String get noStudentsInClass;

  /// No description provided for @targetTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Target type'**
  String get targetTypeLabel;

  /// No description provided for @targetStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get targetStudent;

  /// No description provided for @targetSection.
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get targetSection;

  /// No description provided for @noticeContent.
  ///
  /// In en, this message translates to:
  /// **'Notice content'**
  String get noticeContent;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteItemQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete this item?'**
  String get deleteItemQuestion;

  /// No description provided for @titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleLabel;

  /// No description provided for @departmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get departmentLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
