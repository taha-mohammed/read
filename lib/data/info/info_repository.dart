
import 'info.dart';

abstract class InfoRepository {

  Future<void> addInfo(Info info);
  Future<void> updateInfo(Info info);
  Future<void> deleteInfo(int id);
  Future<List<Info>> getAllInfos(String bookTitle);
  Future<List<Info>> getInfosByQuery(String bookTitle, String query);

}