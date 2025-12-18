import 'dart:async';
import 'package:book_tracker/models/book.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DBService {
  DBService._();
  static final DBService instance = DBService._();
  Database? _db;

  Future<void> init() async {
    final docs = await getApplicationDocumentsDirectory();
    final path = join(docs.path, 'book_tracker.db');
    _db = await openDatabase(path, version: 1, onCreate: (db, v) async {
      await db.execute('''
        CREATE TABLE books (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          authors TEXT,
          description TEXT,
          thumbnail TEXT,
          publishedDate TEXT,
          pageCount INTEGER,
          status TEXT,
          rating INTEGER,
          notes TEXT,
          remoteId TEXT
        )
      ''');
    });
  }

  Future<int> insertBook(Book b) async {
    final db = _db!;
    return await db.insert('books', b.toMap());
  }

  Future<int> updateBook(Book b) async {
    final db = _db!;
    return await db.update('books', b.toMap(), where: 'id = ?', whereArgs: [b.id]);
  }

  Future<int> deleteBook(int id) async {
    final db = _db!;
    return await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Book>> getAllBooks() async {
    final db = _db!;
    final rows = await db.query('books', orderBy: 'id DESC');
    return rows.map((r) => Book.fromMap(r)).toList();
  }

  Future<Book?> getBookByRemoteId(String remoteId) async {
    final db = _db!;
    final rows = await db.query('books', where: 'remoteId = ?', whereArgs: [remoteId]);
    if (rows.isEmpty) return null;
    return Book.fromMap(rows.first);
  }

  Future<void> clearAll() async {
    final db = _db!;
    await db.delete('books');
  }
}