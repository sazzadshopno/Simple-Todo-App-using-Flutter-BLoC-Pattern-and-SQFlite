import 'dart:io';
import 'package:demo_sqlite/model/todo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      return _database = await initDatabase();
    }
  }

  Future<Database> initDatabase() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String path = join(appDir.path, 'todo.db');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (Database db) {},
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE todo (
            id INTEGER PRIMARY KEY,
            title TEXT,
            description TEXT,
            status INTEGER
          )
        ''');
      },
    );
  }

  Future<int> createToDo(ToDo todo) async {
    final db = await database;
    todo.id = (await db.rawQuery('''
      SELECT MAX(id)+1 AS id FROM todo 
    ''')).first['id'];
    return await db.rawInsert(
      '''
      INSERT INTO todo (id, title, description, status)
      VALUES (?,?,?,?) 
      ''',
      [
        todo.id,
        todo.title,
        todo.description,
        todo.status,
      ],
    );
  }

  Future<List<ToDo>> fetchAllToDo() async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.query('todo');
    return res.isEmpty ? [] : res.map((e) => ToDo.fromMap(e)).toList();
  }

  Future<int> updateToDoStatus(ToDo todo) async {
    final db = await database;
    return await db.rawUpdate(
      '''
      UPDATE todo
      SET status = ?
      WHERE id = ?
      ''',
      [
        todo.status == 1 ? 0 : 1,
        todo.id,
      ],
    );
  }

  Future<int> deleteSingleToDo(ToDo todo) async {
    final db = await database;
    return await db.delete(
      'todo',
      where: 'id = ?',
      whereArgs: [
        todo.id,
      ],
    );
  }

  Future<int> clearTodoTable() async {
    final db = await database;
    return db.delete('todo');
  }
}
