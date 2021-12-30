import 'package:flutter/material.dart';
import 'package:flutter_app/logic/settings_manager.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class SettingsDrawer extends ConsumerWidget {
  SettingsDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Bind to various properties on the SettingsManager
    bool useMetric = ref.watch(settings.select((m) => m.useMetric.value));
    bool darkMode = ref.watch(settings.select((m) => m.darkMode.value));
    // Handle ui actions using the settings manager, l
    void handleUseMetricChanged(bool value) async => ref.read(settings).useMetric.value = value;
    // lock darkMode behind a paywall for the sake of example
    void handleDarkModeChanged(bool value) async {
      bool hasPro = await ref.read(purchases).showSheetIfRequired(context);
      if (hasPro) {
        ref.read(settings).darkMode.value = value;
      }
    }

    return Material(
      child: Column(children: [
        const Gap(16),
        const Text('Settings', style: TextStyle(fontSize: 24)),
        const Gap(16),
        SwitchListTile(value: useMetric, title: const Text('Use Metric'), onChanged: handleUseMetricChanged),
        SwitchListTile(value: darkMode, title: const Text('Dark Mode'), onChanged: handleDarkModeChanged),
      ]),
    );
  }
}
