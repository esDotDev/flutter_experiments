import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends ChangeNotifier {
  final String _fileName = 'settings.dat';

  bool _darkMode = false;
  bool get darkMode => _darkMode;
  set darkMode(bool darkMode) {
    _darkMode = darkMode;
    notifyListeners();
    save();
  }

  /// Actions
  Future<void> save() async {
    // Serialize
    final json = {'darkMode': darkMode};
    // Write
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_fileName, jsonEncode(json));
  }

  Future<void> load() async {
    // Read
    final prefs = await SharedPreferences.getInstance();
    final json = jsonDecode(prefs.getString(_fileName) ?? '{}');
    // Deserialize
    _darkMode = json['darkMode'] ?? _darkMode;
  }
}
