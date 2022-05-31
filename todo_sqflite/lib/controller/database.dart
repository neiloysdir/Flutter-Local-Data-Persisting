import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_sqflite/models/notes.dart';

class NotesDatabase {
  //Creating a global instance that calls to the private constructor
  //TODO: Learn why we did this
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  //Making a private constructor
  //TODO: Learn what this is
  NotesDatabase._init();

  //return a database
  Future<Database> get database async {
    //if exists return existing
    if (_database != null) return _database!;

    //else initialize db
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    // uses sqflite path
    // final dbPath = await getDatabasesPath();

    //uses path provider path
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String dbPath = appDocDir.path;

    //with proper filepath
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  //Create Database if doesnt exist
  Future _createDB(Database db, int version) async {}

  Future close() async {
    //getting access to db using private constructor initialization
    final db = await instance.database;

    //closing the fetched db
    db.close();
  }
}
