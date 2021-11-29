import 'package:flutter/material.dart';

import 'examples/get_it_example.dart';
import 'examples/provider_example.dart';
import 'examples/riverpod_example.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: _DemoTabs(),
    ),
  ));
}

class _DemoTabs extends StatefulWidget {
  @override
  __DemoTabsState createState() => __DemoTabsState();
}

class __DemoTabsState extends State<_DemoTabs> with SingleTickerProviderStateMixin {
  final views = const [
    ProviderExample(),
    RiverpodExample(),
    GetItExample(),
  ];
  late final _tabController = TabController(length: views.length, vsync: this);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TabBarView(children: views, controller: _tabController),
        ),
        TabBar(tabs: const [
          Text('Provider', style: TextStyle(fontSize: 32, color: Colors.black)),
          Text('Riverpod', style: TextStyle(fontSize: 32, color: Colors.black)),
          Text('GetIt', style: TextStyle(fontSize: 32, color: Colors.black)),
        ], controller: _tabController),
      ],
    );
  }
}
