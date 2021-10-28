import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_change_notifier/controller/todos_controller.dart';
import 'package:riverpod_todo_change_notifier/providers.dart';

/// Allows user to add new [TodoItem] and bulk modify items.
class TodosMenu extends ConsumerStatefulWidget {
  const TodosMenu({Key? key}) : super(key: key);
  @override
  ConsumerState<TodosMenu> createState() => _TodosMenuState();
}

class _TodosMenuState extends ConsumerState<TodosMenu> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocus = FocusNode();

  TodosController get todos => ref.read(todosController);

  void _handleAddItemPressed() {
    if (_textController.value.text.isEmpty) return;
    // Call the addItem action to add a new item.
    todos.addItem(TodoItem('todo-${Random().nextInt(9999999)}', text: _textController.value.text));
    // Perform some local view level cleanup
    _textController.clear();
    _textFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          /// Bulk Edit Buttons
          Row(children: [
            _MenuBtn("Complete All", todos.completeAll),
            _MenuBtn("Clear All", todos.deleteAll),
          ]),

          /// Text Field
          Row(
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  style: const TextStyle(fontSize: 26),
                  focusNode: _textFocus,
                  controller: _textController,
                  onFieldSubmitted: (_) => _handleAddItemPressed(),
                  decoration: const InputDecoration(hintText: 'Add a new item'),
                ),
              ),
              TextButton(
                  child: const SizedBox(height: 80, width: 100, child: Icon(Icons.subdirectory_arrow_left)),
                  onPressed: _handleAddItemPressed),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textFocus.dispose();
    _textController.dispose();
    super.dispose();
  }
}

class _MenuBtn extends StatelessWidget {
  final String lbl;
  final VoidCallback onPressed;

  const _MenuBtn(this.lbl, this.onPressed, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: CupertinoButton(
            borderRadius: BorderRadius.zero,
            color: Colors.grey.shade600,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(lbl, maxLines: 1),
            onPressed: onPressed));
  }
}
