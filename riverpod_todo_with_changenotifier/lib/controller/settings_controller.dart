import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController with ChangeNotifier {
  final String _fileName = 'settings.dat';

  /// State
  bool _darkMode = false;
  bool get darkMode => _darkMode;
  set darkMode(bool darkMode) {
    _darkMode = darkMode;
    notifyListeners();
    save();
  }

  /// Actions
  Future<void> save() async {
    _setString(jsonEncode({'darkMode': darkMode}));
  }

  Future<void> load() async {
    final json = jsonDecode((await SharedPreferences.getInstance()).getString(_fileName) ?? '{}');
    _darkMode = json['darkMode'] ?? false;
  }

  void reset() async {
    await _setString(jsonEncode({}));
    await load();
    notifyListeners();
  }

  Future<void> _setString(String value) async => (await SharedPreferences.getInstance()).setString(_fileName, value);
}
