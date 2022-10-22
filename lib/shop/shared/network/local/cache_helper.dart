import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  static Future init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // save boolean value
  static Future<bool> putBoolean(
      {required String key, required bool value}) async {
    return await sharedPreferences.setBool(key, value);
  }

  // get boolean value
  static bool? getBoolean({
    required String key,
  }) {
    return sharedPreferences.getBool(key);
  }

  static Future putString({required String key, required String value}) async {
    return await sharedPreferences.setString(key, value);
  }

  // get boolean value
  static String? getString({
    required String key,
  }) {
    return sharedPreferences.getString(key);
  }

  static Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }

/*
  // save all value
  static dynamic saveData({
    required String key,
    required dynamic value
})async
  {
    if(value is String) {
      return await sharedPreferences.setString(key, value);
    }
    if(value is int) {
      return await sharedPreferences.setInt(key, value);
    }
    if(value is bool) {
      return await sharedPreferences.setBool(key, value);
    }

    return await sharedPreferences.setDouble(key, value);
  }


  // get all value
  static dynamic getData({
    required String key,
  })
  {
    return sharedPreferences.get(key);
  }
*/

}
