// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:jnvk/main.dart';
import 'package:jnvk/theme/theme_controller.dart';

void main() {
  testWidgets('Splash shows batch title', (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final themeController = ThemeController();
    // Skip themeController.load(): SharedPreferences is not initialized in this test binding.
    await tester.pumpWidget(JnvkApp(themeController: themeController));
    await tester.pump();
    expect(find.textContaining('JNV'), findsWidgets);
    // Clear splash Future.delayed(3s) timer.
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();
  });
}
