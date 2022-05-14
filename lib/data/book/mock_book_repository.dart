
import 'package:read/data/book/book.dart';
import 'package:read/data/book/book_repository.dart';


class MockBookRepo extends BookRepository{

  static final MockBookRepo _bookDatabase = MockBookRepo._internal();
  factory MockBookRepo() => _bookDatabase;
  MockBookRepo._internal();
  
  List<Book> books = [];
  
  @override
  Future<void> addBook(Book book) async {
    books.add(book);
    Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<void> deleteBook(int id) async {
    books.removeWhere((book) => book.id == id);
    Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<List<Book>> getAllBooks() async {
    Future.delayed(const Duration(seconds: 2));
    return books;
  }

  @override
  Future<List<Book>> getBooksByQuery(String query) async {
    Future.delayed(const Duration(seconds: 2));
    return books.takeWhile((book) => book.title.toLowerCase().contains(query.toLowerCase())).toList();
  }

  @override
  Future<void> updateBook(Book book) async {
    int index = books.indexWhere((element) => element.id == book.id);
    books.replaceRange(index, index + 1, [book]);
    Future.delayed(const Duration(seconds: 2));
  }

}