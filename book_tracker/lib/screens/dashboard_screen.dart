import 'package:book_tracker/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_tracker/screens/book_list_screen.dart';
import 'package:book_tracker/screens/book_form_screen.dart';
import 'package:book_tracker/widgets/stat_card.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/';
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<BookProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: prov.loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: prov.loadAll,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: StatCard(title: 'Total', value: prov.totalBooks.toString())),
                  const SizedBox(width: 8),
                  Expanded(child: StatCard(title: 'Reading', value: prov.readingCount.toString())),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: StatCard(title: 'Finished', value: prov.finishedCount.toString())),
                  const SizedBox(width: 8),
                  Expanded(child: StatCard(title: 'To Read', value: prov.toReadCount.toString())),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Reading Progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(height: 180, child: _buildPie(prov)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, BookListScreen.routeName),
                icon: const Icon(Icons.book),
                label: const Text('Open Library'),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, BookFormScreen.routeName),
                icon: const Icon(Icons.add),
                label: const Text('Add Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPie(BookProvider prov) {
    final total = prov.totalBooks.toDouble();
    final data = [prov.readingCount.toDouble(), prov.finishedCount.toDouble(), prov.toReadCount.toDouble()];
    if (total == 0) return const Center(child: Text('No data yet'));
    return PieChart(PieChartData(sections: List.generate(3, (i) {
      final val = data[i];
      final title = val == 0 ? '' : '${(val / total * 100).round()}%';
      final color = [Colors.orange, Colors.green, Colors.blue][i];
      return PieChartSectionData(value: val, title: title, radius: 50, titleStyle: const TextStyle(color: Colors.white, fontSize: 12), color: color);
    })));
  }
}