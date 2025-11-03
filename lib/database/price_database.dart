import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

Database? _database;

class PriceDatabase {
  Future get database async {
    if (_database != null) return _database;
    _database = await _initializeDB('price.db');
  }

  Future _initializeDB(String filepath) async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filepath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE PriceHistory(id INTEGER PRIMARY KEY,
      history_id TEXT NOT NULL
      createdAt DATETIME NOT NULL,
      outfitName TEXT NOT NULL
      category TEXT NOT NULL
      currency TEXT NOT NULL
      inputs JSON NOT NULL
      outputs JSON NOT NULL
    )''');
  }

  Future addPrice(data) async {
    final db = await database;
    await db.insert("PriceHistory", data);
    print('Added To database Successfully');

    return 'success';
  }

  Future readAllData() async {
    final db = await database;
    final allData = await db!.query("PriceHistory");

    return allData;
  }
}