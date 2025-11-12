// lib/feedback_form_page.dart
import 'package:flutter/material.dart';
import 'feedback_detail_page.dart';

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  int _rating = 3;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameCtrl.text.trim();
    final msg = _msgCtrl.text.trim();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FeedbackDetailPage(
          title: name.isEmpty ? 'Tanpa Nama' : name,
          description: 'Pesan: $msg\nNilai: $_rating',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Kirim Data')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    const Text('Isi data untuk dikirim ke halaman detail', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: 'Nama', prefixIcon: Icon(Icons.person)),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _msgCtrl,
                      decoration: const InputDecoration(labelText: 'Pesan', prefixIcon: Icon(Icons.message)),
                      maxLines: 3,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Pesan wajib diisi' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Rating:'), Text('$_rating')]),
                    Slider(value: _rating.toDouble(), min: 1, max: 5, divisions: 4, label: '$_rating', onChanged: (v) => setState(() => _rating = v.round())),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(
                        child: ElevatedButton.icon(onPressed: _submit, icon: const Icon(Icons.send), label: const Text('Kirim ke Detail')),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Batal'))),
                    ])
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
