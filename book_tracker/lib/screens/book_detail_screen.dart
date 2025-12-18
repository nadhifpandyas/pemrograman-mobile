import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_tracker/models/book.dart';
import 'package:book_tracker/providers/book_provider.dart';
import 'package:book_tracker/screens/book_form_screen.dart';

class BookDetailScreen extends StatelessWidget {
  static const routeName = '/book-detail';
  const BookDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Book book = ModalRoute.of(context)!.settings.arguments as Book;
    final prov = Provider.of<BookProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.pushNamed(context, BookFormScreen.routeName, arguments: book),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(title: const Text('Delete?'), content: const Text('Delete this book?'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')), TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes'))]));
              if (ok == true) {
                await prov.deleteBook(book.id!);
                if (context.mounted) Navigator.pop(context);
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (book.thumbnail.isNotEmpty)
            Hero(tag: 'thumb-${book.id ?? book.remoteId}', child: Image.network(book.thumbnail, height: 180)),
          const SizedBox(height: 12),
          Text(book.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('By: ${book.authors}'),
          const SizedBox(height: 8),
          Row(children: [Text('Pages: ${book.pageCount}'), const SizedBox(width: 16), Text('Published: ${book.publishedDate}')]),
          const SizedBox(height: 12),
          const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(book.description.isEmpty ? '—' : book.description),
          const SizedBox(height: 12),
          const Text('Notes', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(book.notes.isEmpty ? '—' : book.notes),
        ]),
      ),
    );
  }
}