import 'package:read/utils/database_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'info.dart';
import 'info_repository.dart';

class InfoDatabase extends InfoRepository {

  static final InfoDatabase _infoDatabase = InfoDatabase._internal();
  factory InfoDatabase() => _infoDatabase;
  InfoDatabase._internal();

  @override
  Future<void> addInfo(Info info) async {
    Database db = await DatabaseProvider().database;
    db.insert("infos", info.toMap());
  }

  @override
  Future<void> updateInfo(Info info) async {
    Database db = await DatabaseProvider().database;
    db.update("infos", info.toMap(), where: 'id = ?', whereArgs: [info.id]);
  }

  @override
  Future<void> deleteInfo(int id) async {
    Database db = await DatabaseProvider().database;
    db.delete("infos", where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Info>> getAllInfos(String bookTitle) async {
    Database db = await DatabaseProvider().database;
    List<Map<String, dynamic>> res = await db
        .query('infos', where: 'book_title = ?', whereArgs: [bookTitle]);
    return res.isEmpty ? [] : res.map((e) => Info.fromMap(e)).toList();
  }

  @override
  Future<List<Info>> getInfosByQuery(String bookTitle, String query) async {
    Database db = await DatabaseProvider().database;
    List<Map<String, dynamic>> res = await db.query('infos',
        where: 'book_title = ? AND LOWER(info_text) LIKE LOWER(?)',
        whereArgs: [bookTitle, '%' + query + '%']);
    return res.isEmpty ? [] : res.map((e) => Info.fromMap(e)).toList();
  }
}
