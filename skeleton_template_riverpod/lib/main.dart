import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

final settings = ChangeNotifierProvider((ref) => SettingsController(ref));
final settingsService = Provider((ref) => SettingsService());
