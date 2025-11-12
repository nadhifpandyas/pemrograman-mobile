// lib/feedback_list_page.dart
import 'package:flutter/material.dart';
import 'model/feedback_item.dart';
import 'model/feedback_repository.dart';
import 'feedback_detail_page.dart';
import 'utils/navigation.dart';

class FeedbackListPage extends StatefulWidget {
  const FeedbackListPage({super.key});

  @override
  State<FeedbackListPage> createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage> {
  List<FeedbackItem> data = [];

  @override
  void initState() {
    super.initState();
    data = FeedbackRepository.all().reversed.toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() => data = FeedbackRepository.all().reversed.toList());
  }

  Future<void> _openDetail(FeedbackItem item) async {
    final result = await pushAnimated(context, FeedbackDetailPage(item: item));
    if (result == 'deleted') {
      setState(() => data = FeedbackRepository.all().reversed.toList());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Feedback dihapus.')));
    }
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

  String _initials(String name) {
    final parts = name.split(' ').where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    data = FeedbackRepository.all().reversed.toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: data.isEmpty
            ? Center(child: Text('Belum ada feedback', style: TextStyle(color: Colors.grey[600])))
            : ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, idx) {
            final item = data[idx];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.indigo[50],
                  child: Text(_initials(item.nama), style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                ),
                title: Text(item.nama),
                subtitle: Text('${item.fakultas} • Nilai: ${item.nilaiKepuasan}'),
                trailing: _iconForType(item.jenisFeedback),
                onTap: () => _openDetail(item),
              ),
            );
          },
        ),
      ),
    );
  }
}
