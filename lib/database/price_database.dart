import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'package:tailor_calc/models/pricinghistoryrecord.dart';
import 'package:tailor_calc/models/template.dart';

class PriceDatabase {
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    print('Database directory path: $databaseDirPath');
    final databasePath = join(databaseDirPath, 'price.db');

    return await openDatabase(databasePath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE PriceHistory(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            historyId TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            outfitName TEXT NOT NULL,
            category TEXT NOT NULL,
            currency TEXT NOT NULL,
            inputs TEXT NOT NULL,
            outputs TEXT NOT NULL
          )''');
      },
    );
  }

  Future<List<PricingHistoryRecord>> readAllHistory() async {
    final db = await database;
    final allHistory = await db.query("PriceHistory");

    return allHistory.map((row) {
      // Parse JSON strings back to objects
      final inputsJson = jsonDecode(row['inputs'] as String) as Map<String, dynamic>;
      final outputsJson = jsonDecode(row['outputs'] as String) as Map<String, dynamic>;
      
      return PricingHistoryRecord.fromJson({
        'id': row['id'],
        'historyId': row['historyId'],
        'createdAt': row['createdAt'],
        'outfitName': row['outfitName'],
        'category': row['category'],
        'currency': row['currency'],
        'inputs': inputsJson,
        'computed': outputsJson,
      });
    }).toList();
  }

  Future<int> insertRecord(PricingHistoryRecord record) async {
    final db = await database;
    
    // Convert inputs and computed to JSON strings
    final inputsJson = jsonEncode(record.inputs.toJson());
    final outputsJson = jsonEncode(record.computed.toJson());
    
    return await db.insert(
      'PriceHistory',
      {
        'historyId': record.historyId,
        'createdAt': record.createdAt.toIso8601String(),
        'outfitName': record.outfitName,
        'category': record.category,
        'currency': record.currency,
        'inputs': inputsJson,
        'outputs': outputsJson,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}