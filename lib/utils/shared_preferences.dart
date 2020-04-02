import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  //
  static setInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  //
  static setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  //
  static setBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  //
  static setDouble(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  //
  static setStringList(String key, List<String> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }

  // 获取用户名
  static getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString("username");
  }

  static setUserName(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("username", value);
  }
}
