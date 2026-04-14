import 'package:flutter/material.dart';

/// Colors aligned with [jnvk_web/assets/css/style.css] (Avilon / site gradient).
abstract final class AppColors {
  static const Color teal = Color(0xFF1DC8CD);
  static const Color green = Color(0xFF1DE099);
  static const Color textMuted = Color(0xFF666666);
  static const Color sectionBg = Color(0xFFF7FBFB);
}

/// Alternating section background that works in light and dark mode.
Color sectionBackground(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF1A2224)
      : AppColors.sectionBg;
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.teal,
      primary: AppColors.teal,
      surface: Colors.white,
    ),
  );

  return base.copyWith(
    scaffoldBackgroundColor: Colors.white,
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.textMuted,
      displayColor: const Color(0xFF333333),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w400,
        letterSpacing: 2,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
    ),
    dividerTheme: const DividerThemeData(color: AppColors.teal, thickness: 2, space: 1),
  );
}

ThemeData buildAppDarkTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.teal,
      brightness: Brightness.dark,
      primary: AppColors.teal,
      surface: const Color(0xFF121212),
    ),
  );

  return base.copyWith(
    scaffoldBackgroundColor: const Color(0xFF121212),
    textTheme: base.textTheme.apply(
      bodyColor: Colors.white70,
      displayColor: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w400,
        letterSpacing: 2,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF1E2426),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.teal, thickness: 2, space: 1),
  );
}

/// Header gradient used for app bar and hero overlay (matches site header / buttons).
LinearGradient get appBarGradient => const LinearGradient(
      colors: [AppColors.green, AppColors.teal],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

/// Section titles (web template used Montserrat; system UI font + letter spacing approximates it).
TextStyle appHeadingStyle(BuildContext context, {double? fontSize, FontWeight? weight}) {
  return TextStyle(
    fontSize: fontSize ?? 28,
    fontWeight: weight ?? FontWeight.w400,
    letterSpacing: weight == FontWeight.w600 ? 0.5 : 0,
    color: Theme.of(context).colorScheme.onSurface,
  );
}
