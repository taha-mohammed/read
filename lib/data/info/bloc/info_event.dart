import 'package:read/data/info/info.dart';

abstract class InfoEvent{
  const InfoEvent();
}

class InfoEventAdd extends InfoEvent{
  final Info info;
  const InfoEventAdd({required this.info});
}

class InfoEventUpdate extends InfoEvent{
  final Info info;
  const InfoEventUpdate({required this.info});
}

class InfoEventDelete extends InfoEvent{
  final int id;
  const InfoEventDelete({required this.id});
}

class InfoEventGet extends InfoEvent{
  final String? query;
  final String bookTitle;
  const InfoEventGet(this.query,{required this.bookTitle});
}

class InfoEventGetAll extends InfoEvent{
  final String bookTitle;
  const InfoEventGetAll({required this.bookTitle});
}
