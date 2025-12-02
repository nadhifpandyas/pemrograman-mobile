// lib/note_detail_page.dart
import 'package:flutter/material.dart';
import 'note_model.dart';
import 'notes_repository.dart';
import 'note_form_page.dart';
import 'widgets/note_tile.dart';

class NoteDetailPage extends StatelessWidget {
  final Note note;
  const NoteDetailPage({super.key, required this.note});

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Hapus Catatan'),
        content: const Text('Anda yakin ingin menghapus catatan ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Hapus')),
        ],
      ),
    );
    if (ok == true) {
      await NotesRepository.remove(note);
      if (context.mounted) Navigator.pop(context, 'deleted');
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = iconForCategory(note.category);
    final color = colorForCategory(note.category, context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final saved = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NoteFormPage(existing: note)),
              );
              if (saved == true && context.mounted) {
                // kembali ke list dengan tanda agar update muncul
                Navigator.pop(context, 'updated');
              }
            },
          ),
          IconButton(icon: const Icon(Icons.delete), onPressed: () => _confirmDelete(context)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                CircleAvatar(backgroundColor: color.withOpacity(0.15), child: Icon(icon, color: color)),
                const SizedBox(width: 12),
                Expanded(child: Text(note.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                Text('${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}', style: const TextStyle(color: Colors.black54)),
              ]),
              const SizedBox(height: 12),
              Text('Kategori: ${note.category}', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              const Text('Deskripsi:', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(note.description),
            ]),
          ),
        ),
      ),
    );
  }
}
