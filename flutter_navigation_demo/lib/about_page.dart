// lib/about_page.dart
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(width: 120, height: 120, child: Image.asset('assets/uin_logo.png', fit: BoxFit.contain, errorBuilder: (c,s,t) => const FlutterLogo(size: 80))),
                const SizedBox(height: 12),
                const Text('UIN STS JAMBI', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Dosen Pengampu: Ahmad Nasukha, S.Hum, M.Si'),
                const SizedBox(height: 8),
                const Text('Pengembang: Nadhif Pandya Supriyadi'),
                const SizedBox(height: 8),
                const Text('Tahun Akademik: 2025'),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Kembali ke Beranda')),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
