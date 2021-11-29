import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_with_change_notifier/managers/app_controller.dart';
import 'package:riverpod_todo_with_change_notifier/managers/todos_controller.dart';
import 'package:riverpod_todo_with_change_notifier/providers.dart';
import 'package:riverpod_todo_with_change_notifier/service/auth_service.dart';
import 'package:riverpod_todo_with_change_notifier/service/local_file_service.dart';
import 'package:riverpod_todo_with_change_notifier/view/login_page.dart';
import 'package:riverpod_todo_with_change_notifier/view/todos/todos_page.dart';

class AuthController extends ChangeNotifier {
  static const _fileName = 'auth.dat';
  AuthController(this.read);
  Reader read;

  AppController get app => read(appControllerProvider);
  AuthService get service => read(authServiceProvider);
  TodosController get todos => read(todosControllerProvider);
  LocalFileService get files => read(fileServiceProvider);

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
  Future<bool> login({required String user, required String password}) async {
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

  Future<void> logout() async {
    _user = null;
    todos.reset();
    //settings.reset();
    service.logout();
    notifyListeners();
    app.pushPageRoute(const LoginPage());
  }

  /// Actions
  Future<void> save() async {
    await files.saveJson(_fileName, {'_user': user});
  }

  Future<void> load() async {
    final json = await files.loadJson(_fileName);
    _user = json['_user'] as String?;
  }
}
