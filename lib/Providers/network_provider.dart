import 'package:flutter/material.dart';

class NetworkProvider with ChangeNotifier {
  bool _hasInternet = false;

  NetworkProvider(bool i) {
    setInternet = i;
  }

  get connectionStatus => _hasInternet;

  set setInternet(bool i) {
    _hasInternet = i;
    notifyListeners();
  }
}
