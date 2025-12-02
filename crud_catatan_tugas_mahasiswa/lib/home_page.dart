// lib/home_page.dart
import 'package:flutter/material.dart';
import 'note_model.dart';
import 'notes_repository.dart';
import 'note_form_page.dart';
import 'note_detail_page.dart';
import 'widgets/note_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final bool initialDark;
  const HomePage({super.key, required this.initialDark});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = [];
  String _selectedFilter = 'All'; // All or category name
  final List<String> categories = ['All', 'Kuliah', 'Organisasi', 'Pribadi', 'Lain-lain'];

  bool _isDark = false;
  static const _prefDark = 'pref_dark_mode';

  @override
  void initState() {
    super.initState();
    _isDark = widget.initialDark;
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() => notes = NotesRepository.all());
  }

  List<Note> get _filtered {
    if (_selectedFilter == 'All') return notes;
    return notes.where((n) => n.category == _selectedFilter).toList();
  }

  Future<void> _openAdd() async {
    final saved = await Navigator.push(context, MaterialPageRoute(builder: (_) => const NoteFormPage()));
    if (saved == true) _loadNotes();
  }

  Future<void> _openDetail(Note note) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => NoteDetailPage(note: note)));
    if (result == 'deleted' || result == 'updated') {
      _loadNotes();
    }
  }

  Future<void> _editNote(Note note) async {
    final saved = await Navigator.push(context, MaterialPageRoute(builder: (_) => NoteFormPage(existing: note)));
    if (saved == true) _loadNotes();
  }

  Future<void> _deleteNote(Note note) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Hapus Catatan'),
        content: const Text('Yakin hapus catatan ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Hapus')),
        ],
      ),
    );
    if (ok == true) {
      await NotesRepository.remove(note);
      _loadNotes();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Catatan dihapus')));
    }
  }

  Future<void> _toggleDark(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefDark, v);
    setState(() => _isDark = v);
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Tugas Mahasiswa'),
        actions: [
          Row(
            children: [
              const Icon(Icons.dark_mode, size: 18),
              Switch(value: _isDark, onChanged: _toggleDark),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // filter dropdown
            Row(
              children: [
                const Text('Filter: '),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedFilter,
                  items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setState(() => _selectedFilter = v ?? 'All'),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () async {
                    await NotesRepository.clearAll();
                    _loadNotes();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Semua catatan dihapus (demo)')));
                  },
                  icon: const Icon(Icons.delete_sweep),
                  label: const Text('Hapus Semua'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: list.isEmpty
                  ? Center(child: Text('Belum ada catatan untuk kategori "$_selectedFilter".', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)))
                  : ListView.builder(
                itemCount: list.length,
                itemBuilder: (c, i) {
                  final note = list[i];
                  return NoteTile(
                    note: note,
                    onTap: () => _openDetail(note),
                    onEdit: () => _editNote(note),
                    onDelete: () => _deleteNote(note),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}
