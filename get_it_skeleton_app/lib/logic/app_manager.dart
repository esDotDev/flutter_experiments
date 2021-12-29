import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';

/// Manages app wide tasks like first-run initialization,
/// showing dialogs or changing pages.
class AppManager {
  final isBootstrapComplete = ValueNotifier<bool>(false);

  Future<void> bootstrap() async {
    // Load settings
    await settings.load();
    // Initialize services
    await maps.init();
    await purchases.init();
    await bluetooth.init();
    // Mark bootstrap as complete, so the ui can update
    isBootstrapComplete.value = true;
  }

  Future<T?> navigateTo<T>(BuildContext context, String name) async => await Navigator.of(context).pushNamed<T>(name);

  Future<T?> openDialog<T>(BuildContext context, Widget child, {bool isDismissible = true}) async =>
      await showDialog<T>(
        context: context,
        barrierDismissible: isDismissible,
        builder: (_) => child,
      );

  Future<T?> openSheet<T>(BuildContext context, Widget child, {bool isDismissible = true}) async =>
      await showModalBottomSheet<T>(
        context: context,
        isDismissible: isDismissible,
        builder: (_) => child,
      );
}
