// lib/feedback_detail_page.dart
import 'package:flutter/material.dart';
import 'model/feedback_item.dart';
import 'model/feedback_repository.dart';

class FeedbackDetailPage extends StatelessWidget {
  final FeedbackItem item;
  const FeedbackDetailPage({super.key, required this.item});

  String _initials(String name) {
    final parts = name.split(' ').where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  CircleAvatar(radius: 28, backgroundColor: Colors.indigo[50], child: Text(_initials(item.nama), style: const TextStyle(color: Colors.indigo))),
                  const SizedBox(width: 12),
                  Expanded(child: Text(item.nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                  Text('${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year}', style: const TextStyle(color: Colors.black54)),
                ]),
                const SizedBox(height: 12),
                Text('NIM: ${item.nim}'),
                const SizedBox(height: 8),
                Text('Fakultas: ${item.fakultas}'),
                const SizedBox(height: 8),
                Text('Fasilitas dinilai: ${item.fasilitas.join(', ')}'),
                const SizedBox(height: 8),
                Row(children: [
                  const Text('Nilai kepuasan: ', style: TextStyle(fontWeight: FontWeight.w600)),
                  Text('${item.nilaiKepuasan}'),
                ]),
                const SizedBox(height: 8),
                Text('Jenis feedback: ${item.jenisFeedback}'),
                const SizedBox(height: 8),
                Text('Setuju syarat: ${item.setuju ? "Ya" : "Tidak"}'),
                const SizedBox(height: 12),
                const Text('Pesan tambahan:', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(item.pesanTambahan ?? '-'),
                const SizedBox(height: 18),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Kembali')),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Hapus Feedback'),
                          content: const Text('Apakah Anda yakin ingin menghapus feedback ini?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
                            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus')),
                          ],
                        ),
                      );
                      if (ok == true) {
                        await FeedbackRepository.remove(item);
                        Navigator.pop(context, 'deleted');
                      }
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Hapus'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
