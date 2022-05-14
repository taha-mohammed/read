
import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:read/data/book/bloc/book_bloc.dart';
import 'package:read/data/book/bloc/book_event.dart';
import 'package:read/data/book/bloc/book_state.dart';
import 'package:read/data/book/book.dart';
import 'package:read/data/book/mock_book_repository.dart';

void main() {
  late BookBloc bookBloc;
  const book = Book(id: 6,title: "TITLE_TEST", author: "AUTHOR_TEST");
  const updatedBook = Book(id: 6,title: "UPDATED_TITLE_TEST", author: "UPDATED_AUTHOR_TEST");

  group("test book bloc", () {
    setUp(() {
      EquatableConfig.stringify;
      bookBloc = BookBloc(MockBookRepo());
    });

    blocTest(
        "Test Create new Book",
        build: () => bookBloc,
        act: (BookBloc bloc) => bloc..add(const BookEventAdd(book: book))..add(BookEventGetAll()),
        expect: () => [const BookStateLoaded(data: [book])]
    );

    blocTest(
        "Test search for Books",
        build: () => bookBloc,
        act: (BookBloc bloc) => bloc.add(const BookEventGet("tl")),
        expect: () => [const BookStateLoaded(data: [book])]
    );

    blocTest(
        "Test update Book",
        build: () => bookBloc,
        act: (BookBloc bloc) => bloc..add(const BookEventUpdate(book: updatedBook))..add(BookEventGetAll()),
        expect: () => [const BookStateLoaded(data: [updatedBook])]
    );

    blocTest(
        "Test delete Book",
        build: () => bookBloc,
        act: (BookBloc bloc) => bloc..add(const BookEventDelete(id: 6))..add(BookEventGetAll()),
        expect: () => [const BookStateLoaded(data: [])]
    );

    tearDown(() {
      bookBloc.close();
    });
  });
}