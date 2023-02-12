import 'package:notesapp/db/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Helper {
  Helper._();

  static final Helper helper = Helper._();

  Future<String> getDbPath() async {
    String dbPath = await getDatabasesPath();
    return join(dbPath, dbName);
  }

  Future<Database> createDb() async {
    String path = await getDbPath();
   return await openDatabase(path,version: version,onCreate: (db, version) => _createTable(db),singleInstance: true);
  }

  _createTable(Database db) {
    try {
      String sql = 'create table $tableName($colId integer primary key autoincrement, $colTitle text, $colBody text, $colDate text,$colNoteColor text,$colUpdatedDate text,$colUpdatedState text)';
      db.execute(sql);
    }catch(e){
      print(e.toString());
    }
  }
}
