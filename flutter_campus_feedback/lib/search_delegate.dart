// lib/search_delegate.dart
import 'package:flutter/material.dart';
import 'model/feedback_repository.dart';
import 'model/feedback_item.dart';
import 'utils/navigation.dart';
import 'feedback_detail_page.dart';

class FeedbackSearchDelegate extends SearchDelegate<void> {
  FeedbackSearchDelegate() : super(searchFieldLabel: 'Cari nama / fakultas / jenis...');

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = FeedbackRepository.search(query.trim());
    if (results.isEmpty) {
      return const Center(child: Text('Tidak ditemukan', style: TextStyle(fontSize: 16)));
    }

    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final FeedbackItem item = results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.indigo[50],
            child: Text(_initials(item.nama), style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
          ),
          title: Text(item.nama),
          subtitle: Text('${item.fakultas} • ${item.jenisFeedback} • Nilai: ${item.nilaiKepuasan}'),
          trailing: Icon(_iconForType(item.jenisFeedback).icon, color: _iconForType(item.jenisFeedback).color),
          onTap: () {
            // tutup search dulu, lalu navigasi ke detail dengan animasi
            close(context, null);
            Future.microtask(() => pushAnimated(context, FeedbackDetailPage(item: item)));
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final queryTrim = query.trim();
    final suggestions = queryTrim.isEmpty
        ? FeedbackRepository.all().reversed.take(6).toList()
        : FeedbackRepository.search(queryTrim);

    if (suggestions.isEmpty) {
      return const Center(child: Text('Tidak ada saran', style: TextStyle(fontSize: 14)));
    }

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, idx) {
        final it = suggestions[idx];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.indigo[50],
            child: Text(_initials(it.nama), style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
          ),
          title: Text(it.nama),
          subtitle: Text(it.fakultas),
          onTap: () {
            query = it.nama;
            showResults(context);
          },
        );
      },
    );
  }

  String _initials(String name) {
    final parts = name.split(' ').where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  Icon _iconForType(String jenis) {
    switch (jenis) {
      case 'Apresiasi':
        return Icon(Icons.thumb_up, color: Colors.green[700]);
      case 'Keluhan':
        return Icon(Icons.report_problem, color: Colors.red[700]);
      default:
        return Icon(Icons.lightbulb, color: Colors.orange[700]); // Saran
    }
  }
}
