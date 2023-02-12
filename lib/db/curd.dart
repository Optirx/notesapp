import 'package:notesapp/db/helper.dart';
import 'package:notesapp/model/Note.dart';
import 'package:sqflite/sqflite.dart';

import 'constants.dart';

class Curd {
  //single instance
  Curd._();

  static final Curd curd = Curd._();

  Future<int> saveNote(Note note) async {
    Database db = await Helper.helper.createDb();
    return db.insert(tableName, note.toMap());
  }

  Future<List<Note>> selectAll() async {
    Database db = await Helper.helper.createDb();
    List<Map<String, dynamic>> results =
        await db.query(tableName, orderBy: '$colDate desc');
    return results.map((e) => Note.fromMap(e)).toList();
  }

  Future<int> deleteNote(int? noteId) async {
    Database db = await Helper.helper.createDb();
    return db.delete(tableName, where: '$colId=?', whereArgs: [noteId]);
    // db.delete(tableName,where: '$colId=$noteId');
  }

  Future<int> updateNote(Note note) async {
    Database db = await Helper.helper.createDb();
   return db.update(tableName, note.toMap(),where: '$colId=?',whereArgs: [note.noteId]);

  }
}
