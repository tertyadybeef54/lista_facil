import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {

  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> initDB() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'items.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE Items(
          idItem INTEGER PRIMARY KEY,
          nombreItem STRING NOT NULL,
          cantidad REAL NOT NULL
          )
          ''');
    });
  }
}