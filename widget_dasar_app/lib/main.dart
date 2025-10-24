import 'package:flutter/material.dart';

void main() {
  runApp(const WidgetDasarApp());
}

class WidgetDasarApp extends StatelessWidget {
  const WidgetDasarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'widget_dasar_app',
      debugShowCheckedModeBanner: false,
      home: const BiodataPage(),
    );
  }
}

class BiodataPage extends StatelessWidget {
  const BiodataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F9),
      appBar: AppBar(
        title: const Text('Biodata Diri'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2E7A7A),
      ),
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.asset(
                  'assets/profile.PNG',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),

              const Text(
                'Nadhif',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172B4D),
                ),
              ),
              const SizedBox(height: 6),

              const Text(
                'Mahasiswa Sistem Informasi\n',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color(0xFF425466)),
              ),
              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Column(
                    children: [
                      Text('Jambi', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('UIN STS ', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Pilot', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Pilot', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Halo teman')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7A7A),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Sapa Saya'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
