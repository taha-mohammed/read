import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static Database? _bookDatabase;

  Future<Database> get database async {
    return _bookDatabase ??= await initializeDB();
  }

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return await openDatabase(
      join(path, 'read.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE books(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, author TEXT NOT NULL)",
        );
        await database.execute(
          "CREATE TABLE infos(id INTEGER PRIMARY KEY AUTOINCREMENT, book_title TEXT NOT NULL, info_text TEXT NOT NULL)",
        );
      },
      version: 1,
    );
  }
}
