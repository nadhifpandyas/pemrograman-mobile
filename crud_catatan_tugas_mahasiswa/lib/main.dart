// lib/main.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notes_repository.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi repository (SharedPreferences) untuk notes
  await NotesRepository.init();

  // Load preferensi tema
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('pref_dark_mode') ?? false;

  runApp(MyApp(initialDark: isDark));
}

class MyApp extends StatefulWidget {
  final bool initialDark;
  const MyApp({super.key, required this.initialDark});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDark;

  @override
  void initState() {
    super.initState();
    isDark = widget.initialDark;
  }

  // dipanggil oleh HomePage saat toggle
  void _setDark(bool value) {
    setState(() => isDark = value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Catatan Tugas',
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      // Pass callback ke HomePage supaya HomePage bisa mengubah theme global
      home: HomePage(initialDark: isDark, onThemeChanged: _setDark),
    );
  }
}
