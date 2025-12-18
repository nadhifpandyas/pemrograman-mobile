import 'package:flutter/material.dart';
import 'package:book_tracker/models/book.dart';
import 'package:book_tracker/screens/book_detail_screen.dart';

class BookCard extends StatelessWidget {
  final Book book;
  const BookCard({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: book.thumbnail.isNotEmpty
          ? Hero(tag: 'thumb-${book.id ?? book.remoteId}', child: Image.network(book.thumbnail, width: 48, height: 64, fit: BoxFit.cover))
          : const SizedBox(width: 48, height: 64, child: Icon(Icons.book)),
      title: Text(book.title),
      subtitle: Text(book.authors.isEmpty ? 'Unknown' : book.authors),
      trailing: Text(book.status),
      onTap: () => Navigator.pushNamed(context, BookDetailScreen.routeName, arguments: book),
    );
  }
}