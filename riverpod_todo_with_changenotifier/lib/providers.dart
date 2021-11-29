import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_with_change_notifier/managers/app_controller.dart';
import 'package:riverpod_todo_with_change_notifier/managers/auth_controller.dart';
import 'package:riverpod_todo_with_change_notifier/managers/settings_controller.dart';
import 'package:riverpod_todo_with_change_notifier/managers/todos_controller.dart';
import 'package:riverpod_todo_with_change_notifier/service/auth_service.dart';
import 'package:riverpod_todo_with_change_notifier/service/local_file_service.dart';
import 'package:riverpod_todo_with_change_notifier/service/todo_service.dart';

/// App
final appControllerProvider = Provider((ref) => AppController(ref.read));

/// File Service
final fileServiceProvider = Provider((ref) => LocalFileService());

/// Auth
final authServiceProvider = Provider((_) => AuthService());

final authControllerProvider = ChangeNotifierProvider((ref) => AuthController(ref.read));

/// Todos
// Pass a delegate to the TodoService, that can fetch the current user name.
final todosServiceProvider = Provider((ref) {
  final auth = ref.read(authControllerProvider);
  return TodosService(userTokenDelegate: () => auth.user);
});

final todosControllerProvider = ChangeNotifierProvider((ref) => TodosController(ref.read));

/// Settings
final settingsControllerProvider = ChangeNotifierProvider((ref) => SettingsController(ref.read));
