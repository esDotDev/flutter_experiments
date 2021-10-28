import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_change_notifier/controller/app_controller.dart';
import 'package:riverpod_todo_change_notifier/controller/settings_controller.dart';
import 'package:riverpod_todo_change_notifier/controller/todos_controller.dart';
import 'package:riverpod_todo_change_notifier/providers.dart';
import 'package:riverpod_todo_change_notifier/service/auth_service.dart';
import 'package:riverpod_todo_change_notifier/view/login_page.dart';
import 'package:riverpod_todo_change_notifier/view/todos/todos_page.dart';

class AuthController extends ChangeNotifier {
  AuthController(this.read);
  Reader read;

  AuthService get service => read(authService);
  TodosController get todos => read(todosController);
  SettingsController get settings => read(settingsController);
  AppController get app => read(appController);

  /// State
  String? _user;
  String? get user => _user;
  set user(String? user) {
    _user = user;
    notifyListeners();
  }

  /// Filters
  bool get isLoggedIn => _user != null;

  /// Actions
  Future<bool> loginAndShowInitialPage({required String user, required String password}) async {
    _user = await service.login(user: user, password: password);
    _user = await service.login(user: user, password: password);
    if (isLoggedIn) {
      // Prefetch data before we show the initial view
      await todos.loadAll();
      // Show first view
      app.pushPageRoute(const TodosPage());
    }
    notifyListeners();
    return isLoggedIn;
  }

  Future<void> logoutAndShowLoginPage() async {
    _user = null;
    todos.reset();
    settings.reset();
    service.logout();
    app.pushPageRoute(const LoginPage());
    notifyListeners();
  }
}
