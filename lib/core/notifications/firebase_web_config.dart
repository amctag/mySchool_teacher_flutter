import 'package:firebase_core/firebase_core.dart';

/// Public Firebase web config for the teacher site (project `koi-beirut`).
///
/// `FIREBASE_VAPID_KEY` must be the full Web Push certificate from
/// Firebase Console → Project settings → Cloud Messaging → Web Push
/// certificates. It starts with `B` and is usually 87 characters.
class TeacherFirebaseWeb {
  static const apiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: 'AIzaSyCT1WLuTArbf8dGVMrEfhWFrMsj2B3JqMg',
  );
  static const appId = String.fromEnvironment(
    'FIREBASE_WEB_APP_ID',
    defaultValue: '1:756524911884:web:f145cca98f3f37c8398d29',
  );
  static const _vapidRaw = String.fromEnvironment(
    'FIREBASE_VAPID_KEY',
    defaultValue:
        'BGo3RdBGObVk1_me8rcci6ww6fDJOIvNy7Wd0fk_yJmdOXC4bErjDlhLesopMHtRsNKWsfOiTFLVTrMOR8xgwqQ',
  );

  /// Exact public key from Firebase. Empty or invalid values must not be
  /// passed to Chrome — that causes InvalidCharacterError in atob().
  static String get vapidKey {
    final key = _vapidRaw.trim();
    if (!_isValidVapidKey(key)) {
      return '';
    }
    return key;
  }

  static bool _isValidVapidKey(String key) {
    if (key.isEmpty || !key.startsWith('B')) {
      return false;
    }
    // Unpadded base64url for an uncompressed P-256 key is 87 chars.
    if (key.length != 87 && key.length != 88) {
      return false;
    }
    return RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(key);
  }

  static const projectId = 'koi-beirut';
  static const messagingSenderId = '756524911884';
  static const authDomain = 'koi-beirut.firebaseapp.com';
  static const storageBucket = 'koi-beirut.firebasestorage.app';
  static const databaseURL = 'https://koi-beirut.firebaseio.com';

  static bool get isConfigured => appId.isNotEmpty && vapidKey.isNotEmpty;

  static String get vapidConfigError {
    final key = _vapidRaw.trim();
    if (key.isEmpty) {
      return 'FIREBASE_VAPID_KEY is missing. In EasyPanel teacher Build args, '
          'paste the full Web Push key from Firebase (it must start with B).';
    }
    if (!key.startsWith('B')) {
      return 'FIREBASE_VAPID_KEY is wrong. Copy the full Key pair from Firebase '
          'Cloud Messaging → Web Push certificates. It must start with the '
          'letter B.';
    }
    if (key.length != 87 && key.length != 88) {
      return 'FIREBASE_VAPID_KEY length is ${key.length}. Paste the complete '
          'key from Firebase (usually 87 characters).';
    }
    return 'FIREBASE_VAPID_KEY is invalid.';
  }

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
