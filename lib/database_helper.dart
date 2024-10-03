import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('shopping_list.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      quantity INTEGER NOT NULL
    )
    ''');
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    final db = await instance.database;
    final result = await db.query('items');
    return result;
  }

  Future<void> insertItem(Map<String, dynamic> item) async {
    final db = await instance.database;
    await db.insert('items', item);
  }

  Future<void> updateItem(Map<String, dynamic> item) async {
    final db = await instance.database;
    await db.update('items', item, where: 'id = ?', whereArgs: [item['id']]);
  }

  Future<void> deleteItem(int id) async {
    final db = await instance.database;
    await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }
}
