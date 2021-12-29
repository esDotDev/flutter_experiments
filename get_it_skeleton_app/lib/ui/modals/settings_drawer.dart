import 'package:flutter/material.dart';
import 'package:flutter_app/logic/settings_manager.dart';
import 'package:flutter_app/main.dart';
import 'package:gap/gap.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class SettingsDrawer extends StatelessWidget with GetItMixin {
  SettingsDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Bind to various properties on the SettingsManager
    bool useMetric = watchX((SettingsManager m) => m.useMetric);
    bool darkMode = watchX((SettingsManager m) => m.darkMode);
    // Handle ui actions using the settings manager, l
    void handleUseMetricChanged(bool value) async => settings.useMetric.value = value;
    // lock darkMode behind a paywall for the sake of example
    void handleDarkModeChanged(bool value) async {
      bool hasPro = await purchases.showSheetIfRequired(context);
      if (purchases.isProEnabled.value) {
        settings.darkMode.value = value;
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
