import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalFileService {
  Future<SharedPreferences> get prefs async => await SharedPreferences.getInstance();

  /// Actions
  Future<void> saveJson<T>(String fileName, T data) async {
    final jsonString = jsonEncode(data);
    (await prefs).setString(fileName, jsonString);
  }

  Future<Map<String, Object>> loadJson(String fileName) async {
    final json = jsonDecode((await prefs).getString(fileName) ?? '{}');
    return json;
  }
}
