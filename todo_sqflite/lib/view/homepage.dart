import 'package:flutter/material.dart';
import 'package:todo_sqflite/controller/database.dart';
import 'package:todo_sqflite/models/notes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotesDatabase _nb = NotesDatabase.instance;
  List<Note>? notes;

  @override
  void initState() {
    super.initState();
    print("started");
    createANote();
    readNote();
    if (notes != null) {
      print(notes);
    }
  }

  createANote() async {
    await _nb.create(
      Note(
        isImportant: true,
        number: 31,
        title: "test",
        description: "test",
        createdTime: DateTime.now(),
      ),
    );
  }

  readNote() async {
    List<Note> someData = await _nb.readAllNotes();
    setState(() {
      notes = someData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            readNote();
            if (notes != null) {
              print(notes![0].title);
              print(notes!.length);
            }
          },
          child: Text(
            "Create",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
