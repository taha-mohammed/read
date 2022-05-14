
import 'package:bloc/bloc.dart';
import 'package:read/data/book/bloc/book_event.dart';
import 'package:read/data/book/bloc/book_state.dart';
import 'package:read/data/book/book_repository.dart';

class BookBloc extends Bloc<BookEvent, BookState> {

  BookBloc(BookRepository repository) : super(BookStateLoading()){
    on<BookEventAdd>((event, emit) async {
      await repository.addBook(event.book);
    });
    on<BookEventUpdate>((event, emit) async {
      await repository.updateBook(event.book);
    });
    on<BookEventDelete>((event, emit) async {
      await repository.deleteBook(event.id);
    });
    on<BookEventGetAll>((event, emit) async {
      emit(BookStateLoaded(data: await repository.getAllBooks()));
    });
    on<BookEventGet>((event, emit) async {
      if (event.query != null && event.query!.trim().isNotEmpty){
        emit(BookStateLoaded(data: await repository.getBooksByQuery(event.query!)));
      }else{
        add(BookEventGetAll());
      }
    });
  }

}