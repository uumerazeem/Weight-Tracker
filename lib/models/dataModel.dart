// To parse this JSON data, do
//
//     final dataModel = dataModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

DataModel dataModelFromJson(String str) => DataModel.fromJson(json.decode(str));

String dataModelToJson(DataModel data) => json.encode(data.toJson());

class DataModel {
    DataModel({
        this.weight,
        this.date,
        this.id,
    });

    String? weight;
    String? date;
    String? id;
  //   factory DataModel.fromDocument(DocumentSnapshot doc) {
  //   final data = doc.data()! as Map<String, dynamic>;
  //   return DataModel.fromJson(data).copyWith(id: doc.id);
  // }
    factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        weight: json["weight"],
        date: json["date"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "weight": weight,
        "date": date,
        "id": id,
    };
}
