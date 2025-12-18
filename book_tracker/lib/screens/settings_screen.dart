import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_tracker/providers/book_provider.dart';
import 'package:book_tracker/providers/theme_provider.dart';
import 'package:book_tracker/services/db_service.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookProv = Provider.of<BookProvider>(context, listen: false);
    final themeProv = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        SwitchListTile(
          title: const Text('Dark Mode'),
          value: themeProv.isDarkMode,
          onChanged: (_) => themeProv.toggleTheme(),
        ),
        const SizedBox(height: 12),
        ListTile(
          title: const Text('Clear library (delete all local books)'),
          trailing: const Icon(Icons.delete_forever),
          onTap: () async {
            final ok = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Confirm'),
                content: const Text('Delete all books from local DB?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
                  TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes')),
                ],
              ),
            );
            if (ok == true) {
              await DBService.instance.clearAll();
              await bookProv.loadAll();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Library cleared')));
              }
            }
          },
        )
      ]),
    );
  }
}