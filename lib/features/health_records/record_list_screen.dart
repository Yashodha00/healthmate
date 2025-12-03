import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/health_provider.dart';
import 'record_item.dart';
import 'search_records_screen.dart';

class RecordListScreen extends StatefulWidget {
  const RecordListScreen({Key? key}) : super(key: key);

  @override
  State<RecordListScreen> createState() => _RecordListScreenState();
}

class _RecordListScreenState extends State<RecordListScreen> {
  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final provider = Provider.of<HealthProvider>(context, listen: false);
    await provider.loadAllRecords();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HealthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Records'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchRecordsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-record');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: provider.filteredRecords.isEmpty
          ? const Center(
        child: Text(
          'No health records found.\nTap + to add your first record!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: provider.filteredRecords.length,
        itemBuilder: (context, index) {
          final record = provider.filteredRecords[index];
          return RecordItem(record: record);
        },
      ),
    );
  }
}