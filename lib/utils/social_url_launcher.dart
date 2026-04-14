import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens profile / social URLs on iOS/Android: native app when available,
/// otherwise system browser. Handles WhatsApp `phone=+...` URLs without
/// corrupting `+` (Dart [Uri.queryParameters] treats `+` as space).
class SocialUrlLauncher {
  SocialUrlLauncher._();

  static final RegExp _whatsappPhoneFromQuery = RegExp(
    r'[\?&]phone=([^&]+)',
    caseSensitive: false,
  );
  static final RegExp _waMePath = RegExp(
    r'wa\.me/(\d+)',
    caseSensitive: false,
  );
  static final RegExp _instagramUser = RegExp(
    r'instagram\.com/([^/?#]+)',
    caseSensitive: false,
  );

  /// Returns `true` if a URL was opened successfully.
  static Future<bool> open(String? rawUrl) async {
    if (rawUrl == null) return false;
    final trimmed = rawUrl.trim();
    if (trimmed.isEmpty) return false;

    // Avoid iOS gesture / platform-channel races (freezes, bad access).
    final completer = Completer<bool>();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (completer.isCompleted) return;
      try {
        completer.complete(await _openInner(trimmed));
      } catch (e, st) {
        debugPrint('SocialUrlLauncher: $e\n$st');
        completer.complete(false);
      }
    });
    return completer.future;
  }

  static Future<bool> _openInner(String raw) async {
    if (raw.toLowerCase().startsWith('whatsapp://')) {
      final direct = Uri.tryParse(raw);
      if (direct != null && await _tryLaunch(direct)) return true;
    }

    final normalizedWeb = _ensureHttpsWebUrl(raw);

    // WhatsApp: prefer app deep link with digits-only phone.
    final whatsappDigits = _extractWhatsappPhoneDigits(raw);
    if (whatsappDigits != null && whatsappDigits.isNotEmpty) {
      final text = _extractWhatsappText(raw) ?? '';
      final app = Uri(
        scheme: 'whatsapp',
        host: 'send',
        queryParameters: <String, String>{
          'phone': whatsappDigits,
          if (text.isNotEmpty) 'text': text,
        },
      );
      if (await _tryLaunch(app)) return true;
      final httpsChat = Uri.https(
        'api.whatsapp.com',
        '/send',
        <String, String>{
          'phone': whatsappDigits,
          if (text.isNotEmpty) 'text': text,
        },
      );
      if (await _tryLaunch(httpsChat)) return true;
      // Do not fall through to [Uri.parse] on raw WhatsApp links — `+` in query breaks on iOS.
      return false;
    }

    // Instagram: try app, then web.
    final instaUser = _instagramUsername(normalizedWeb);
    if (instaUser != null && instaUser.isNotEmpty) {
      final app = Uri(
        scheme: 'instagram',
        host: 'user',
        queryParameters: <String, String>{'username': instaUser},
      );
      if (await _tryLaunch(app)) return true;
    }

    // Facebook: try in-app web modal bridge, then web.
    if (_isFacebookHost(normalizedWeb)) {
      final webUri = Uri.parse(normalizedWeb);
      final href = webUri.toString();
      final app = Uri.parse(
        'fb://facewebmodal/f?href=${Uri.encodeComponent(href)}',
      );
      if (await _tryLaunch(app)) return true;
    }

    // Default: https (or original) in external handler → Safari or universal link.
    final fallback = Uri.tryParse(normalizedWeb) ?? Uri.tryParse(raw);
    if (fallback == null || !fallback.hasScheme) return false;
    return _tryLaunch(
      fallback,
      mode: LaunchMode.externalApplication,
    );
  }

  static String _ensureHttpsWebUrl(String raw) {
    var s = raw.trim();
    if (s.startsWith('http://api.whatsapp.com') ||
        s.startsWith('http://wa.me') ||
        s.startsWith('http://www.facebook.com') ||
        s.startsWith('http://facebook.com') ||
        s.startsWith('http://m.facebook.com') ||
        s.startsWith('http://www.instagram.com') ||
        s.startsWith('http://instagram.com')) {
      s = 'https${s.substring(4)}';
    }
    return s;
  }

  /// Extract E.164 digits only (no +) from api.whatsapp.com or wa.me URLs.
  static String? _extractWhatsappPhoneDigits(String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('whatsapp.com') || lower.contains('wa.me')) {
      final q = _whatsappPhoneFromQuery.firstMatch(raw);
      if (q != null) {
        var p = q.group(1)!;
        p = p.replaceAll('+', '%2B');
        try {
          p = Uri.decodeComponent(p);
        } catch (_) {}
        final digits = p.replaceAll(RegExp(r'\D'), '');
        if (digits.isNotEmpty) return digits;
      }
      final m = _waMePath.firstMatch(raw);
      if (m != null) return m.group(1);
    }
    return null;
  }

  static String? _extractWhatsappText(String raw) {
    final m = RegExp(r'[\?&]text=([^&]*)').firstMatch(raw);
    if (m == null) return null;
    try {
      return Uri.decodeComponent(m.group(1)!);
    } catch (_) {
      return m.group(1);
    }
  }

  static String? _instagramUsername(String url) {
    final m = _instagramUser.firstMatch(url);
    if (m == null) return null;
    final segment = m.group(1)!;
    final lower = segment.toLowerCase();
    if (lower == 'p' || lower == 'reel' || lower == 'stories') return null;
    return segment;
  }

  static bool _isFacebookHost(String url) {
    final u = url.toLowerCase();
    return u.contains('facebook.com') || u.contains('fb.com');
  }

  static Future<bool> _tryLaunch(
    Uri uri, {
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    try {
      final isWeb = uri.scheme == 'https' || uri.scheme == 'http';
      // iOS: [canLaunchUrl] can be wrong for https; opening Safari does not need the check.
      if (!isWeb && !await canLaunchUrl(uri)) return false;
      return await launchUrl(uri, mode: mode);
    } catch (e, st) {
      debugPrint('SocialUrlLauncher _tryLaunch $uri: $e\n$st');
      return false;
    }
  }
}
