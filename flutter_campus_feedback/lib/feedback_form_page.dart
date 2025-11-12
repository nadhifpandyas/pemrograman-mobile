// lib/feedback_form_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'model/feedback_item.dart';
import 'model/feedback_repository.dart';
import 'feedback_list_page.dart';
import 'utils/navigation.dart';

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaCtrl = TextEditingController();
  final TextEditingController _nimCtrl = TextEditingController();
  String? _selectedFakultas;
  final List<String> _fakultasOptions = [
    'Fakultas Teknik',
    'Fakultas Ekonomi',
    'Fakultas Ushuluddin',
    'Fakultas Keguruan & Ilmu Pendidikan',
    'Fakultas Sains & Teknologi'
  ];

  final Map<String, bool> _fasilitas = {
    'Perpustakaan': false,
    'WiFi Kampus': false,
    'Ruang Kelas': false,
    'Laboratorium': false,
    'Toilet Umum': false,
  };

  int _nilai = 3;
  String _jenisFeedback = 'Saran';
  bool _setuju = false;
  final TextEditingController _pesanTambahanCtrl = TextEditingController();

  @override
  void dispose() {
    _namaCtrl.dispose();
    _nimCtrl.dispose();
    _pesanTambahanCtrl.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_setuju) {
      // Alert jika switch belum aktif
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Persetujuan Diperlukan'),
          content: const Text('Anda belum menyetujui syarat & ketentuan. Harap aktifkan switch untuk menyimpan.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      );
      return;
    }

    final fasilitasDipilih = _fasilitas.entries.where((e) => e.value).map((e) => e.key).toList();
    if (fasilitasDipilih.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih minimal satu fasilitas yang dinilai.')));
      return;
    }

    final item = FeedbackItem(
      nama: _namaCtrl.text.trim(),
      nim: _nimCtrl.text.trim(),
      fakultas: _selectedFakultas ?? '',
      fasilitas: fasilitasDipilih,
      nilaiKepuasan: _nilai,
      jenisFeedback: _jenisFeedback,
      setuju: _setuju,
      pesanTambahan: _pesanTambahanCtrl.text.trim().isEmpty ? null : _pesanTambahanCtrl.text.trim(),
    );

    await FeedbackRepository.add(item);

    // setelah tersimpan, pindah ke daftar (dengan animasi)
    await pushAnimated(context, const FeedbackListPage());
    // jika pengguna menekan kembali ke home, rebuild home
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      appBar: AppBar(title: const Text('Form Feedback Mahasiswa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isWide ? 720 : 520),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _namaCtrl,
                        decoration: const InputDecoration(labelText: 'Nama Mahasiswa', prefixIcon: Icon(Icons.person), border: OutlineInputBorder()),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _nimCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(labelText: 'NIM', prefixIcon: Icon(Icons.confirmation_number), border: OutlineInputBorder()),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'NIM wajib diisi';
                          if (!RegExp(r'^[0-9]+$').hasMatch(v.trim())) return 'NIM harus angka';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _selectedFakultas,
                        items: _fakultasOptions.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                        onChanged: (v) => setState(() => _selectedFakultas = v),
                        decoration: const InputDecoration(labelText: 'Fakultas', border: OutlineInputBorder()),
                        validator: (v) => (v == null || v.isEmpty) ? 'Pilih fakultas' : null,
                      ),
                      const SizedBox(height: 12),
                      Align(alignment: Alignment.centerLeft, child: Text('Fasilitas yang Dinilai', style: TextStyle(fontWeight: FontWeight.w600))),
                      const SizedBox(height: 6),
                      ..._fasilitas.keys.map((k) => CheckboxListTile(
                        title: Text(k),
                        value: _fasilitas[k],
                        onChanged: (val) => setState(() => _fasilitas[k] = val ?? false),
                        controlAffinity: ListTileControlAffinity.leading,
                      )),
                      const SizedBox(height: 6),
                      Align(alignment: Alignment.centerLeft, child: Text('Nilai Kepuasan: $_nilai', style: const TextStyle(fontWeight: FontWeight.w600))),
                      Slider(value: _nilai.toDouble(), min: 1, max: 5, divisions: 4, label: '$_nilai', onChanged: (v) => setState(() => _nilai = v.round())),
                      const SizedBox(height: 8),
                      Align(alignment: Alignment.centerLeft, child: Text('Jenis Feedback', style: const TextStyle(fontWeight: FontWeight.w600))),
                      RadioListTile<String>(value: 'Saran', groupValue: _jenisFeedback, title: const Text('Saran'), onChanged: (v) => setState(() => _jenisFeedback = v!)),
                      RadioListTile<String>(value: 'Keluhan', groupValue: _jenisFeedback, title: const Text('Keluhan'), onChanged: (v) => setState(() => _jenisFeedback = v!)),
                      RadioListTile<String>(value: 'Apresiasi', groupValue: _jenisFeedback, title: const Text('Apresiasi'), onChanged: (v) => setState(() => _jenisFeedback = v!)),
                      const SizedBox(height: 8),
                      SwitchListTile(title: const Text('Setuju Syarat & Ketentuan'), value: _setuju, onChanged: (v) => setState(() => _setuju = v)),
                      const SizedBox(height: 8),
                      TextFormField(controller: _pesanTambahanCtrl, decoration: const InputDecoration(labelText: 'Pesan tambahan (opsional)', border: OutlineInputBorder()), maxLines: 2),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: ElevatedButton.icon(onPressed: _simpan, icon: const Icon(Icons.save), label: const Text('Simpan Feedback'))),
                          const SizedBox(width: 12),
                          Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Batal'))),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
