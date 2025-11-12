// lib/home_page.dart
import 'package:flutter/material.dart';
import 'feedback_form_page.dart';
import 'feedback_detail_page.dart';
import 'about_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Map<String, String>> _items = [
    {'title': 'Perpustakaan', 'subtitle': 'Koleksi & jam layanan'},
    {'title': 'Koneksi WiFi', 'subtitle': 'Stabilitas jaringan di kampus'},
    {'title': 'Ruang Kelas', 'subtitle': 'Kebersihan & kenyamanan'},
  ];

  void _onNavSelected(int idx) async {
    if (idx == 1) {
      // buka form
      await Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedbackFormPage()));
      setState(() => _selectedIndex = 0);
      return;
    } else if (idx == 2) {
      await Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutPage()));
      setState(() => _selectedIndex = 0);
      return;
    }
    setState(() => _selectedIndex = idx);
  }

  Future<void> _openDetail(String title, String subtitle) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FeedbackDetailPage(title: title, description: subtitle)),
    );
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Returned: $result')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Navigation Demo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: _items.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, idx) {
            if (idx == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 6),
                  Text('Ketuk item untuk membuka detail (data dikirim ke halaman detail).'),
                ],
              );
            }
            final it = _items[idx - 1];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(it['title'] ?? ''),
                subtitle: Text(it['subtitle'] ?? ''),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _openDetail(it['title'] ?? '', it['subtitle'] ?? ''),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onNavSelected,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.edit), label: 'Form'),
          NavigationDestination(icon: Icon(Icons.info), label: 'About'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedbackFormPage()));
          setState(() {});
        },
        icon: const Icon(Icons.add),
        label: const Text('Isi Form'),
      ),
    );
  }
}
