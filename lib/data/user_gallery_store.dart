import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists user-picked photos under app documents (copies from the picker).
class UserGalleryStore {
  UserGalleryStore._();
  static const _prefsKey = 'user_gallery_paths_v1';

  static Future<Directory> _galleryDir() async {
    final root = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(root.path, 'user_gallery'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static Future<List<String>> loadPaths() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_prefsKey) ?? [];
    final existing = <String>[];
    for (final path in list) {
      if (File(path).existsSync()) {
        existing.add(path);
      }
    }
    if (existing.length != list.length) {
      await _persistPaths(existing);
    }
    return existing;
  }

  static Future<void> _persistPaths(List<String> paths) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, paths);
  }

  static Future<List<String>> addFromPicker(List<XFile> files) async {
    if (files.isEmpty) return loadPaths();
    final dir = await _galleryDir();
    final current = await loadPaths();
    final next = [...current];
    for (final f in files) {
      final bytes = await f.readAsBytes();
      final name = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(f.path)}';
      final safe = name.replaceAll(RegExp(r'[^\w.\-]'), '_');
      final out = File(p.join(dir.path, safe));
      await out.writeAsBytes(bytes, flush: true);
      next.add(out.path);
    }
    await _persistPaths(next);
    return next;
  }

  static Future<void> removePath(String filePath) async {
    final f = File(filePath);
    if (await f.exists()) {
      await f.delete();
    }
    final current = await loadPaths();
    await _persistPaths(current.where((e) => e != filePath).toList());
  }
}
