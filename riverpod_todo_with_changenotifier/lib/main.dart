import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_with_change_notifier/experiments.dart';
import 'package:riverpod_todo_with_change_notifier/providers.dart';
import 'package:riverpod_todo_with_change_notifier/view/splash_page.dart';

void main() => runApp(ProviderScope(child: MainApp()));

class MainApp extends ConsumerStatefulWidget {
  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  final GlobalKey<NavigatorState> _navKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    ref.read(appController).initApp(_navKey);

    final list = List.generate(1000000, (index) => "item$index");

    Future.delayed(Duration(seconds: 10)).then((value) async {
      for (var i = 10; i-- > 0;) {
        final t = DateTime.now().microsecondsSinceEpoch;
        final results = list.where((element) => element.contains('item'));
        print('found: ${results.length}');
        print(DateTime.now().microsecondsSinceEpoch - t);
        await Future.delayed(Duration(milliseconds: 500));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen  to the dark mode property of SettingsState
    bool darkMode = ref.watch(settingsController.select((s) => s.darkMode));
    return MaterialApp(
      navigatorKey: _navKey,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      // Start by showing SplashPage, when the initApp action is complete, it will replace this page
      home: const SplashPage(),
    );
  }
}

void doFoo() {
  final fn = FooNotifier();
  print(fn.state = FooState());
  print(fn.state.count);

  final sn = FooNotifierSN();
  print(sn.state = FooState());
  print(sn.state.count);
}
