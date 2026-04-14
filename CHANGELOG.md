# Changelog

All notable changes to this project are documented in this file.  
Version format follows the app `version` in `pubspec.yaml` (`<versionName>+<buildNumber>`).

---

## [2.0.0] — 2026-04-10

**Major release** — platform, reliability, and UX updates from the 1.x line.

### Added

- **`SocialUrlLauncher`** (`lib/utils/social_url_launcher.dart`): opens house profile links safely—prefers **WhatsApp / Instagram / Facebook** apps when available, otherwise **Safari / system browser**; fixes WhatsApp URLs where `phone=+…` was mis-parsed; defers opens to avoid iOS gesture / platform-channel issues.
- **iOS `LSApplicationQueriesSchemes`** for `fb`, `instagram`, `whatsapp`, etc., so the system can resolve those custom URL schemes.
- **Android** tooling aligned for current JDKs: **Gradle 8.7**, **Android Gradle Plugin 8.3.2**, **Kotlin 1.9.24**; library **`namespace`** fallback for AGP 8 where plugins omit it.
- This **`CHANGELOG.md`** for version-to-version notes.

### Changed

- **App version**: `1.0.0+1` → **`2.0.0+2`** (`versionName` **2.0.0**, `versionCode` / build **2** for store monotonicity).
- **Android `ndkVersion`**: pinned to **25.1.8937393** where required by plugins.
- **Java / Kotlin**: **Java 11** and **Kotlin JVM target 11** applied consistently across app and Android library modules (matches AGP 8 validation).
- **iOS CocoaPods**: **static frameworks** (`use_frameworks! :linkage => :static`) and related build settings so plugin modules (e.g. `audio_session` / `just_audio`) and **Firebase** resolve cleanly on current Xcode.
- **Flutter `Debug.xcconfig` / `Release.xcconfig`**: `OTHER_CFLAGS` workaround for Firebase Crashlytics explicit-module / non-modular header behavior with static frameworks.
- **Navodaya anthem player** (`lib/widgets/navodaya_anthem_player.dart`): **play / pause**, **stop**, and **loop** controls use the same **tap target and icon size** for a consistent control row.

### Fixed

- **Android**: `just_audio` **Java compile** failing on newer JDKs (**obsolete Java 8** warnings promoted to errors via **`-Werror`**).
- **Android**: **Java vs Kotlin JVM target** mismatches in plugin modules (e.g. `image_gallery_saver`, `package_info_plus`).
- **iOS**: **“Module 'audio_session' not found”** and related **`@import`** / framework issues when opening the project in Xcode with current CocoaPods layout.
- **iOS**: **Firebase Crashlytics** / static-framework **non-modular header** build failures when compiling plugin frameworks.
- **iOS**: **Profile / social links** not opening, app **unresponsive**, or **`EXC_BAD_ACCESS`** when tapping links (URL handling + timing + WhatsApp query encoding).
- **App startup**: **`WidgetsFlutterBinding.ensureInitialized()`** runs inside the same **`runZonedGuarded`** callback as async init and **`runApp`**, so zone errors and Firebase/Crashlytics reporting stay consistent.

---

## [1.0.0] — initial public baseline

- First tracked release line: **JNV Kaimur** house roster, gallery, Navodaya anthem player, Firebase Core + Crashlytics, light/dark theme, and bundled assets as shipped at **`1.0.0+1`**.

For earlier ad-hoc changes not listed here, see git history.
