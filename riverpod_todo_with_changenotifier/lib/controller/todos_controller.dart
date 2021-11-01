import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_with_change_notifier/common/equatable_list.dart';
import 'package:riverpod_todo_with_change_notifier/providers.dart';
import 'package:riverpod_todo_with_change_notifier/service/todo_service.dart';

class TodosController extends ChangeNotifier {
  TodosController(this.read);
  final Reader read;

  TodosService get service => read(todosService);

  /// State
  List<TodoItem> _all = [];
  List<TodoItem> get all => _all;
  set all(List<TodoItem> value) {
    _all = value;
    notifyListeners();
  }

  /// Filters -  Shows two ways to do filtering
  /// 1) Use EquatableList
  EquatableList<TodoItem> get completedItems => EquatableList(_all.where((i) => i.isCompleted).toList());
  EquatableList<TodoItem> get activeItems => EquatableList(_all.where((i) => !i.isCompleted).toList());

  /// 2) Create additional providers
  /// TODO:These are not working properly to prevent rebuilds, not sure why...
  static final activeItemsProvider = Provider((ref) {
    final all = ref.watch(todosController).all;
    return all.where((i) => !i.isCompleted).toList();
  });

  static final completedItemsProvider = Provider((ref) {
    final all = ref.watch(todosController).all;
    return all.where((i) => i.isCompleted).toList();
  });

  /// Actions
  void reset() => all = [];

  Future<void> loadAll() async {
    all = await service.get();
  }

  Future<void> addItem(TodoItem value) async {
    all = List.from(all)..add(value);
    await service.add([value]);
  }

  Future<void> delete(TodoItem value) async {
    all = List.from(all)..removeWhere((item) => item.id == value.id);
    await service.delete([value]);
  }

  Future<void> update(TodoItem value) async {
    for (var i = 0; i < all.length; i++) {
      if (all[i].id == value.id) all[i] = value;
    }
    notifyListeners();
    await service.update([value]);
  }

  Future<void> completeAll() async {
    for (var i = all.length; i-- > 0;) {
      all[i] = all[i].copyWith(isCompleted: true);
    }
    notifyListeners();
    await service.update(all);
  }

  Future<void> deleteAll() async {
    final toDelete = all;
    all = [];
    await service.delete(toDelete);
  }
}

class TodoItem {
  TodoItem(this.id, {required this.text, this.isCompleted = false});
  final String id;
  final String text;
  final bool isCompleted;

  TodoItem copyWith({String? id, String? text, bool? isCompleted}) => TodoItem(
        id ?? this.id,
        text: text ?? this.text,
        isCompleted: isCompleted ?? false,
      );
}
