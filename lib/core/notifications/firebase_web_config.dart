import 'package:firebase_core/firebase_core.dart';

/// Public Firebase web config for the teacher site (project `koi-beirut`).
///
/// The web app id is already set. `FIREBASE_VAPID_KEY` is the Web Push
/// certificate from Firebase Console → Cloud Messaging. The phone app does
/// not use these values.
class TeacherFirebaseWeb {
  static const apiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: 'AIzaSyCT1WLuTArbf8dGVMrEfhWFrMsj2B3JqMg',
  );
  static const appId = String.fromEnvironment(
    'FIREBASE_WEB_APP_ID',
    defaultValue: '1:756524911884:web:f145cca98f3f37c8398d29',
  );
  static const vapidKey = String.fromEnvironment('FIREBASE_VAPID_KEY');

  static const projectId = 'koi-beirut';
  static const messagingSenderId = '756524911884';
  static const authDomain = 'koi-beirut.firebaseapp.com';
  static const storageBucket = 'koi-beirut.firebasestorage.app';
  static const databaseURL = 'https://koi-beirut.firebaseio.com';

  static bool get isConfigured => appId.isNotEmpty;

  static FirebaseOptions get options => FirebaseOptions(
    apiKey: apiKey,
    appId: appId,
    messagingSenderId: messagingSenderId,
    projectId: projectId,
    authDomain: authDomain,
    storageBucket: storageBucket,
    databaseURL: databaseURL,
  );
}
