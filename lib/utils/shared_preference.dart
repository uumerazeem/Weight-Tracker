import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  late SharedPreferences sharedPreferences;

  //================== > addinng access token to pref < ================//
  addEmail(String email) async {
    sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString('email', email);
  }

  //================== > getting access token from pref < ================//
  Future<String?> getEmail() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? email = sharedPreferences.getString('email');
    return email;
  }


  clear() async{
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }
}
