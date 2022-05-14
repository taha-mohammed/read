import 'package:read/data/book/book.dart';

abstract class BookEvent{
  const BookEvent();
}

class BookEventAdd extends BookEvent{
  final Book book;
  const BookEventAdd({required this.book});
}

class BookEventUpdate extends BookEvent{
  final Book book;
  const BookEventUpdate({required this.book});
}

class BookEventDelete extends BookEvent{
  final int id;
  const BookEventDelete({required this.id});
}

class BookEventGet extends BookEvent{
  final String? query;
  const BookEventGet(this.query);
}

class BookEventGetAll extends BookEvent{}
