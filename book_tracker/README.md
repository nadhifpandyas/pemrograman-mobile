# Book Tracker

A Flutter Book Tracker app that fulfills UAS requirements: Provider for state management, REST API usage (Google Books), local storage (SQLite), CRUD, navigation, UI/UX, error handling, and bonus features: animations, dark mode, SQLite+API sync, and dashboard statistics.

## How to run
1. Ensure Flutter SDK installed.
2. Create a new Flutter project and replace files with the ones in this repo.
3. Run `flutter pub get`.
4. Run on emulator or device: `flutter run`.
5. Build release APK: `flutter build apk --release`.

## What is included
- Provider-based state management in `lib/providers/book_provider.dart`.
- API integration `lib/services/api_service.dart` (Google Books API).
- SQLite storage `lib/services/db_service.dart` (sqflite + path_provider).
- 5 main screens: Dashboard, Library (list), Detail, Form, Settings.
- Bonus features: animations (custom page transitions), dark mode (SharedPreferences), SQLite+API sync, dashboard with pie chart (fl_chart).

---

End of project files. Good luck — jika mau, saya bisa juga:
- generate laporan (PDF draft) sesuai format UAS
- buat skrip presentasi / naskah video 3–10 menit
- bantu build APK (instruksi)