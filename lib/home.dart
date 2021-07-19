import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lista_compras_sencilla/Provider/item_oper.dart';
import 'package:lista_compras_sencilla/models/item_model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

final BannerAd myBanner = BannerAd(
  adUnitId: 'ca-app-pub-7107965039396948/1588965292',
  size: AdSize.banner,
  request: AdRequest(),
  listener: BannerAdListener(),
);

class _HomeState extends State<Home> {
  List<bool> check = [];
  @override
  void initState() {
    for (var i = 0; i < 500; i++) {
      check.add(false);
    }
    myBanner.load();
    super.initState();
  }

  final ItemOperations _itemOper = new ItemOperations();
  String _nombreItem = '';
  double _cantidad = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: AdWidget(ad: myBanner),
          width: myBanner.size.width.toDouble(),
          height: myBanner.size.height.toDouble(),
        ),
        centerTitle: true,
      ),
      body: Scaffold(
        appBar: AppBar(
          title: Text('Lista'),
          centerTitle: true,
          actions: [IconButton(onPressed: _eliminar, icon: Icon(Icons.delete))],
        ),
        body: body(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff1b5e20),
          onPressed: _registrarItem,
          child: Icon(
            Icons.add,
            size: 35.0,
          ),
        ),
      ),
    );
  }

  _eliminar() {
    _itemOper.deleteItems();
    setState(() {});
  }

  Widget body() {
    return FutureBuilder<List<ItemModel>>(
        future: _itemOper.consultarItems(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ItemModel>> snapshot) {
          List<Widget> children = [];
          //
          if (snapshot.hasData) {
            snapshot.data?.forEach((item) {
              children.add(_item(item.idItem, item.nombreItem, item.cantidad));
            });
          } else if (snapshot.hasError) {
          } else {
            children.add(
              CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            );
          }
          children.add(Container(
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: [
                Text('INSTRUCCIONES:'),
                SizedBox(
                  height: 10.0,
                ),
                Text('Seleccione el boton inferior para anadir un item.'),
                Text('Cuando complete un item seleccione el check.'),
                Text(
                    'De ser necesario elimine el item deslizandolo a un lado.'),
                Text('Seleccione el boton superior para eliminar la lista.'),
              ],
            ),
          ));
          return ListView(
            children: children,
          );
        });
  }

  Widget _item(int? id, String nombre, double cantidad) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.red),
      onDismissed: (direction) {
        _delete(id);
      },
      child: Column(
        children: [
          ListTile(
            title: Row(
              children: [
                Text(cantidad.toString()),
                SizedBox(
                  width: 15.0,
                ),
                !check[id!]
                    ? Text(nombre)
                    : Text(
                        nombre,
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
              ],
            ),
            trailing: Checkbox(
                value: check[id],
                onChanged: (value) {
                  check[id] = value!;
                  setState(() {});
                }),
          ),
          Divider(),
        ],
      ),
    );
  }

  _delete(int? id) {
    _itemOper.deleteItem(id!);
  }

  void _registrarItem() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return SingleChildScrollView(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: Text('Registrar nuevo item'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 8.0),
                  _inputI(),
                  SizedBox(height: 8.0),
                  _inputC(),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  onPressed: () {
                    ItemModel item = new ItemModel(
                        nombreItem: _nombreItem, cantidad: _cantidad);
                    _itemOper.nuevoItem(item);
                    _nombreItem = '';
                    _cantidad = 1;
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: Text('Guardar'),
                ),
              ],
            ),
          );
        });
  }

  //nombre
  Widget _inputI() {
    var inputDecoration = InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        labelText: 'Nombre');

    return Container(
      padding: EdgeInsets.only(bottom: 5.0),
      width: double.infinity,
      child: TextField(
        textAlignVertical: TextAlignVertical.bottom,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        decoration: inputDecoration,
        onChanged: (valor) {
          _nombreItem = valor;
        },
      ),
    );
  }

  Widget _inputC() {
    var inputDecoration = InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        labelText: 'Cantidad');
    return Container(
      padding: EdgeInsets.only(bottom: 5.0),
      child: TextField(
        textAlignVertical: TextAlignVertical.bottom,
        keyboardType: TextInputType.number,
        textCapitalization: TextCapitalization.sentences,
        decoration: inputDecoration,
        onChanged: (valor) {
          _cantidad = double.parse(valor);
        },
      ),
    );
  }
}
