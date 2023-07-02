import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  static Future<void> init() async {
    await SharedPreferences.getInstance().then((value) {
      sharedPreferences = value;
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  static dynamic getData({required String key}) {
    dynamic data = sharedPreferences.get(key);

    if (data is String) {
      return data.toString();
    } else if (data is int) {
      return data.toInt();
    } else if (data is double) {
      return data.toDouble();
    } else if (data is bool) {
      return data;
    }
    // }
  }

  /// islogin as driver ----> true / false
  static saveData({required String key, required dynamic val}) {
    if (val is bool) {
      return sharedPreferences.setBool(key, val);
    } else if (val is String) {
      return sharedPreferences.setString(key, val);
    } else if (val is int) {
      return sharedPreferences.setInt(key, val);
    } else {
      return sharedPreferences.setDouble(key, val);
    }
  }

  static dynamic getDataList({required String key}) {
    dynamic data = sharedPreferences.getStringList(key) ?? [];
    if (data is List) return data.toList();
    return data;
  }

  static saveDataList({required String key, required List<String> valList}) {
    return sharedPreferences.setStringList(key, valList);
  }
}
