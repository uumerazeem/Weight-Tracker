import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:interview_test/models/dataModel.dart';
import 'package:interview_test/utils/shared_preference.dart';

class DataProvider extends ChangeNotifier {
  final databaseReference = FirebaseFirestore.instance;
  PreferenceService prefs = PreferenceService();
  final collection = "weightData";
  bool loading = false;

  List<DataModel> datalist = [];

  void createData(String weight) async {
    String? email = await prefs.getEmail();

    loading = true;
    notifyListeners();
    databaseReference.collection(collection).doc().set(
        {"email": email, "weight": weight, "date": DateTime.now().toString()});
    loading = false;
    notifyListeners();
  }

  Future<List<DataModel>> getdata() async {
    String? email = await prefs.getEmail();
    await databaseReference
        .collection(collection)
        .where("email", isEqualTo: email!)
        .get()
        .then((snapshot) {
      List<dynamic> parsedList = snapshot.docs;
      datalist = List<DataModel>.from(
        parsedList.map((e) {
          return DataModel(date: e["date"], id: e.id, weight: e["weight"]);
        }),
      );
      datalist.sort((a, b) => a.date!.compareTo(b.date!));
      datalist.reversed;
      notifyListeners();
    }).catchError((e) {
      datalist = [];
      Fluttertoast.showToast(msg: "Can't get data");
    });
    return datalist;
  }

  void deleteData(String id) async {
    loading = true;
    notifyListeners();
    await databaseReference
        .collection(collection)
        .doc(id)
        .delete()
        .then((value) {
      Fluttertoast.showToast(msg: "Data Deleted");
    }).catchError((e) {
      Fluttertoast.showToast(msg: "can't deleted at this time ");
    });
    loading = false;
    notifyListeners();
  }

  void editData(String id, String weight) async {
    loading = true;
    notifyListeners();
    await databaseReference
        .collection(collection)
        .doc(id)
        .update({"weight": weight}).then((value) {
      Fluttertoast.showToast(msg: "Data Edited");
    }).catchError((e) {
      Fluttertoast.showToast(msg: "can't edit at this time ");
    });

    loading = false;
    notifyListeners();
  }
}
