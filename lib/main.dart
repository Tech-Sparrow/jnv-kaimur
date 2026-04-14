import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'firebase_bootstrap.dart';
import 'splash_screen.dart';
import 'theme/app_theme.dart';
import 'theme/app_theme_scope.dart';
import 'theme/theme_controller.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await initializeFirebaseAndCrashlytics();

    final themeController = ThemeController();
    await themeController.load();

    runApp(JnvkApp(themeController: themeController));
  }, (error, stack) {
    if (Firebase.apps.isNotEmpty) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    } else {
      debugPrint('Uncaught zone error: $error\n$stack');
    }
  });
}

class JnvkApp extends StatelessWidget {
  const JnvkApp({super.key, required this.themeController});

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'JNVK 2k10 + LE',
          themeMode: themeController.themeMode,
          theme: buildAppTheme(),
          darkTheme: buildAppDarkTheme(),
          builder: (context, child) {
            return AppThemeScope(
              controller: themeController,
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: const SplashScreen(),
        );
      },
    );
  }
}
