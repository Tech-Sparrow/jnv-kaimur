import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists and notifies [ThemeMode] (light / dark / system).
class ThemeController extends ChangeNotifier {
  ThemeController();

  static const _prefKey = 'theme_mode';

  ThemeMode _mode = ThemeMode.system;

  ThemeMode get themeMode => _mode;

  Future<void> load() async {
    final sp = await SharedPreferences.getInstance();
    final v = sp.getString(_prefKey);
    switch (v) {
      case 'light':
        _mode = ThemeMode.light;
        break;
      case 'dark':
        _mode = ThemeMode.dark;
        break;
      default:
        _mode = ThemeMode.system;
    }
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
    final sp = await SharedPreferences.getInstance();
    final String stored = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await sp.setString(_prefKey, stored);
  }
}
