import 'package:flutter/material.dart';


class EditProfileProvider with ChangeNotifier{
    bool _edit = false;

    bool get edit => this._edit;

    set edit(bool e){
      this._edit = e;
      notifyListeners();
    }
}