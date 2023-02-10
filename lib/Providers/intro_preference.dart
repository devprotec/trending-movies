//@dart=2.9
import 'package:shared_preferences/shared_preferences.dart';

class IntroPreferences {
  static addBoolToSF(bool bool) async {
    SharedPreferences myprefs = await SharedPreferences.getInstance();
    myprefs.setBool('introStatus', bool);
  }

  static Future<bool> getBoolValuesSF() async {
    SharedPreferences myprefs = await SharedPreferences.getInstance();

    //Return bool
    bool boolValue = myprefs.getBool('introStatus');
    print(boolValue.toString());

    return boolValue;
  }
}
