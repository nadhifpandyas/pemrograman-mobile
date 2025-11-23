// lib/widgets/todo_tile.dart
import 'package:flutter/material.dart';
import '../todo_model.dart';

typedef OnEdit = void Function(Todo todo);
typedef OnDelete = void Function(Todo todo);
typedef OnToggle = void Function(Todo todo);

class TodoTile extends StatelessWidget {
  final Todo todo;
  final OnEdit onEdit;
  final OnDelete onDelete;
  final OnToggle onToggle;

  const TodoTile({
    super.key,
    required this.todo,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = todo.isCompleted
        ? const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)
        : const TextStyle();

    return Dismissible(
      key: ValueKey(todo.id),
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.orangeAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // hapus
          final ok = await showDialog<bool>(
            context: context,
            builder: (c) => AlertDialog(
              title: const Text('Hapus Todo'),
              content: const Text('Yakin ingin menghapus todo ini?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Batal')),
                TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Hapus')),
              ],
            ),
          );
          if (ok == true) onDelete(todo);
          return ok;
        } else {
          // swipe kanan->kiri = edit
          onEdit(todo);
          return false;
        }
      },
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => onToggle(todo),
        ),
        title: Text(todo.title, style: textStyle),
        subtitle: Text(
          'Dibuat: ${todo.createdAt.day}/${todo.createdAt.month}/${todo.createdAt.year} ${todo.createdAt.hour}:${todo.createdAt.minute.toString().padLeft(2,'0')}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => showModalBottomSheet(
            context: context,
            builder: (c) {
              return SafeArea(
                child: Wrap(
                  children: [
                    ListTile(leading: const Icon(Icons.edit), title: const Text('Edit'), onTap: () { Navigator.pop(c); onEdit(todo); }),
                    ListTile(leading: const Icon(Icons.delete), title: const Text('Hapus'), onTap: () { Navigator.pop(c); onDelete(todo); }),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
