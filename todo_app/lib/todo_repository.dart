// lib/todo_repository.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'todo_model.dart';

class TodoRepository {
  static const String _key = 'todo_items_v1';
  static List<Todo> _items = [];

  /// Panggil ini sebelum runApp jika ingin inisialisasi awal
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null && raw.isNotEmpty) {
      try {
        final List decoded = jsonDecode(raw) as List;
        _items = decoded.map((e) => Todo.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {
        _items = [];
      }
    } else {
      _items = [];
    }
  }

  static List<Todo> all() => List.unmodifiable(_items);

  static Future<void> add(Todo t) async {
    _items.insert(0, t); // paling atas
    await _save();
  }

  static Future<void> update(Todo t) async {
    final idx = _items.indexWhere((e) => e.id == t.id);
    if (idx != -1) {
      _items[idx] = t;
      await _save();
    }
  }

  static Future<void> remove(Todo t) async {
    _items.removeWhere((e) => e.id == t.id);
    await _save();
  }

  static Future<void> toggle(Todo t) async {
    final idx = _items.indexWhere((e) => e.id == t.id);
    if (idx != -1) {
      _items[idx].isCompleted = !_items[idx].isCompleted;
      await _save();
    }
  }

  static Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_items.map((e) => e.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  static Future<void> clearAll() async {
    _items.clear();
    await _save();
  }
}
