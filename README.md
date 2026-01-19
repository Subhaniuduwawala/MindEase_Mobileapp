# MindEase

MindEase is a lightweight mental wellness mobile application built with Flutter. It provides daily affirmations, a small relaxation music library, journaling, and mood tracking. This repository contains a minimal, working Flutter UI wired to simple in-memory services (located in `lib/models` and `lib/services`).

**Quick Start**

- Prerequisites:
	- Install Flutter SDK: https://flutter.dev/docs/get-started/install
	- Ensure `flutter` is available on your PATH and run `flutter doctor`.

- From a PowerShell terminal in the project root (`c:\Users\Asus\Documents\Project\mobile app\dart\dart_application_1`) run:

```powershell
flutter create .
flutter pub get
flutter run
```

Notes:
- `flutter create .` will generate platform folders (`android/`, `ios/`, etc.) required to run on devices or emulators.
- The project currently uses the `audioplayers` package for audio playback — add audio files to `assets/audio/` (create the folder) and list them in `pubspec.yaml` if you want packaged assets.

**Project Layout**
- `lib/main.dart`: Flutter UI (tabs for Affirmations, Music, Journal, Mood).
- `lib/models/`: Data models (affirmation, journal entry, mood entry, music track, user settings).
- `lib/services/`: Simple in-memory services that provide data and perform basic actions.
- `bin/`: legacy CLI runner (kept for compatibility) — Flutter entrypoint is now `lib/main.dart`.

**How to add audio assets**

1. Create the folder `assets/audio/` in the project root.
2. Copy your `.mp3` or `.wav` audio files into that folder (e.g., `assets/audio/calm_waves.mp3`).
3. Ensure `pubspec.yaml` lists the `assets/audio/` directory (this project already declares it).
4. Use the `Music` tab to play tracks; the UI currently shows placeholder playback and triggers a SnackBar — replace `MusicService.playTrack` to use `audioplayers` API for actual audio playback (see next section).

**Persistence & Notifications (next steps)**
- Persistence: switch `JournalService` and `MoodService` to use `shared_preferences` or a local database (`sqflite`/`moor`) to persist data across app restarts.
- Notifications: to add reminders, integrate `flutter_local_notifications` and request platform-specific permission. Schedule gentle check-ins or journaling prompts.

**Development checklist**
- [ ] Add audio assets to `assets/audio/`.
- [ ] Implement audio playback using `audioplayers` in `services/music_service.dart`.
- [ ] Persist journal and mood data (use `shared_preferences` or `sqflite`).
- [ ] Add unit/widget tests under `test/`.
- [ ] Add CI (GitHub Actions) to run `flutter analyze` and `flutter test`.

**Building releases**
- Android: `flutter build apk` or `flutter build appbundle`.
- iOS: `flutter build ios` (requires macOS).
- Web: `flutter build web`.

If you'd like, I can:
- Implement persistent storage for journal/mood using `shared_preferences`.
- Wire up audio playback to `audioplayers` and include example audio files.
- Add local notifications for reminders.

Enjoy developing MindEase — tell me which feature you'd like implemented next and I'll add it.
A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.
