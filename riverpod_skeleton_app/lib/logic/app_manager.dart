import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages app wide tasks like first-run initialization,
/// showing dialogs or changing pages.
class AppManager with ChangeNotifier {
  AppManager(this.ref);
  final Ref ref;

  late final isBootstrapComplete = ValueNotifier<bool>(false)..addListener(notifyListeners);

  Future<void> bootstrap() async {
    // Load settings
    await ref.read(settings).load();
    // Initialize services
    await ref.read(maps).init();
    await ref.read(purchases).init();
    await ref.read(bluetooth).init();
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
