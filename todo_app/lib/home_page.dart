// lib/home_page.dart
import 'package:flutter/material.dart';
import 'todo_model.dart';
import 'todo_repository.dart';
import 'widgets/todo_tile.dart';

enum FilterType { all, completed, pending }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> todos = [];
  FilterType _filter = FilterType.all;
  final TextEditingController _inputCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // load from repository
    setState(() => todos = TodoRepository.all());
  }

  List<Todo> get _filtered {
    switch (_filter) {
      case FilterType.completed:
        return todos.where((t) => t.isCompleted).toList();
      case FilterType.pending:
        return todos.where((t) => !t.isCompleted).toList();
      default:
        return todos;
    }
  }

  Future<void> _addTodoDialog() async {
    _inputCtrl.clear();
    await showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Tambah Todo'),
        content: TextField(
          controller: _inputCtrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Judul todo'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              final text = _inputCtrl.text.trim();
              if (text.isEmpty) return;
              final todo = Todo(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: text,
                createdAt: DateTime.now(),
              );
              await TodoRepository.add(todo);
              setState(() => todos = TodoRepository.all());
              Navigator.pop(c);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Todo ditambahkan')));
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  Future<void> _editTodoDialog(Todo t) async {
    _inputCtrl.text = t.title;
    await showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Edit Todo'),
        content: TextField(controller: _inputCtrl, autofocus: true, decoration: const InputDecoration(hintText: 'Judul todo')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              final text = _inputCtrl.text.trim();
              if (text.isEmpty) return;
              final updated = Todo(id: t.id, title: text, isCompleted: t.isCompleted, createdAt: t.createdAt);
              await TodoRepository.update(updated);
              setState(() => todos = TodoRepository.all());
              Navigator.pop(c);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Todo diperbarui')));
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTodo(Todo t) async {
    await TodoRepository.remove(t);
    setState(() => todos = TodoRepository.all());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Todo dihapus'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            // simple undo: re-add (note: createdAt new)
            final restored = Todo(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: t.title,
              isCompleted: t.isCompleted,
              createdAt: DateTime.now(),
            );
            await TodoRepository.add(restored);
            setState(() => todos = TodoRepository.all());
          },
        ),
      ),
    );
  }

  Future<void> _toggleTodo(Todo t) async {
    await TodoRepository.toggle(t);
    setState(() => todos = TodoRepository.all());
  }

  Widget _buildFilterChips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(label: const Text('Semua'), selected: _filter == FilterType.all, onSelected: (_) => setState(() => _filter = FilterType.all)),
        const SizedBox(width: 8),
        ChoiceChip(label: const Text('Selesai'), selected: _filter == FilterType.completed, onSelected: (_) => setState(() => _filter = FilterType.completed)),
        const SizedBox(width: 8),
        ChoiceChip(label: const Text('Belum'), selected: _filter == FilterType.pending, onSelected: (_) => setState(() => _filter = FilterType.pending)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Hapus semua',
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text('Hapus semua todo'),
                  content: const Text('Anda yakin ingin menghapus semua todo?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Batal')),
                    TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Hapus')),
                  ],
                ),
              );
              if (ok == true) {
                await TodoRepository.clearAll();
                setState(() => todos = TodoRepository.all());
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildFilterChips(),
            const SizedBox(height: 12),
            Expanded(
              child: list.isEmpty
                  ? Center(
                child: Text(
                  'Tidak ada todo.',
                  style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
                ),
              )
                  : ListView.builder(
                itemCount: list.length,
                itemBuilder: (c, i) {
                  final t = list[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TodoTile(
                      todo: t,
                      onEdit: (todo) => _editTodoDialog(todo),
                      onDelete: (todo) => _deleteTodo(todo),
                      onToggle: (todo) => _toggleTodo(todo),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodoDialog,
        child: const Icon(Icons.add),
        tooltip: 'Tambah todo',
      ),
    );
  }
}
