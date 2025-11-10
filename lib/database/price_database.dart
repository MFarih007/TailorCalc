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
    final databasePath = join(databaseDirPath, 'price.db');

    return await openDatabase(
      databasePath,
      version: 2,
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

        await db.execute('''
          CREATE TABLE Templates(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            templateName TEXT NOT NULL,
            outfitName TEXT NOT NULL,
            category TEXT NOT NULL,
            currency TEXT NOT NULL,
            inputs TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL
          )''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS Templates(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              templateName TEXT NOT NULL,
              outfitName TEXT NOT NULL,
              category TEXT NOT NULL,
              currency TEXT NOT NULL,
              inputs TEXT NOT NULL,
              createdAt TEXT NOT NULL,
              updatedAt TEXT NOT NULL
            )''');
        }
      },
      onOpen: (Database db) async {
        // Safety: ensure both tables exist even if a previous bad migration occurred
        await db.execute('''
          CREATE TABLE IF NOT EXISTS PriceHistory(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            historyId TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            outfitName TEXT NOT NULL,
            category TEXT NOT NULL,
            currency TEXT NOT NULL,
            inputs TEXT NOT NULL,
            outputs TEXT NOT NULL
          )''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS Templates(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            templateName TEXT NOT NULL,
            outfitName TEXT NOT NULL,
            category TEXT NOT NULL,
            currency TEXT NOT NULL,
            inputs TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL
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

  Future<int> clearHistory() async {
    final db = await database;
    return await db.delete('PriceHistory');
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
        'outputs': outputsJson, // Store in 'outputs' field to match database schema
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Template methods
  Future<List<Template>> getAllTemplates() async {
    final db = await database;
    final templates = await db.query(
      'Templates',
      orderBy: 'updatedAt DESC',
    );

    return templates.map((row) {
      final inputsJson = jsonDecode(row['inputs'] as String) as Map<String, dynamic>;
      return Template.fromJson({
        'id': row['id'],
        'templateName': row['templateName'],
        'outfitName': row['outfitName'],
        'category': row['category'],
        'inputs': inputsJson,
        'createdAt': row['createdAt'],
        'updatedAt': row['updatedAt'],
      });
    }).toList();
  }

  Future<int> insertTemplate(Template template) async {
    final db = await database;

    final inputsJson = jsonEncode(template.inputs.toJson());
    
    return await db.insert(
      'Templates',
      {
        'templateName': template.templateName,
        'outfitName': template.outfitName,
        'category': template.category,
        'currency': template.currency,
        'inputs': inputsJson,
        'createdAt': template.createdAt.toIso8601String(),
        'updatedAt': template.updatedAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateTemplate(Template template) async {
    final db = await database;

    final inputsJson = jsonEncode(template.inputs.toJson());
    
    return await db.update(
      'Templates',
      {
        'templateName': template.templateName,
        'outfitName': template.outfitName,
        'category': template.category,
        'inputs': inputsJson,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [template.id],
    );
  }

  Future<int> deleteTemplate(int id) async {
    final db = await database;
    return await db.delete(
      'Templates',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}