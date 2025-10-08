import 'package:flutter/material.dart';

void main() {
  runApp(const BiodataApp());
}

class BiodataApp extends StatelessWidget {
  const BiodataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biodata Sederhana',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Biodata Sederhana'),
          backgroundColor: const Color(0xFF4C9F83),
          centerTitle: true,
        ),
        body: Container(
          color: const Color(0xFFEAF2F8),
          width: double.infinity,
          child: Center(
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFDFFFF),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Nadhif Pandya Supriyadi',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Umur 19 Tahun',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}