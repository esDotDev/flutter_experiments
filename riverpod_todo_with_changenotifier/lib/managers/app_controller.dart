import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_with_change_notifier/managers/auth_controller.dart';
import 'package:riverpod_todo_with_change_notifier/managers/settings_controller.dart';
import 'package:riverpod_todo_with_change_notifier/providers.dart';
import 'package:riverpod_todo_with_change_notifier/view/login_page.dart';
import 'package:riverpod_todo_with_change_notifier/view/todos/todos_page.dart';

/// AppController performs top-level actions that are global in nature and do not fit neatly into any of the lower level controllers.
class AppController {
  AppController(this.read);
  Reader read;

  SettingsController get settings => read(settingsControllerProvider);
  AuthController get auth => read(authControllerProvider);

  /// State
  GlobalKey<NavigatorState>? navKey;
  NavigatorState? get nav => navKey?.currentState;

  /// Actions
  Future<void> initApp(GlobalKey<NavigatorState> navKey) async {
    // Save navKey so we can manipulate the navigation stack and show dialogs
    this.navKey = navKey;
    await settings.load();
    await auth.load();
    // Simulate some initialization tasks
    await Future.delayed(const Duration(seconds: 1));
    // Show an initial page, replacing the SplashView that is shown initially
    if (auth.user != null) {
      pushPageRoute(const TodosPage());
    } else {
      pushPageRoute(const LoginPage());
    }
  }

  // Provide a simplified navigator.push api for your various views and controllers
  Future<void> pushPageRoute(Widget child) async {
    nav?.push(MaterialPageRoute(builder: (_) => child));
  }
}
