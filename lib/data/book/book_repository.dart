
import 'package:read/data/book/book.dart';

abstract class BookRepository {

  Future<void> addBook(Book book);
  Future<void> updateBook(Book book);
  Future<void> deleteBook(int id);
  Future<List<Book>> getAllBooks();
  Future<List<Book>> getBooksByQuery(String query);

}