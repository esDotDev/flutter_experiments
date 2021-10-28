import 'package:flutter/foundation.dart';
import 'package:riverpod_todo_change_notifier/controller/todos_controller.dart';

/// Todo Service, performs remote CRUD operations for todos
class TodosService {
  TodosService({required this.userTokenDelegate});
  String? get currentUser => userTokenDelegate();
  final String? Function() userTokenDelegate;

  String? get userToken => userTokenDelegate.call();

  Future<List<TodoItem>> get() async {
    // TODO: Load items from db
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      TodoItem('todo-0', text: 'hi'),
      TodoItem('todo-1', text: 'hello'),
      TodoItem('todo-2', text: 'bonjour'),
    ];
  }

  Future<bool> add(List<TodoItem> items) async {
    for (var i in items) {
      debugPrint("[TodosService] $currentUser/add/${i.id}");
    }
    return true;
  }

  Future<bool> update(List<TodoItem> items) async {
    for (var i in items) {
      debugPrint("[TodosService] $currentUser/update/${i.id}");
    }
    return true;
  }

  Future<bool> delete(List<TodoItem> items) async {
    for (var i in items) {
      debugPrint("[TodosService] $currentUser/delete/${i.id}");
    }
    return true;
  }
}
