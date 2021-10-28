import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_change_notifier/controller/app_controller.dart';
import 'package:riverpod_todo_change_notifier/controller/auth_controller.dart';
import 'package:riverpod_todo_change_notifier/controller/settings_controller.dart';
import 'package:riverpod_todo_change_notifier/controller/todos_controller.dart';
import 'package:riverpod_todo_change_notifier/service/auth_service.dart';
import 'package:riverpod_todo_change_notifier/service/todo_service.dart';

/// App
final appController = Provider((ref) => AppController(ref.read));

/// Auth
final authService = Provider((_) => AuthService());

final authController = ChangeNotifierProvider((ref) => AuthController(ref.read));

/// Todos
// Pass a delegate to the TodoService, that can fetch the current user name.
final todosService = Provider((ref) {
  final auth = ref.read(authController);
  return TodosService(userTokenDelegate: () => auth.user);
});

final todosController = ChangeNotifierProvider((ref) => TodosController(ref.read));

/// Settings
final settingsController = ChangeNotifierProvider((_) => SettingsController());
