import 'package:flutter/material.dart';

class CourseBottomNavProvider with ChangeNotifier {
  int _index = 4;
  int get index => _index;

  set index(int i) {
    _index = i;
    notifyListeners();
  }
}
