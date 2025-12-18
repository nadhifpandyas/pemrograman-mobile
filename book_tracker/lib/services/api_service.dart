import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:book_tracker/models/book.dart';

class ApiService {
  static const _base = 'https://www.googleapis.com/books/v1/volumes';

  // Search books by query
  static Future<List<Book>> searchBooks(String query) async {
    final url = '$_base?q=${Uri.encodeComponent(query)}&maxResults=20';
    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode != 200) throw Exception('API error: ${resp.statusCode}');
    final j = json.decode(resp.body) as Map<String, dynamic>;
    final items = j['items'] as List<dynamic>?;
    if (items == null) return [];
    return items.map((e) => Book.fromGoogleJson(e as Map<String, dynamic>)).toList();
  }

  // Fetch single by remote id
  static Future<Book?> fetchById(String remoteId) async {
    final url = '$_base/$remoteId';
    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode != 200) return null;
    final j = json.decode(resp.body) as Map<String, dynamic>;
    return Book.fromGoogleJson(j);
  }
}