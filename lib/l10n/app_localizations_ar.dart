// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'معلم مدرستي';

  @override
  String get schoolName => 'مدرسة مكارم الإعدادية';

  @override
  String get welcomeBack => 'أهلاً بعودتك';

  @override
  String get loginSubtitle => 'كل ما يخص يومك التعليمي في مكان واحد.';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get password => 'كلمة المرور';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get credentialsRequired => 'أدخل اسم المستخدم وكلمة المرور.';

  @override
  String get home => 'الرئيسية';

  @override
  String get goodMorning => 'صباح الخير';

  @override
  String get goodAfternoon => 'مساء الخير';

  @override
  String get goodEvening => 'مساء الخير';

  @override
  String get yourSchoolDay => 'يومك المدرسي';

  @override
  String get switchChild => 'تبديل الطالب';

  @override
  String get selectedChild => 'الطالب المختار';

  @override
  String get children => 'الأولاد';

  @override
  String get allChildren => 'كل الأولاد';

  @override
  String childrenCount(int count) {
    return '$count أولاد';
  }

  @override
  String get childDetails => 'تفاصيل الطالب';

  @override
  String get classLabel => 'الصف';

  @override
  String get sectionLabel => 'الشعبة';

  @override
  String get academicYear => 'العام الدراسي';

  @override
  String get stage => 'المرحلة';

  @override
  String get dateOfBirth => 'تاريخ الميلاد';

  @override
  String get motherName => 'الأم';

  @override
  String get weeklySchedule => 'البرنامج الأسبوعي';

  @override
  String get agenda => 'المفكرة';

  @override
  String get agendaDetails => 'تفاصيل المفكرة';

  @override
  String get grades => 'العلامات';

  @override
  String get noGrades => 'لا توجد علامات منشورة حتى الآن.';

  @override
  String get notices => 'الإشعارات';

  @override
  String get noNotices => 'لا توجد إشعارات لهذا الطالب.';

  @override
  String get examSchedule => 'برنامج الامتحان';

  @override
  String get noExamSchedule => 'لا يوجد برنامج امتحان منشور.';

  @override
  String get directNotice => 'إشعار مباشر';

  @override
  String get sectionNotice => 'إشعار الشعبة';

  @override
  String get publishedOn => 'نشر في';

  @override
  String durationMinutes(int count) {
    return '$count دقيقة';
  }

  @override
  String get announcements => 'الإعلانات';

  @override
  String get announcementDetails => 'تفاصيل الإعلان';

  @override
  String get attendance => 'الحضور';

  @override
  String get activities => 'النشاطات';

  @override
  String get activityDetails => 'تفاصيل النشاط';

  @override
  String get albums => 'الألبومات';

  @override
  String get albumDetails => 'تفاصيل الألبوم';

  @override
  String get aboutSchool => 'عن المدرسة';

  @override
  String get contactSchool => 'اتصل بالمدرسة';

  @override
  String get contactSchoolSubtitle =>
      'تواصل مع المدرسة بسرعة بالطريقة الأنسب لك.';

  @override
  String get callSchool => 'اتصال';

  @override
  String get whatsapp => 'واتساب';

  @override
  String get directions => 'الاتجاهات';

  @override
  String get visitWebsite => 'الموقع';

  @override
  String get openContactFailed => 'تعذر فتح التطبيق. حاول مرة أخرى.';

  @override
  String get settings => 'الإعدادات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get profileDetails => 'تفاصيل الملف الشخصي';

  @override
  String get role => 'الدور';

  @override
  String get parentRole => 'ولي أمر';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get confirmNewPassword => 'تأكيد كلمة المرور الجديدة';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب.';

  @override
  String get passwordTooShort => 'استخدم 8 أحرف على الأقل.';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get currentPasswordIncorrect => 'كلمة المرور الحالية غير صحيحة.';

  @override
  String get passwordUpdated => 'تم تحديث كلمة المرور بنجاح.';

  @override
  String get passwordUpdateFailed => 'تعذر تحديث كلمة المرور.';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get period => 'الحصة';

  @override
  String periodNumber(int number) {
    return 'الحصة $number';
  }

  @override
  String get note => 'ملاحظة';

  @override
  String get previousMonth => 'الشهر السابق';

  @override
  String get nextMonth => 'الشهر التالي';

  @override
  String get attachment => 'مرفق';

  @override
  String get attachPdf => 'إرفاق PDF';

  @override
  String get choosePdf => 'اختر ملف PDF';

  @override
  String get pdfOnly => 'يرجى اختيار ملف PDF.';

  @override
  String get pdf => 'PDF';

  @override
  String get attachImage => 'إرفاق صورة';

  @override
  String get chooseImage => 'اختر صورة';

  @override
  String get imageOnly => 'يرجى اختيار صورة.';

  @override
  String get uploading => 'جارٍ الرفع…';

  @override
  String get uploadFailed => 'تعذر رفع الملف. يرجى المحاولة مرة أخرى.';

  @override
  String get publish => 'نشر';

  @override
  String get published => 'منشور';

  @override
  String get draft => 'مسودة';

  @override
  String get image => 'صورة';

  @override
  String get file => 'ملف';

  @override
  String publishedBy(String name) {
    return 'نشر بواسطة $name';
  }

  @override
  String get noAgenda => 'لا توجد مفكرة لهذا التاريخ.';

  @override
  String get agendaAvailable => 'توجد مفكرة';

  @override
  String get noAnnouncements => 'لا توجد إعلانات حتى الآن.';

  @override
  String get noActivities => 'لا توجد نشاطات حتى الآن.';

  @override
  String get noAlbums => 'لا توجد ألبومات حتى الآن.';

  @override
  String get noPublishedPhotos => 'لم يتم نشر صور في هذا الألبوم.';

  @override
  String photos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count صور',
      one: 'صورة واحدة',
      zero: 'لا صور',
    );
    return '$_temp0';
  }

  @override
  String get present => 'حاضر';

  @override
  String get absent => 'غائب';

  @override
  String get late => 'متأخر';

  @override
  String get excused => 'بعذر';

  @override
  String get attendanceRate => 'نسبة الحضور';

  @override
  String get noAttendanceExceptions =>
      'لا توجد حالات غياب أو تأخير أو أعذار هذا الشهر.';

  @override
  String daysRecorded(int count) {
    return 'تم تسجيل $count يوماً';
  }

  @override
  String get reason => 'السبب';

  @override
  String get schoolInformation => 'معلومات المدرسة';

  @override
  String get telephone => 'الهاتف';

  @override
  String get mobile => 'الجوال';

  @override
  String get fax => 'الفاكس';

  @override
  String get address => 'العنوان';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get website => 'الموقع الإلكتروني';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get theme => 'المظهر';

  @override
  String get systemTheme => 'النظام';

  @override
  String get lightTheme => 'فاتح';

  @override
  String get darkTheme => 'داكن';

  @override
  String get account => 'الحساب';

  @override
  String get appearance => 'المظهر';

  @override
  String get application => 'التطبيق';

  @override
  String get version => 'الإصدار 1.0.0';

  @override
  String get loading => 'جارٍ التحميل…';

  @override
  String get somethingWentWrong => 'حدث خطأ ما.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get close => 'إغلاق';

  @override
  String get back => 'رجوع';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String get today => 'اليوم';

  @override
  String get teacherHomeSubtitle => 'أدواتك التعليمية لليوم';

  @override
  String get mySchedule => 'برنامجي';

  @override
  String get noSchedule => 'لم يتم تعيين برنامج أسبوعي بعد.';

  @override
  String get myClasses => 'صفوفي';

  @override
  String get allClassSchedules => 'كل برامج الصفوف';

  @override
  String get noAssignedClasses => 'لا توجد صفوف مكلّف بها بعد.';

  @override
  String get noClassesAvailable => 'لا توجد صفوف متاحة.';

  @override
  String get noClassDetails => 'لا توجد تفاصيل متاحة لهذا الصف.';

  @override
  String get students => 'الطلاب';

  @override
  String get teachers => 'المعلمون';

  @override
  String get yourAssignment => 'صفك';

  @override
  String get seatNumberLabel => 'المقعد';

  @override
  String get room => 'القاعة';

  @override
  String get assignment => 'التكليف';

  @override
  String get addAgenda => 'إضافة مفكرة';

  @override
  String get editAgenda => 'تعديل المفكرة';

  @override
  String get agendaDescription => 'تفاصيل المفكرة';

  @override
  String get agendaDate => 'تاريخ المفكرة';

  @override
  String get noAgendaItems => 'لا توجد عناصر مفكرة مضافة بعد.';

  @override
  String get showAll => 'الكل';

  @override
  String get attachments => 'المرفقات';

  @override
  String get optional => 'اختياري';

  @override
  String get parentsSeePublished =>
      'يرى أولياء الأمور عناصر المفكرة المنشورة فقط.';

  @override
  String get addGrades => 'إضافة علامات';

  @override
  String get editGrades => 'تعديل العلامات';

  @override
  String get allStudentsAlreadyGraded =>
      'جميع الطلاب لديهم علامات لهذا التقييم.';

  @override
  String get noGradeAssessments => 'لا توجد تقييمات علامات مضافة بعد.';

  @override
  String get entriesLabel => 'إدخالات';

  @override
  String get assessmentTitle => 'عنوان التقييم';

  @override
  String get assessmentType => 'نوع التقييم';

  @override
  String get maxGradeLabel => 'العلامة القصوى';

  @override
  String get scoreLabel => 'العلامة';

  @override
  String get atLeastOneGradeRequired => 'أدخل علامة لطالب واحد على الأقل.';

  @override
  String get publishDateLabel => 'تاريخ النشر';

  @override
  String get addNotice => 'إضافة إشعار';

  @override
  String get editNotice => 'تعديل الإشعار';

  @override
  String get noNoticesCreated => 'لا توجد إشعارات مضافة بعد.';

  @override
  String get selectClass => 'اختر الصف';

  @override
  String get selectSection => 'اختر الشعبة';

  @override
  String get selectCourse => 'اختر المادة';

  @override
  String get selectClassSectionCourse => 'اختر صفك وشعبتك ومادتك لعرض الطلاب.';

  @override
  String get coefficientLabel => 'المعامل';

  @override
  String get allClasses => 'كل الصفوف';

  @override
  String get allSections => 'كل الشعب';

  @override
  String get allCourses => 'كل المواد';

  @override
  String get allGradeTypes => 'كل الأنواع';

  @override
  String get noMatchingGrades => 'لا توجد درجات مطابقة لهذه التصفية.';

  @override
  String get loadGrades => 'تحميل';

  @override
  String get filters => 'تصفية';

  @override
  String get loadMore => 'تحميل المزيد';

  @override
  String get selectFiltersToLoadGrades =>
      'اختر الصف والشعبة والمادة ثم اضغط تحميل.';

  @override
  String get selectStudent => 'اختر الطالب';

  @override
  String get sendToEntireClass => 'الصف بالكامل';

  @override
  String get changeClass => 'تغيير الصف';

  @override
  String get noStudentsInClass => 'لا يوجد طلاب في هذا الصف.';

  @override
  String get targetTypeLabel => 'نوع الجهة المستهدفة';

  @override
  String get targetStudent => 'طالب';

  @override
  String get targetSection => 'شعبة';

  @override
  String get noticeContent => 'محتوى الإشعار';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get deleteItemQuestion => 'هل تريد حذف هذا العنصر؟';

  @override
  String get titleLabel => 'العنوان';

  @override
  String get departmentLabel => 'القسم';
}
