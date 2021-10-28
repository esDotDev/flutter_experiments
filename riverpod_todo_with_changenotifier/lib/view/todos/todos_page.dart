import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_change_notifier/controller/todos_controller.dart';
import 'package:riverpod_todo_change_notifier/providers.dart';

import 'todo_item_render.dart';
import 'todos_menu.dart';

/// A dual-column list of all the current todos, and some inputs to add/remove/complete them.
class TodosPage extends ConsumerStatefulWidget {
  const TodosPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TodosPage> createState() => _TodosViewState();
}

class _TodosViewState extends ConsumerState<TodosPage> {
  // Use authController.logout action to handle logout
  void _handleLogoutPressed() => ref.read(authController).logoutAndShowLoginPage();
  // Use settingsController.darkMode field to change settings
  void _handleDarkModeToggled(bool value) => ref.read(settingsController).darkMode = value;

  @override
  Widget build(BuildContext context) {
    //debugPrint("build main");
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    // Watch SettingsController to determine darkMode
    bool darkMode = ref.watch(settingsController).darkMode;
    String? currentUser = ref.watch(authController).user;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            /// Top menu, holds the darkMode and logout buttons
            Row(
              children: [
                const Text('Dark Mode'),
                Switch(onChanged: _handleDarkModeToggled, value: darkMode),
                const Spacer(),
                if (currentUser != null) Text('Hello $currentUser!'),
                const SizedBox(width: 16),
                OutlinedButton(child: const Text('logout'), onPressed: _handleLogoutPressed),
              ],
            ),

            /// Main content area
            Expanded(
              child: Flex(
                direction: isLandscape ? Axis.horizontal : Axis.vertical,
                children: [
                  /// Left side (todosController.active)
                  Expanded(
                      flex: 2,
                      child: Consumer(builder: (_, ref, __) {
                        debugPrint("Build Active");
                        List<TodoItem> items = ref.watch(todosController.select((m) => m.active)).data;
                        //List<TodoItem> items = ref.watch(TodosController.activeItemsProvider);
                        return ListView(children: items.map((i) => TodoItemRenderer(i)).toList());
                      })),

                  /// Divider
                  Container(
                      width: isLandscape ? 1 : double.infinity,
                      height: isLandscape ? double.infinity : 1,
                      color: Colors.grey),

                  /// Right side  (todosController.complete)
                  Expanded(child: Consumer(builder: (_, ref, __) {
                    debugPrint("Build Completed");
                    List<TodoItem> items = ref.watch(todosController.select((m) => m.completed)).data;
                    //List<TodoItem> items = ref.watch(TodosController.completedItemsProvider);
                    return ListView(children: items.map((i) => TodoItemRenderer(i)).toList());
                  })),
                ],
              ),
            ),

            /// Text entry bar that adds a new item
            const TodosMenu(),
          ],
        ),
      ),
    );
  }
}
