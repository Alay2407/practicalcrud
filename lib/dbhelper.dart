import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model_class.dart';

class DBHelper {
  DBHelper._internal();
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() => _instance;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    path = join(path, 'items.db');
    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  void _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        age INTEGER
      )
    ''');
  }

  Future<int> insertItem(Item item) async {
    final db = await database;
    return await db.insert('items', item.toMap());
  }

  Future<List<Item>> getItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('items');
    return List.generate(maps.length, (index) {
      return Item.fromMap(maps[index]);
    });
  }

  Future<int> updateItem(Item item) async {
    final db = await database;
    return await db
        .update('items', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }

  Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }
}