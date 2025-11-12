// lib/home_page.dart
import 'package:flutter/material.dart';
import 'model/feedback_repository.dart';
import 'feedback_form_page.dart';
import 'feedback_list_page.dart';
import 'about_page.dart';
import 'search_delegate.dart';
import 'utils/navigation.dart';

class HomePage extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const HomePage({super.key, required this.isDark, required this.onThemeChanged});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _openForm() async {
    await pushAnimated(context, const FeedbackFormPage());
    setState(() {});
  }

  Future<void> _openList() async {
    await pushAnimated(context, const FeedbackListPage());
    setState(() {});
  }

  Future<void> _openAbout() async {
    await pushAnimated(context, const AboutPage());
  }

  Future<void> _openSearch() async {
    await showSearch(context: context, delegate: FeedbackSearchDelegate());
    setState(() {});
  }

  Widget _bigActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color ?? Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 30, color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(subtitle, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasData = FeedbackRepository.all().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 12),
            const FlutterLogo(size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('flutter_campus_feedback', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(
                    'Kuesioner kepuasan mahasiswa terhadap fasilitas & layanan kampus',
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: _openSearch, tooltip: 'Cari feedback'),
          IconButton(
            icon: Icon(widget.isDark ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => widget.onThemeChanged(!widget.isDark),
            tooltip: 'Toggle dark mode',
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Judul kecil
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Pilihan cepat', style: Theme.of(context).textTheme.titleMedium),
            ),

            const SizedBox(height: 8),

            // Tombol besar vertikal (stacked)
            _bigActionCard(
              icon: Icons.edit_document,
              title: 'Isi Formulir Feedback',
              subtitle: 'Isi kuesioner singkat tentang fasilitas kampus',
              onTap: _openForm,
              color: Colors.green[300],
            ),

            _bigActionCard(
              icon: Icons.list,
              title: 'Lihat Daftar Feedback',
              subtitle: hasData ? 'Tampilkan semua feedback yang masuk' : 'Belum ada feedback tersimpan',
              onTap: hasData ? _openList : () {
                // beri penjelasan singkat jika belum ada data
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Belum ada data. Isi form terlebih dahulu.')),
                );
              },
              color: Colors.blue[300],
            ),

            _bigActionCard(
              icon: Icons.info_outline,
              title: 'Tentang Aplikasi',
              subtitle: 'Informasi dosen pengampu, pengembang, dan kampus',
              onTap: _openAbout,
              color: Colors.purple[300],
            ),

            const SizedBox(height: 12),

            // Motivational text di bawah (tetap)
            Expanded(
              child: Center(
                child: Text(
                  '“Coding adalah seni memecahkan masalah dengan logika dan kreativitas.”',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
