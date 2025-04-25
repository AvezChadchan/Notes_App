import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();
  static DBHelper getInstance = DBHelper._();

  static final String TABLE_NAME = "notes";
  static final String COLUMN_ID = "id";
  static final String COLUMN_TITLE = "title";
  static final String COLUMN_CONTENT = "content";

  Database? myDB;

  Future<Database> getDB() async {
    myDB ??= await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String path = join(appDir.path, "notesDB.db");
    return await openDatabase(
      path,
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE $TABLE_NAME($COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,$COLUMN_TITLE TEXT,$COLUMN_CONTENT TEXT)",
        );
      },
    );
  }

  Future<bool> addNote({
    required String mtitle,
    required String mcontent,
  }) async {
    var db = await getDB();
    int rowsEffected = await db.insert(TABLE_NAME, {
      COLUMN_TITLE: mtitle,
      COLUMN_CONTENT: mcontent,
    });

    print("Inserted rows: $rowsEffected");
    return rowsEffected > 0;
  }


  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDB();
    List<Map<String, dynamic>> notes = await db.query(TABLE_NAME);
    return notes;
  }
}
