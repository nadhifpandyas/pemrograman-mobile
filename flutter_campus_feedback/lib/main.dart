// lib/main.dart
import 'package:flutter/material.dart';
import 'model/feedback_repository.dart';
import 'home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FeedbackRepository.init();

  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('is_dark_mode') ?? false;

  runApp(MyApp(initialIsDark: isDark));
}

class MyApp extends StatefulWidget {
  final bool initialIsDark;
  const MyApp({super.key, required this.initialIsDark});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  @override
  void initState() {
    super.initState();
    isDark = widget.initialIsDark;
  }

  void toggleTheme(bool value) async {
    setState(() => isDark = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_campus_feedback',
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: HomePage(
        isDark: isDark,
        onThemeChanged: toggleTheme,
      ),
    );
  }
}
