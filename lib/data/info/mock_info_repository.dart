
import 'package:read/data/info/info.dart';
import 'package:read/data/info/info_repository.dart';

class MockInfoRepo extends InfoRepository {

  static final MockInfoRepo _infoDatabase = MockInfoRepo._internal();
  factory MockInfoRepo() => _infoDatabase;
  MockInfoRepo._internal();
  
  List<Info> infos = [];

  @override
  Future<void> addInfo(Info info) async {
    infos.add(info);
    Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<void> deleteInfo(int id) async {
    infos.removeWhere((info) => info.id == id);
    Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<List<Info>> getAllInfos(String bookTitle) async {
    Future.delayed(const Duration(seconds: 2));
    return infos.takeWhile((info) => info.bookTitle == bookTitle).toList();
  }

  @override
  Future<List<Info>> getInfosByQuery(String bookTitle, String query) async {
    Future.delayed(const Duration(seconds: 2));
    return infos.takeWhile((info) => info.bookTitle == bookTitle &&
        info.infoText.toLowerCase().contains(query.toLowerCase())).toList();
  }

  @override
  Future<void> updateInfo(Info info) async {
    int index = infos.indexWhere((element) => element.id == info.id);
    infos.replaceRange(index, index + 1, [info]);
    Future.delayed(const Duration(seconds: 2));
  }
  
}