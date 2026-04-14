import 'package:flutter/material.dart';

import 'theme_controller.dart';

/// Provides [ThemeController] to the widget tree (wrap [MaterialApp] with [builder]).
class AppThemeScope extends InheritedNotifier<ThemeController> {
  const AppThemeScope({
    super.key,
    required ThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  static ThemeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppThemeScope>();
    assert(scope != null, 'AppThemeScope not found');
    return scope!.notifier!;
  }
}
