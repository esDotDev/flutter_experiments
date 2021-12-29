import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app/logic/utils/prefs_file.dart';

/// A persistent settings manager with a couple of example settings.
/// Each setting can be bound to individually from the UI.
/// Uses an internal `SaveMap` to persist settings between app loads.
class SettingsManager {
  /// Bind a `_scheduleSave` call to each notifier as a side-effect
  late final darkMode = ValueNotifier<bool>(false)..addListener(_scheduleSave);
  late final useMetric = ValueNotifier<bool>(false)..addListener(_scheduleSave);

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
    useMetric.value = map['useMetric'] ?? false;
  }

  // Todo: debounce instead of scheduleMicrotask
  void _scheduleSave() => scheduleMicrotask(save);
}
