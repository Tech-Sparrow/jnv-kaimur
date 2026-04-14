# JNVK (JNV Kaimur — 2k10 + LE)

Flutter app for the **Jawahar Navodaya Vidyalaya Kaimur** batch community: houses, gallery, Navodaya anthem, and alumni-style profile links.

| | |
| --- | --- |
| **Current version** | **2.0.0** (build **2**) — see [`pubspec.yaml`](pubspec.yaml) |
| **Dart package** | `jnvk` |
| **Android** | `applicationId` / `namespace`: `com.techsparrow.jnv_kaimur` |
| **iOS** | Bundle ID: `com.techsparrow.jnv_kaimur` |

Release notes and version history: **[`CHANGELOG.md`](CHANGELOG.md)**.

## Features

- **Houses** — Arawali, Shivalik, Nilgiri, Udaygiri: boys’ profiles (photos + social links), girls’ name lists  
- **Batch gallery** — photos with save / pick flows where permissions allow  
- **Navodaya anthem** — local playback (play / pause / stop / loop + seek)  
- **Light & dark theme** — persisted preference  
- **Firebase** — Core + Crashlytics for stability reporting  
- **Profile links** — opens Facebook / Instagram / WhatsApp in the app when installed, otherwise the system browser (see `lib/utils/social_url_launcher.dart`)

## Requirements

- **Flutter** stable compatible with **Dart 3** (`sdk: '>=3.0.0 <4.0.0'` in `pubspec.yaml`)  
- **Android**: **JDK 17+** recommended (project uses **Gradle 8.7** and **AGP 8.3**); Android SDK as required by `compileSdk` in `android/app/build.gradle`  
- **iOS**: **Xcode** with CocoaPods; open **`ios/Runner.xcworkspace`** (not the `.xcodeproj` alone)

## Getting started

```bash
flutter pub get
flutter run
```

### Android

```bash
flutter build apk   # or appbundle for Play
```

If Gradle or JDK errors appear, run `flutter doctor -v` and align your **JAVA_HOME** with a supported JDK for Gradle 8.

### iOS

```bash
cd ios && pod install && cd ..
flutter run
```

Use **Product → Clean Build Folder** in Xcode after dependency or Podfile changes.

## Project layout (high level)

| Path | Purpose |
| --- | --- |
| `lib/main.dart` | Entry, Firebase/Crashlytics bootstrap, theme, `MaterialApp` |
| `lib/screens/` | Home, house, splash, etc. |
| `lib/widgets/` | Anthem player, gallery, shared UI |
| `lib/data/` | Batch roster, house profiles, assets references |
| `assets/` | Images, audio, house photos |

## Documentation

- **[CHANGELOG.md](CHANGELOG.md)** — what changed in **2.0.0** vs earlier versions  
- [Flutter documentation](https://docs.flutter.dev/)

## License / publishing

`publish_to: 'none'` in `pubspec.yaml` — not intended for publication on pub.dev as a reusable package.
