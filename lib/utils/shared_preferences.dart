import 'dart:convert';

import 'package:firstflutterapp/entity/user_info_entity.dart';
import 'package:firstflutterapp/generated/json/base/json_convert_content.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  //
  static Future<SharedPreferences> getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  //
  static setInt(String key, int value) {
    getSharedPreferences().then((prefs) {
      prefs.setInt(key, value);
    });
  }

  //
  static setString(String key, String value) {
    getSharedPreferences().then((prefs) {
      prefs.setString(key, value);
    });
  }

  //
  static setBool(String key, bool value) {
    getSharedPreferences().then((prefs) {
      prefs.setBool(key, value);
    });
  }

  //
  static setDouble(String key, double value) {
    getSharedPreferences().then((prefs) {
      prefs.setDouble(key, value);
    });
  }

  //
  static setStringList(String key, List<String> value) {
    getSharedPreferences().then((prefs) {
      prefs.setStringList(key, value);
    });
  }

  /*登录用户数据缓存*/
  static saveUserInfo(UserInfoEntity user) {
    getSharedPreferences().then((prefs) {
      String jsonStr = jsonEncode(user);
      prefs.setString('user_info', jsonStr);
    });
  }

  /*获取登录用户数据缓存*/
  static Future<UserInfoEntity> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserInfoEntity userInfoEntity = JsonConvert.fromJsonAsT<UserInfoEntity>(
        jsonDecode(prefs.getString('user_info')));
    return userInfoEntity;
  }
}
