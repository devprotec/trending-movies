import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAuthProvider with ChangeNotifier {
  User? _user = FirebaseAuth.instance.currentUser;

  set setAuthUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }

  set setEmail(String? newEmail) {
    FirebaseAuth.instance.currentUser!.updateEmail(newEmail!);
    notifyListeners();
  }

  set setUserName(String newName) {
    FirebaseAuth.instance.currentUser!.updateProfile(displayName: newName);
    notifyListeners();
  }

  set setPhotoURL(String newLink) {
    FirebaseAuth.instance.currentUser!.updateProfile(photoURL: newLink);
    notifyListeners();
  }

  void reset() {
    _user = null;
  }

  User? get authUser => _user;
}
