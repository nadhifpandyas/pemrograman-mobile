// lib/notes_repository.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'note_model.dart';

class NotesRepository {
  static const _keyNotes = 'notes_v1';
  static List<Note> _notes = [];

  // inisialisasi, panggil sebelum runApp
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyNotes);
    if (raw != null && raw.isNotEmpty) {
      try {
        final List decoded = jsonDecode(raw) as List;
        _notes = decoded.map((e) => Note.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {
        _notes = [];
      }
    } else {
      _notes = [];
    }
  }

  static List<Note> all() => List.unmodifiable(_notes);

  static Future<void> add(Note note) async {
    _notes.insert(0, note);
    await _save();
  }

  static Future<void> update(Note note) async {
    final idx = _notes.indexWhere((n) => n.id == note.id);
    if (idx != -1) {
      _notes[idx] = note;
      await _save();
    }
  }

  static Future<void> remove(Note note) async {
    _notes.removeWhere((n) => n.id == note.id);
    await _save();
  }

  static Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_notes.map((e) => e.toJson()).toList());
    await prefs.setString(_keyNotes, encoded);
  }

  static Future<void> clearAll() async {
    _notes.clear();
    await _save();
  }
}
