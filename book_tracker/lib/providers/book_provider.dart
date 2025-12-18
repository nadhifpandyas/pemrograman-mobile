import 'package:flutter/material.dart';
import 'package:book_tracker/models/book.dart';
import 'package:book_tracker/services/db_service.dart';
import 'package:book_tracker/services/api_service.dart';

class BookProvider extends ChangeNotifier {
  List<Book> _books = [];
  bool _loading = false;
  String _filter = '';

  List<Book> get books => _filter.isEmpty ? _books : _books.where((b) => b.title.toLowerCase().contains(_filter)).toList();
  bool get loading => _loading;
  String get filter => _filter;

  BookProvider();

  Future<void> loadAll() async {
    _loading = true;
    notifyListeners();
    final rows = await DBService.instance.getAllBooks();
    _books = rows;
    _loading = false;
    notifyListeners();
  }

  Future<void> addBook(Book b) async {
    _loading = true;
    notifyListeners();
    final id = await DBService.instance.insertBook(b);
    b.id = id;
    _books.insert(0, b);
    _loading = false;
    notifyListeners();
  }

  Future<void> updateBook(Book b) async {
    _loading = true;
    notifyListeners();
    await DBService.instance.updateBook(b);
    final i = _books.indexWhere((x) => x.id == b.id);
    if (i != -1) _books[i] = b;
    _loading = false;
    notifyListeners();
  }

  Future<void> deleteBook(int id) async {
    _loading = true;
    notifyListeners();
    await DBService.instance.deleteBook(id);
    _books.removeWhere((b) => b.id == id);
    _loading = false;
    notifyListeners();
  }

  void setFilter(String f) {
    _filter = f.toLowerCase();
    notifyListeners();
  }

  // Sync: fetch from API by query and save any new items into SQLite
  Future<void> syncFromApi(String query, {bool addAll = false}) async {
    _loading = true;
    notifyListeners();
    try {
      final apiBooks = await ApiService.searchBooks(query);
      for (final remoteBook in apiBooks) {
        final existing = await DBService.instance.getBookByRemoteId(remoteBook.remoteId);
        if (existing == null) {
          await DBService.instance.insertBook(remoteBook);
          if (addAll) _books.insert(0, remoteBook);
        }
      }
      // reload from DB to get ids
      final all = await DBService.instance.getAllBooks();
      _books = all;
    } catch (e) {
      // bubble error to UI via thrown exception
      _loading = false;
      notifyListeners();
      rethrow;
    }
    _loading = false;
    notifyListeners();
  }

  // Stats helpers
  int get totalBooks => _books.length;
  int get readingCount => _books.where((b) => b.status == 'reading').length;
  int get finishedCount => _books.where((b) => b.status == 'finished').length;
  int get toReadCount => _books.where((b) => b.status == 'to-read').length;
}