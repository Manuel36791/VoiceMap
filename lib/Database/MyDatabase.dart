import 'package:flutter_map/Database/PlaceList.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyDatabase{

  Future<Database> database() async{
    return openDatabase(
      join(await getDatabasesPath(), 'places_db.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE places(id INTEGER PRIMARY KEY, name TEXT, Lat REAL, Lng REAL)",
        );
      },
      version: 1,
    );
  }

  Future<void> insert(PlaceList placeList) async {
    final Database db = await database();
    await db.insert(
      placeList.table(),
      placeList.tomap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(PlaceList placeList) async {
    final Database db = await database();
    await db.update(
      placeList.table(),
      placeList.tomap(),
      where: "name = ?",
      whereArgs: [placeList.getname()],
    );
  }

  Future<void> delete(String name) async {
    final Database db = await database();
    await db.delete(
      'places',
      where: "name = ?",
      whereArgs: [name],
    );
  }

  Future<List> getAll() async {
    final Database db = await database();
    return db.query('places');
  }

  Future<List> getRow(String name) async {
    final Database db = await database();
    return db.query('places',where: 'name = "$name"');
  }
}