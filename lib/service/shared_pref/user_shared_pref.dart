import 'package:shared_preferences/shared_preferences.dart';

class UserStoredPref {
  Future<bool> storeBearerToken(String bearerToken) async {
    final pref = await SharedPreferences.getInstance();
    final res = pref.setString("token", bearerToken);
    return res;
  }

  Future<String?> getBearerToken() async {
    final pref = await SharedPreferences.getInstance();
    final res = pref.getString("token");
    return res;
  }

  Future<bool> removeBearerToken() async {
    final pref = await SharedPreferences.getInstance();
    final res = pref.remove("token");
    return res;
  }
}
