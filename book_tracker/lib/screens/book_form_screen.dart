import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_tracker/models/book.dart';
import 'package:book_tracker/providers/book_provider.dart';

class BookFormScreen extends StatefulWidget {
  static const routeName = '/book-form';
  const BookFormScreen({Key? key}) : super(key: key);

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _authorsCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _thumbnailCtrl = TextEditingController();
  Book? editing;
  String status = 'to-read';
  int rating = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)!.settings.arguments;
    if (arg != null && editing == null) {
      editing = arg as Book;
      _titleCtrl.text = editing!.title;
      _authorsCtrl.text = editing!.authors;
      _notesCtrl.text = editing!.notes;
      _thumbnailCtrl.text = editing!.thumbnail;
      status = editing!.status;
      rating = editing!.rating;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _authorsCtrl.dispose();
    _notesCtrl.dispose();
    _thumbnailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<BookProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text(editing == null ? 'Add Book' : 'Edit Book')),
      body: prov.loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Title'), validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
              TextFormField(controller: _authorsCtrl, decoration: const InputDecoration(labelText: 'Authors (comma separated)')),
              TextFormField(controller: _thumbnailCtrl, decoration: const InputDecoration(labelText: 'Thumbnail URL')),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(value: status, items: const [DropdownMenuItem(value: 'to-read', child: Text('To Read')), DropdownMenuItem(value: 'reading', child: Text('Reading')), DropdownMenuItem(value: 'finished', child: Text('Finished'))], onChanged: (v) => setState(() => status = v ?? 'to-read'), decoration: const InputDecoration(labelText: 'Status')),
              const SizedBox(height: 8),
              TextFormField(controller: _notesCtrl, decoration: const InputDecoration(labelText: 'Notes'), maxLines: 4),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Validation failed')));
                    return;
                  }
                  final book = Book(
                    id: editing?.id,
                    title: _titleCtrl.text.trim(),
                    authors: _authorsCtrl.text.trim(),
                    thumbnail: _thumbnailCtrl.text.trim(),
                    notes: _notesCtrl.text.trim(),
                    status: status,
                  );
                  try {
                    if (editing == null) {
                      await prov.addBook(book);
                    } else {
                      book.id = editing!.id;
                      await prov.updateBook(book);
                    }
                    if (context.mounted) Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
                  }
                },
                child: const Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}