// lib/model/feedback_repository.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'feedback_item.dart';

class FeedbackRepository {
  static const _key = 'feedback_items_v1';
  static List<FeedbackItem> _items = [];

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null && raw.isNotEmpty) {
      try {
        final List decoded = jsonDecode(raw) as List;
        _items = decoded.map((e) => FeedbackItem.fromJson(e)).toList();
      } catch (_) {
        _items = [];
      }
    } else {
      _items = [];
    }
  }

  static List<FeedbackItem> all() => List.unmodifiable(_items);

  static Future<void> add(FeedbackItem item) async {
    _items.add(item);
    await _save();
  }

  static Future<void> remove(FeedbackItem item) async {
    _items.remove(item);
    await _save();
  }

  static Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_items.map((e) => e.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  // utility search
  static List<FeedbackItem> search(String q) {
    final ql = q.toLowerCase();
    return _items.where((f) {
      return f.nama.toLowerCase().contains(ql) ||
          f.fakultas.toLowerCase().contains(ql) ||
          f.jenisFeedback.toLowerCase().contains(ql) ||
          f.pesanTambahan?.toLowerCase().contains(ql) == true;
    }).toList();
  }
}
