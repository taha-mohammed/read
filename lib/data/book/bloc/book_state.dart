import 'package:equatable/equatable.dart';
import 'package:read/data/book/book.dart';

abstract class BookState extends Equatable{
  const BookState();

  @override
  List<Object?> get props => [];
}

class BookStateLoading extends BookState{}

class BookStateLoaded extends BookState{
  final List<Book> data;
  const BookStateLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}