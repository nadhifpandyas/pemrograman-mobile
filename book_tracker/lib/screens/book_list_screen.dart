import 'package:book_tracker/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_tracker/widgets/book_card.dart';
import 'package:book_tracker/screens/book_form_screen.dart';
import 'package:book_tracker/utils/animations.dart';

class BookListScreen extends StatelessWidget {
  static const routeName = '/books';
  const BookListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<BookProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              try {
                await prov.syncFromApi('tere liye', addAll: true);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sync completed')));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sync failed: $e')));
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearch(context: context, delegate: _BookSearch(prov)),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(RouteAnimations.createRoute(const BookFormScreen())),
      ),
      body: prov.loading
          ? const Center(child: CircularProgressIndicator())
          : prov.books.isEmpty
          ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const Text('No books yet'), const SizedBox(height: 8), ElevatedButton(onPressed: () => Navigator.pushNamed(context, BookFormScreen.routeName), child: const Text('Add first book'))]))
          : ListView.builder(
        itemCount: prov.books.length,
        itemBuilder: (ctx, i) => BookCard(book: prov.books[i]),
      ),
    );
  }
}

class _BookSearch extends SearchDelegate {
  final BookProvider prov;
  _BookSearch(this.prov);

  @override
  List<Widget>? buildActions(BuildContext context) => [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) {
    prov.setFilter(query);
    return Consumer<BookProvider>(builder: (_, p, __) => ListView.builder(itemCount: p.books.length, itemBuilder: (_, i) => BookCard(book: p.books[i])));
  }

  @override
  Widget buildSuggestions(BuildContext context) => Container();
}