import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_tracker/providers/book_provider.dart';
import 'package:book_tracker/providers/theme_provider.dart';
import 'package:book_tracker/screens/dashboard_screen.dart';
import 'package:book_tracker/screens/book_list_screen.dart';
import 'package:book_tracker/screens/book_detail_screen.dart';
import 'package:book_tracker/screens/book_form_screen.dart';
import 'package:book_tracker/screens/settings_screen.dart';
import 'package:book_tracker/services/db_service.dart';
import 'package:book_tracker/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ======== SAFE DB INIT ========
  try {
    // jika ingin, kamu bisa tambahkan timeout safety:
    // await Future.any([DBService.instance.init(), Future.delayed(const Duration(seconds: 8))]);
    await DBService.instance.init();
  } catch (e, st) {
    // jangan crash app — catat untuk debug dan lanjutkan
    debugPrint('⚠️ DBService.init() error: $e');
    debugPrint('$st');
    // optional: kamu bisa melaporkan ke analytics / Sentry di sini
  }
  // ==============================

  runApp(const BookTrackerApp());
}

class BookTrackerApp extends StatelessWidget {
  const BookTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookProvider()..loadAll()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProv, _) {
          return MaterialApp(
            title: 'Book Tracker',
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeProv.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: DashboardScreen.routeName,
            routes: {
              DashboardScreen.routeName: (_) => const DashboardScreen(),
              BookListScreen.routeName: (_) => const BookListScreen(),
              BookDetailScreen.routeName: (_) => const BookDetailScreen(),
              BookFormScreen.routeName: (_) => const BookFormScreen(),
              SettingsScreen.routeName: (_) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}
