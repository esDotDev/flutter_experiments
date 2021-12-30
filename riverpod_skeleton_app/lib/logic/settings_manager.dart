import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app/logic/utils/prefs_file.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A persistent settings manager with a couple of example settings.
/// Each setting can be bound to individually from the UI.
/// Uses an internal `SaveMap` to persist settings between app loads.
class SettingsManager with ChangeNotifier {
  SettingsManager(this.ref);
  final Ref ref;

  /// Bind a `handleValueChanged` call to each notifier so we can save the settings to disk,
  /// and notify listeners.
  late final darkMode = ValueNotifier<bool>(false)..addListener(handleValueChanged);
  late final useMetric = ValueNotifier<bool>(false)..addListener(handleValueChanged);

  final _saveFile = SavedMap('settings');

  Future<void> save() async {
    await _saveFile.save({
      'darkMode': darkMode.value,
      'useMetric': useMetric.value,
    });
  }

  Future<void> load() async {
    final map = await _saveFile.load();
    darkMode.value = map['darkMode'] ?? false;
    darkMode.value = map['useMetric'] ?? false;
  }

  void handleValueChanged() {
    // Todo: debounce instead of scheduleMicrotask
    scheduleMicrotask(save);
    notifyListeners();
  }
}
