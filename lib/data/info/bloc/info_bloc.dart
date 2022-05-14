
import 'package:bloc/bloc.dart';
import 'package:read/data/info/bloc/info_event.dart';
import 'package:read/data/info/bloc/info_state.dart';
import 'package:read/data/info/info_repository.dart';

class InfoBloc extends Bloc<InfoEvent, InfoState> {

  InfoBloc(InfoRepository repository) : super(InfoStateLoading()){
    on<InfoEventAdd>((event, emit) async {
      await repository.addInfo(event.info);
    });
    on<InfoEventUpdate>((event, emit) async {
      await repository.updateInfo(event.info);
    });
    on<InfoEventDelete>((event, emit) async {
      await repository.deleteInfo(event.id);
    });
    on<InfoEventGetAll>((event, emit) async {
      emit(InfoStateLoaded(data: await repository.getAllInfos(event.bookTitle)));
    });
    on<InfoEventGet>((event, emit) async {
      if (event.query != null && event.query!.trim().isNotEmpty){
        emit(InfoStateLoaded(data: await repository.getInfosByQuery(event.bookTitle, event.query!)));
      }else{
        add(InfoEventGetAll(bookTitle: event.bookTitle));
      }
    });
  }

}