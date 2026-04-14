// Replace with output of: dart pub global run flutterfire_cli:flutterfire configure
// For Android Crashlytics, also download google-services.json into android/app/ and re-enable the
// com.google.gms.google-services plugin in android/app/build.gradle; you may remove FirebaseInitProvider's tools:node="remove" from AndroidManifest.xml once using real config.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  /// True when [firebase_options.dart] has been replaced with real keys (e.g. via `flutterfire configure`).
  static bool get isConfigured {
    if (kIsWeb) return false;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _looksLikeRealKey(android.apiKey);
      case TargetPlatform.iOS:
        return _looksLikeRealKey(ios.apiKey);
      default:
        return false;
    }
  }

  static bool _looksLikeRealKey(String key) {
    return key.isNotEmpty && !key.contains('REPLACE');
  }

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Configure Firebase for web via FlutterFire CLI if needed.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError('Firebase is only wired for Android and iOS.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_WITH_FIREBASE_ANDROID_API_KEY',
    appId: 'REPLACE_WITH_FIREBASE_ANDROID_APP_ID',
    messagingSenderId: 'REPLACE_WITH_SENDER_ID',
    projectId: 'REPLACE_WITH_PROJECT_ID',
    storageBucket: 'REPLACE_WITH_PROJECT_ID.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_WITH_FIREBASE_IOS_API_KEY',
    appId: 'REPLACE_WITH_FIREBASE_IOS_APP_ID',
    messagingSenderId: 'REPLACE_WITH_SENDER_ID',
    projectId: 'REPLACE_WITH_PROJECT_ID',
    storageBucket: 'REPLACE_WITH_PROJECT_ID.appspot.com',
    iosBundleId: 'com.techsparrow.jnv_kaimur',
  );
}
