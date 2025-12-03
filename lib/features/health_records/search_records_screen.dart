import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/health_provider.dart';
import 'record_item.dart';

class SearchRecordsScreen extends StatefulWidget {
  const SearchRecordsScreen({Key? key}) : super(key: key);

  @override
  State<SearchRecordsScreen> createState() => _SearchRecordsScreenState();
}

class _SearchRecordsScreenState extends State<SearchRecordsScreen> {
  final _searchController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final provider = Provider.of<HealthProvider>(context, listen: false);
    provider.searchRecordsByDate(_searchController.text);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _searchController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _selectedDate = null;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HealthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Records'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearSearch,
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Date (YYYY-MM-DD)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: provider.filteredRecords.isEmpty
                ? const Center(
              child: Text(
                'No records found for this date',
                style: TextStyle(fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: provider.filteredRecords.length,
              itemBuilder: (context, index) {
                final record = provider.filteredRecords[index];
                return RecordItem(record: record);
              },
            ),
          ),
        ],
      ),
    );
  }
}