import 'package:flutter/foundation.dart';
import 'package:riverpod_todo_with_change_notifier/controller/todos_controller.dart';

/// Performs remote CRUD operations for TodoItems
class TodosService {
  TodosService({required this.userTokenDelegate});

  final String? Function() userTokenDelegate;
  String? get userToken => userTokenDelegate();

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
      debugPrint("[TodosService] $userToken/add/${i.id}");
    }
    return true;
  }

  Future<bool> update(List<TodoItem> items) async {
    for (var i in items) {
      debugPrint("[TodosService] $userToken/update/${i.id}");
    }
    return true;
  }

  Future<bool> delete(List<TodoItem> items) async {
    for (var i in items) {
      debugPrint("[TodosService] $userToken/delete/${i.id}");
    }
    return true;
  }
}
