import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/logic/app_manager.dart';
import 'package:flutter_app/logic/settings_manager.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/ui/modals/settings_drawer.dart';
import 'package:flutter_app/ui/pages/list_devices_page.dart';
import 'package:flutter_app/ui/pages/maps_page.dart';
import 'package:flutter_app/ui/pages/splash_page.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class MainApp extends StatefulWidget with GetItStatefulWidgetMixin {
  MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with GetItStateMixin {
  @override
  void initState() {
    /// Bootstrap the app.
    /// The ui is bound to AppManager.isBootstrapComplete and will rebuild when it changes.
    scheduleMicrotask(() => app.bootstrap());
    super.initState();
  }

  /// Tear down the app, we can rely on GetIt.reset() action, and add [Disposable] interfaces to any
  /// logic classes that need it.
  @override
  void dispose() {
    GetIt.I.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool bootstrapComplete = watchX((AppManager m) => m.isBootstrapComplete);
    bool useDarkMode = watchX((SettingsManager m) => m.darkMode);
    return bootstrapComplete == false
        ? const SplashPage()
        : MaterialApp(
            theme: useDarkMode ? ThemeData.dark() : ThemeData.light(),
            home: const _MainAppScaffold(),
          );
  }
}

/// Holds a Scaffold, AppBar, TabBarView, and TabBar
class _MainAppScaffold extends StatefulWidget {
  const _MainAppScaffold({Key? key}) : super(key: key);

  @override
  State<_MainAppScaffold> createState() => _MainAppScaffoldState();
}

class _MainAppScaffoldState extends State<_MainAppScaffold> with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late final _tabController = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      /// Settings drawer
      drawer: SizedBox(width: 300, child: SettingsDrawer()),

      /// App Bar
      appBar: AppBar(
        title: const Text('APP TITLE'),
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
      ),

      /// Main content
      body: TabBarView(
        controller: _tabController,
        children: [
          ListDevicesPage(),
          MapPage(),
        ],
      ),

      /// Bottom tabs
      bottomNavigationBar: TabBar(
        controller: _tabController,
        labelPadding: const EdgeInsets.all(16),
        labelColor: Theme.of(context).textTheme.bodyText1!.color,
        tabs: const [
          Text('All Devices'),
          Text('Maps'),
        ],
      ),
    );
  }
}
