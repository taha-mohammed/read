import 'package:read/data/book/book.dart';
import 'package:read/data/book/book_repository.dart';
import 'package:sqflite/sqflite.dart';

import '../../utils/database_provider.dart';

class BookDatabase extends BookRepository {
  
  static final BookDatabase _bookDatabase = BookDatabase._internal();
  factory BookDatabase() => _bookDatabase;
  BookDatabase._internal();

  @override
  Future<void> addBook(Book book) async {
    Database db = await DatabaseProvider().database;
    db.insert("books", book.toMap());
  }

  @override
  Future<void> updateBook(Book book) async {
    Database db = await DatabaseProvider().database;
    db.update("books", book.toMap(), where: 'id = ?', whereArgs: [book.id]);
  }

  @override
  Future<void> deleteBook(int id) async {
    Database db = await DatabaseProvider().database;
    db.delete("books", where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Book>> getAllBooks() async {
    Database db = await DatabaseProvider().database;
    List<Map<String, dynamic>> res = await db.query('books');
    return res.isEmpty ? [] : res.map((e) => Book.fromMap(e)).toList();
  }

  @override
  Future<List<Book>> getBooksByQuery(String query) async {
    Database db = await DatabaseProvider().database;
    List<Map<String, dynamic>> maps = await db.query("books",
        columns: ["id", "title", "author"],
        where: "LOWER(title) LIKE LOWER(?)",
        whereArgs: ['%' + query + '%']);
    return maps.isEmpty ? [] : maps.map((e) => Book.fromMap(e)).toList();
  }
}
