// lib/widgets/note_tile.dart
import 'package:flutter/material.dart';
import '../note_model.dart';

IconData iconForCategory(String cat) {
  switch (cat) {
    case 'Kuliah':
      return Icons.school;
    case 'Organisasi':
      return Icons.people;
    case 'Pribadi':
      return Icons.person;
    default:
      return Icons.note;
  }
}

Color colorForCategory(String cat, BuildContext context) {
  switch (cat) {
    case 'Kuliah':
      return Colors.blue;
    case 'Organisasi':
      return Colors.green;
    case 'Pribadi':
      return Colors.orange;
    default:
      return Theme.of(context).colorScheme.primary;
  }
}

class NoteTile extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const NoteTile({
    super.key,
    required this.note,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final icon = iconForCategory(note.category);
    final color = colorForCategory(note.category, context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(note.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '${note.category} • ${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year} ${note.createdAt.hour.toString().padLeft(2,'0')}:${note.createdAt.minute.toString().padLeft(2,'0')}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (s) {
            if (s == 'edit') onEdit();
            if (s == 'delete') onDelete();
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Hapus')),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
