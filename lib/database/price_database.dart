import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tailor_calc/models/pricinghistoryrecord.dart';

class PriceDatabase {
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'price.db');

    return await openDatabase(databasePath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE PriceHistory(id INTEGER PRIMARY KEY,
          historyId TEXT NOT NULL
          createdAt DATETIME NOT NULL,
          outfitName TEXT NOT NULL
          category TEXT NOT NULL
          currency TEXT NOT NULL
          inputs JSON NOT NULL
          outputs JSON NOT NULL
        )''');
      },
    );
  }

  Future<List<PricingHistoryRecord>> readAllHistory() async {
    final db = await database;
    final allHistory = await db.query("PriceHistory");

    return allHistory.map((json) => PricingHistoryRecord.fromJson(json)).toList();
  }
}