import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/health_record.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'healthmate.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE health_records(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        steps INTEGER NOT NULL,
        calories INTEGER NOT NULL,
        water INTEGER NOT NULL
      )
    ''');

    // Insert dummy records
    await _insertDummyRecords(db);
  }

  Future<void> _insertDummyRecords(Database db) async {
    final records = [
      HealthRecord(
        date: '2025-11-25',
        steps: 8500,
        calories: 2200,
        water: 2000,
      ),
      HealthRecord(
        date: '2025-11-26',
        steps: 7500,
        calories: 2100,
        water: 1800,
      ),
      HealthRecord(
        date: '2025-11-27',
        steps: 10000,
        calories: 2400,
        water: 2200,
      ),
    ];

    for (var record in records) {
      await db.insert('health_records', record.toMap());
    }
  }

  // CRUD Operations
  Future<int> insertRecord(HealthRecord record) async {
    final db = await database;
    return await db.insert('health_records', record.toMap());
  }

  Future<List<HealthRecord>> getAllRecords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
    await db.query('health_records', orderBy: 'date DESC');
    return List.generate(maps.length, (i) => HealthRecord.fromMap(maps[i]));
  }

  Future<List<HealthRecord>> getRecordsByDate(String date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'health_records',
      where: 'date = ?',
      whereArgs: [date],
    );
    return List.generate(maps.length, (i) => HealthRecord.fromMap(maps[i]));
  }

  Future<int> updateRecord(HealthRecord record) async {
    final db = await database;
    return await db.update(
      'health_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteRecord(int id) async {
    final db = await database;
    return await db.delete(
      'health_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<HealthRecord>> getTodayRecords(String today) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'health_records',
      where: 'date = ?',
      whereArgs: [today],
    );
    return List.generate(maps.length, (i) => HealthRecord.fromMap(maps[i]));
  }
}