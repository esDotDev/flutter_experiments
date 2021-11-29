import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_with_change_notifier/managers/todos_controller.dart';
import 'package:riverpod_todo_with_change_notifier/providers.dart';

/// Renders a single [TodoItem], calls actions on the [TodoController] to respond to user input
class TodoItemRenderer extends ConsumerWidget {
  const TodoItemRenderer(this.item, {Key? key}) : super(key: key);
  final TodoItem item;

  TodosController todos(WidgetRef ref) => ref.read(todosControllerProvider);

  /// Event handlers
  void _handleDeletePressed(WidgetRef ref) => todos(ref).delete(item);

  void _handleItemPressed(WidgetRef ref) {
    todos(ref).update(item.copyWith(isCompleted: !item.isCompleted));
  }

  void _handleTodoChanged(String value, WidgetRef ref) {
    todos(ref).update(item.copyWith(text: value));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextStyle completedStyle =
        const TextStyle(color: Colors.grey, fontWeight: FontWeight.w300, decoration: TextDecoration.lineThrough);
    TextStyle activeStyle = const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 24);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () => _handleItemPressed(ref),
          child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  /// Leading icon, swap icons depending on completed state
                  (item.isCompleted)
                      ? const Icon(Icons.check, size: 30, color: Colors.grey)
                      : const Icon(Icons.crop_square, size: 60),

                  /// TextField, enabled=false when item is complete
                  Expanded(
                    child: TextFormField(
                      enabled: !item.isCompleted,
                      key: ValueKey(item.id),
                      style: item.isCompleted ? completedStyle : activeStyle,
                      decoration: const InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none)),
                      initialValue: item.text,
                      onChanged: (value) => _handleTodoChanged(value, ref),
                    ),
                  ),

                  /// Delete Button
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _handleDeletePressed(ref),
                  ),
                ],
              )),
        ),
        Container(height: 1, width: double.infinity, color: Colors.grey),
      ],
    );
  }
}
