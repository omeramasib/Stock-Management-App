import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  static Database? _database;

  DBService._internal();

  factory DBService() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'product_stock.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            stock INTEGER NOT NULL,
            price REAL NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    final db = await database;
    return db.query(table);
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return db.insert(table, values);
  }

    Future<void> update(String table, Map<String, dynamic> values, int id) async {
    final db = await database;
    await db.update(
      table,
      values,
      where: 'id = ?', 
      whereArgs: [id],
    );
  }

  Future<int> delete(String table, int id) async {
    final db = await database;
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}