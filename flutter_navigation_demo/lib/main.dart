// lib/main.dart
import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const FlutterNavigationDemoApp());
}

class FlutterNavigationDemoApp extends StatelessWidget {
  const FlutterNavigationDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_navigation_demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const HomePage(),
    );
  }
}
