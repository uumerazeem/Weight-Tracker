import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool? loading;
  bool screenState = false;

  setScreenState(bool value) {
    screenState = value;
    notifyListeners();
  }

  setLoading(bool value) {
    loading = value;
    notifyListeners();
  }
}
