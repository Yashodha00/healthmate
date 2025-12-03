import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/health_record.dart';

class HealthProvider with ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<HealthRecord> _records = [];
  List<HealthRecord> _filteredRecords = [];

  List<HealthRecord> get records => _records;
  List<HealthRecord> get filteredRecords => _filteredRecords;

  Future<void> loadAllRecords() async {
    _records = await _databaseHelper.getAllRecords();
    _filteredRecords = _records;
    notifyListeners();
  }

  Future<void> addRecord(HealthRecord record) async {
    await _databaseHelper.insertRecord(record);
    await loadAllRecords();
  }

  Future<void> updateRecord(HealthRecord record) async {
    await _databaseHelper.updateRecord(record);
    await loadAllRecords();
  }

  Future<void> deleteRecord(int id) async {
    await _databaseHelper.deleteRecord(id);
    await loadAllRecords();
  }

  Future<void> searchRecordsByDate(String date) async {
    if (date.isEmpty) {
      _filteredRecords = _records;
    } else {
      _filteredRecords = await _databaseHelper.getRecordsByDate(date);
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>> getTodaySummary(String today) async {
    final todayRecords = await _databaseHelper.getTodayRecords(today);

    int totalSteps = 0;
    int totalCalories = 0;
    int totalWater = 0;

    for (var record in todayRecords) {
      totalSteps += record.steps;
      totalCalories += record.calories;
      totalWater += record.water;
    }

    return {
      'steps': totalSteps,
      'calories': totalCalories,
      'water': totalWater,
      'recordCount': todayRecords.length,
    };
  }
}