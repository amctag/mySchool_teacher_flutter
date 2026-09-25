// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'MS Teacher';

  @override
  String get schoolName => 'École préparatoire Makarem';

  @override
  String get welcomeBack => 'Bon retour';

  @override
  String get loginSubtitle =>
      'Toute votre journée d’enseignement, au même endroit.';

  @override
  String get username => 'Nom d’utilisateur';

  @override
  String get password => 'Mot de passe';

  @override
  String get signIn => 'Se connecter';

  @override
  String get support => 'Assistance';

  @override
  String get supportSubtitle =>
      'Contactez votre école pour obtenir de l’aide concernant votre compte.';

  @override
  String get supportId => 'ID';

  @override
  String get supportIdRequired =>
      'Saisissez votre ID pour contacter l’assistance.';

  @override
  String get supportNoSchools =>
      'Aucun contact d’école n’a été trouvé pour cet ID.';

  @override
  String get supportLoadFailed =>
      'Impossible de charger les informations d’assistance.';

  @override
  String get supportLookup => 'Trouver le contact de l’école';

  @override
  String get credentialsRequired => 'Saisissez votre ID et votre mot de passe.';

  @override
  String get accountInactiveTitle => 'Connexion impossible';

  @override
  String get accountInactiveBody =>
      'Ce compte est inactif. Vous ne pouvez pas vous connecter. Contactez l’assistance.';

  @override
  String get accountUnpaidTitle => 'Connexion impossible';

  @override
  String get accountUnpaidBody =>
      'Un paiement est requis pour ce compte. Vous ne pouvez pas vous connecter. Contactez l’assistance.';

  @override
  String get contactSupport => 'Contacter l’assistance';

  @override
  String get home => 'Accueil';

  @override
  String get goodMorning => 'Bonjour';

  @override
  String get goodAfternoon => 'Bon après-midi';

  @override
  String get goodEvening => 'Bonsoir';

  @override
  String get yourSchoolDay => 'Votre journée scolaire';

  @override
  String get switchChild => 'Changer d’enfant';

  @override
  String get selectedChild => 'Enfant sélectionné';

  @override
  String get children => 'Enfants';

  @override
  String get allChildren => 'Tous les enfants';

  @override
  String childrenCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count enfants',
      one: '1 enfant',
    );
    return '$_temp0';
  }

  @override
  String get childDetails => 'Détails de l’enfant';

  @override
  String get classLabel => 'Classe';

  @override
  String get sectionLabel => 'Section';

  @override
  String get academicYear => 'Année scolaire';

  @override
  String get stage => 'Cycle';

  @override
  String get dateOfBirth => 'Date de naissance';

  @override
  String get motherName => 'Mère';

  @override
  String get weeklySchedule => 'Emploi du temps';

  @override
  String get courses => 'Matières';

  @override
  String get noCourses => 'Aucune matière pour cette classe.';

  @override
  String get agenda => 'Agenda';

  @override
  String get agendaDetails => 'Détails de l’agenda';

  @override
  String get grades => 'Notes';

  @override
  String get noGrades => 'Aucune note publiée pour le moment.';

  @override
  String get notices => 'Remarque';

  @override
  String get noNotices => 'Aucune remarque pour cet enfant.';

  @override
  String get examSchedule => 'Planning des examens';

  @override
  String get noExamSchedule => 'Aucun planning d’examen publié.';

  @override
  String get directNotice => 'Remarque directe';

  @override
  String get sectionNotice => 'Remarque de section';

  @override
  String get publishedOn => 'Publié le';

  @override
  String durationMinutes(int count) {
    return '$count min';
  }

  @override
  String get announcements => 'Avis';

  @override
  String get announcementDetails => 'Détails de l’avis';

  @override
  String get attendance => 'Présence';

  @override
  String get takeAttendance => 'Faire l’appel';

  @override
  String get noAttendanceRecords =>
      'Aucune présence enregistrée pour cette date.';

  @override
  String get attendanceViewOnly =>
      'Vous pouvez consulter la présence de la classe. Les enseignants ne peuvent pas la saisir dans cette école.';

  @override
  String get noEligibleAttendance =>
      'Vous ne pouvez pas faire l’appel pour aucune classe aujourd’hui.';

  @override
  String get attendanceDate => 'Date de présence';

  @override
  String get attendanceReasonRequired =>
      'Choisissez un motif pour chaque élève absent.';

  @override
  String get markAllPresent => 'Tous présents';

  @override
  String absentStudentsCount(int count) {
    return '$count absent(s)';
  }

  @override
  String get activities => 'Activités';

  @override
  String get activityDetails => 'Détails de l’activité';

  @override
  String get albums => 'Albums';

  @override
  String get albumDetails => 'Détails de l’album';

  @override
  String get aboutSchool => 'À propos de l’école';

  @override
  String get contactSchool => 'Contacter l’école';

  @override
  String get contactSchoolSubtitle =>
      'Joignez l’école rapidement avec l’option qui vous convient.';

  @override
  String get callSchool => 'Appeler';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get directions => 'Itinéraire';

  @override
  String get visitWebsite => 'Site web';

  @override
  String get openContactFailed =>
      'Impossible d’ouvrir cette application. Réessayez.';

  @override
  String get settings => 'Paramètres';

  @override
  String get profile => 'Profil';

  @override
  String get profileDetails => 'Détails du profil';

  @override
  String get role => 'Rôle';

  @override
  String get parentRole => 'Parent';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get currentPassword => 'Mot de passe actuel';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get confirmNewPassword => 'Confirmer le mot de passe';

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String get fieldRequired => 'Ce champ est obligatoire.';

  @override
  String get passwordTooShort => 'Utilisez au moins 8 caractères.';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas.';

  @override
  String get currentPasswordIncorrect =>
      'Le mot de passe actuel est incorrect.';

  @override
  String get passwordUpdated => 'Mot de passe mis à jour.';

  @override
  String get passwordUpdateFailed =>
      'Le mot de passe n’a pas pu être mis à jour.';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get period => 'Séance';

  @override
  String periodNumber(int number) {
    return 'Séance $number';
  }

  @override
  String get note => 'Note';

  @override
  String get previousMonth => 'Mois précédent';

  @override
  String get nextMonth => 'Mois suivant';

  @override
  String get attachment => 'Pièce jointe';

  @override
  String get attachPdf => 'Joindre un PDF';

  @override
  String get choosePdf => 'Choisir un fichier PDF';

  @override
  String get pdfOnly => 'Veuillez choisir un fichier PDF.';

  @override
  String get pdf => 'PDF';

  @override
  String get attachImage => 'Joindre une image';

  @override
  String get chooseImage => 'Choisir une image';

  @override
  String get imageOnly => 'Veuillez choisir une image.';

  @override
  String get uploading => 'Téléversement…';

  @override
  String get uploadFailed => 'Impossible de téléverser ce fichier. Réessayez.';

  @override
  String get publish => 'Publier';

  @override
  String get published => 'Publié';

  @override
  String get draft => 'Brouillon';

  @override
  String get you => 'Vous';

  @override
  String get image => 'Image';

  @override
  String get file => 'Fichier';

  @override
  String publishedBy(String name) {
    return 'Publié par $name';
  }

  @override
  String get noAgenda => 'Aucun agenda pour cette date.';

  @override
  String get agendaAvailable => 'Agenda disponible';

  @override
  String get noAnnouncements => 'Il n’y a pas encore d’avis.';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'Aucune notification pour le moment.';

  @override
  String get tasks => 'Tâches';

  @override
  String get noTasks => 'Aucune tâche pour le moment.';

  @override
  String get openTasks => 'Ouvertes';

  @override
  String get completedTasks => 'Terminées';

  @override
  String get markTaskDone => 'Marquer terminé';

  @override
  String get noOpenTasks => 'Aucune tâche en cours.';

  @override
  String openTasksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tâches ouvertes',
      one: '1 tâche ouverte',
    );
    return '$_temp0';
  }

  @override
  String get noActivities => 'Il n’y a pas encore d’activités.';

  @override
  String get noAlbums => 'Il n’y a pas encore d’albums.';

  @override
  String get noPublishedPhotos =>
      'Aucune photo n’a été publiée dans cet album.';

  @override
  String photos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos',
      one: '1 photo',
      zero: 'Aucune photo',
    );
    return '$_temp0';
  }

  @override
  String get present => 'Présent';

  @override
  String get absent => 'Absent';

  @override
  String get late => 'En retard';

  @override
  String get excused => 'Excusé';

  @override
  String get attendanceRate => 'Taux de présence';

  @override
  String get noAttendanceExceptions => 'Aucune absence ou retard ce mois-ci.';

  @override
  String daysRecorded(int count) {
    return '$count jours enregistrés';
  }

  @override
  String get reason => 'Motif';

  @override
  String get schoolInformation => 'Informations de l’école';

  @override
  String get telephone => 'Téléphone';

  @override
  String get mobile => 'Mobile';

  @override
  String get fax => 'Fax';

  @override
  String get address => 'Adresse';

  @override
  String get email => 'E-mail';

  @override
  String get website => 'Site web';

  @override
  String get language => 'Langue';

  @override
  String get english => 'Anglais';

  @override
  String get french => 'Français';

  @override
  String get arabic => 'Arabe';

  @override
  String get theme => 'Thème';

  @override
  String get systemTheme => 'Système';

  @override
  String get lightTheme => 'Clair';

  @override
  String get darkTheme => 'Sombre';

  @override
  String get account => 'Compte';

  @override
  String get appearance => 'Apparence';

  @override
  String get application => 'Application';

  @override
  String get version => 'Version 1.0.0';

  @override
  String get loading => 'Chargement…';

  @override
  String get somethingWentWrong => 'Une erreur s’est produite.';

  @override
  String get retry => 'Réessayer';

  @override
  String get close => 'Fermer';

  @override
  String get back => 'Retour';

  @override
  String get viewDetails => 'Voir les détails';

  @override
  String get today => 'Aujourd’hui';

  @override
  String get teacherHomeSubtitle =>
      'Vos outils d’enseignement pour aujourd’hui';

  @override
  String get mySchedule => 'Mon emploi du temps';

  @override
  String get noSchedule => 'Aucun emploi du temps n’a encore été attribué.';

  @override
  String get myClasses => 'Mes classes';

  @override
  String get allClassSchedules => 'Tous les emplois du temps';

  @override
  String get noAssignedClasses => 'Aucune classe attribuée pour le moment.';

  @override
  String get noClassesAvailable => 'Aucune classe disponible.';

  @override
  String get noClassDetails => 'Aucun détail de classe disponible.';

  @override
  String get students => 'Élèves';

  @override
  String get teachers => 'Enseignants';

  @override
  String get yourAssignment => 'Votre classe';

  @override
  String get seatNumberLabel => 'Place';

  @override
  String get room => 'Salle';

  @override
  String get assignment => 'Attribution';

  @override
  String get addAgenda => 'Ajouter un agenda';

  @override
  String get addActivity => 'Ajouter une activité';

  @override
  String get activityDate => 'Date de l’activité';

  @override
  String get activityContent => 'Détails de l’activité';

  @override
  String get editAgenda => 'Modifier l’agenda';

  @override
  String get agendaDescription => 'Détails de l’agenda';

  @override
  String get agendaDate => 'Date de l’agenda';

  @override
  String get noAgendaItems => 'Aucun agenda créé pour le moment.';

  @override
  String get showAll => 'Tous';

  @override
  String get attachments => 'Pièces jointes';

  @override
  String get optional => 'Facultatif';

  @override
  String get parentsSeePublished =>
      'Les parents ne voient que les agendas publiés.';

  @override
  String get schoolPublishesAgenda =>
      'L’école publie les agendas. Vous pouvez seulement enregistrer des brouillons.';

  @override
  String get addGrades => 'Ajouter des notes';

  @override
  String get editGrades => 'Modifier les notes';

  @override
  String get allStudentsAlreadyGraded =>
      'Tous les élèves ont déjà une note pour cette évaluation.';

  @override
  String get assessmentAlreadyExists => 'Déjà noté';

  @override
  String get selectClassSectionCourseFirst =>
      'Sélectionnez d’abord la classe, la section et la matière.';

  @override
  String get noGradeAssessments => 'Aucune évaluation créée pour le moment.';

  @override
  String get entriesLabel => 'saisies';

  @override
  String get assessmentTitle => 'Titre de l’évaluation';

  @override
  String get assessmentType => 'Type d’évaluation';

  @override
  String get maxGradeLabel => 'Note maximale';

  @override
  String get scoreLabel => 'Note';

  @override
  String get atLeastOneGradeRequired =>
      'Saisissez une note pour au moins un élève.';

  @override
  String get publishDateLabel => 'Date de publication';

  @override
  String get addNotice => 'Ajouter une remarque';

  @override
  String get addAnnouncement => 'Ajouter une annonce';

  @override
  String get announcementAudience => 'Public';

  @override
  String get audienceParent => 'Parents';

  @override
  String get audienceTeacher => 'Enseignants';

  @override
  String get editNotice => 'Modifier la remarque';

  @override
  String get noNoticesCreated => 'Aucune remarque créée pour le moment.';

  @override
  String get selectClass => 'Choisir la classe';

  @override
  String get selectSection => 'Choisir la section';

  @override
  String get selectCourse => 'Choisir la matière';

  @override
  String get selectClassSectionCourse =>
      'Choisissez votre classe, section et matière pour afficher les élèves.';

  @override
  String get coefficientLabel => 'Coefficient';

  @override
  String get allClasses => 'Toutes les classes';

  @override
  String get allSections => 'Toutes les sections';

  @override
  String get allCourses => 'Toutes les matières';

  @override
  String get allGradeTypes => 'Tous les types';

  @override
  String get noMatchingGrades =>
      'Aucune feuille de notes ne correspond à ces filtres.';

  @override
  String get loadGrades => 'Charger';

  @override
  String get filters => 'Filtres';

  @override
  String get loadMore => 'Charger plus';

  @override
  String get selectFiltersToLoadGrades =>
      'Choisissez la classe, la section et la matière, puis appuyez sur Charger.';

  @override
  String get selectStudent => 'Choisir l’élève';

  @override
  String get sendToEntireClass => 'Toute la classe';

  @override
  String get changeClass => 'Changer de classe';

  @override
  String get noStudentsInClass => 'Aucun élève dans cette classe.';

  @override
  String get targetTypeLabel => 'Type de destinataire';

  @override
  String get targetStudent => 'Élève';

  @override
  String get targetSection => 'Section';

  @override
  String get noticeContent => 'Contenu de la remarque';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteItemQuestion => 'Supprimer cet élément ?';

  @override
  String get titleLabel => 'Titre';

  @override
  String get departmentLabel => 'Département';
}
