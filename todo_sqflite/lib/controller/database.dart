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
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const booleanType = 'BOOLEAN NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';
    await db.execute('''CREATE TABLE ${table}
      (
       ${NoteFields.id} $idType,
       ${NoteFields.isImportant} $booleanType,
       ${NoteFields.number} $intType,
       ${NoteFields.title} $textType,
       ${NoteFields.description} $textType,
       ${NoteFields.time} $textType
      )''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;

    //Manual Code
    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    //Autogenerate Code
    final id = await db.insert(
      table,
      note.toJson(),
    );
    return note.copy(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      table,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      //TODO: didn't understand the question mark and whereargs
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first); //why maps.first
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;

    const orderBy = '${NoteFields.time} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(table, orderBy: orderBy);

    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;

    return db.update(
      table,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      table,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    //getting access to db using private constructor initialization
    final db = await instance.database;

    //closing the fetched db
    db.close();
  }
}
