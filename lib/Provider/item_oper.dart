import 'package:lista_compras_sencilla/db_provider/db_provider.dart';
import 'package:lista_compras_sencilla/models/item_model.dart';

class ItemOperations {
  ItemOperations ?itemOperations;

  final dbProvider = DBProvider.db;

//C - crear
  Future<int> nuevoItem(ItemModel nuevoItem) async {
    final db =await dbProvider.initDB();
    final res = await db.insert('Items', nuevoItem.toJson());
    // Es el ID del último registro insertado;
    print(res);
    return res;
  }

//R - leer
  Future<List<ItemModel>> consultarItems() async {
    final db =await dbProvider.initDB();
    final res = await db.query('Items');

    return res.isNotEmpty
        ? res.map((s) => ItemModel.fromJson(s)).toList()
        : [];
  }

//U - actualizar
  Future<int> updateItem(ItemModel nuevoItem) async {
    final db =await dbProvider.initDB();
    final res = await db.update('Items', nuevoItem.toJson(),
        where: 'idItem = ?', whereArgs: [nuevoItem.idItem]);
    return res;
  }

//D - borrar un registro
  Future<int> deleteItem(int id) async {
    final db =await dbProvider.initDB();
    final res =
        await db.delete('Items', where: 'idItem = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteItems() async {
    final db =await dbProvider.initDB();
    final res =
        await db.delete('Items', where: 'idItem > ?', whereArgs: [0]);
    return res;
  }
}
