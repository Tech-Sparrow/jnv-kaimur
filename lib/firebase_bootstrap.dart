import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import 'firebase_options.dart';

/// Initializes Firebase + Crashlytics when [DefaultFirebaseOptions.isConfigured] is true.
/// With placeholder keys, skips init so the app runs without Firebase (add real config + google-services.json for Android).
Future<bool> initializeFirebaseAndCrashlytics() async {
  if (!DefaultFirebaseOptions.isConfigured) {
    debugPrint('Firebase/Crashlytics skipped: add real keys via FlutterFire CLI (flutterfire configure).');
    return false;
  }
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    return true;
  } catch (e, st) {
    debugPrint('Firebase/Crashlytics init skipped: $e\n$st');
    return false;
  }
}
