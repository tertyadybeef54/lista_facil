import 'dart:convert';

ItemModel itemModelFromJson(String str) => ItemModel.fromJson(json.decode(str));

String itemModelToJson(ItemModel data) => json.encode(data.toJson());

class ItemModel {
    ItemModel({
        this.idItem,
        this.nombreItem = '',
        this.cantidad = 1,
        this.estado = 0
    });

    int ?idItem;
    String nombreItem;
    double cantidad;
    int estado;

    factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        idItem: json["idItem"],
        nombreItem: json["nombreItem"],
        cantidad: json["cantidad"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "idItem": idItem,
        "nombreItem": nombreItem,
        "cantidad": cantidad,
        "estado": estado,
    };
}