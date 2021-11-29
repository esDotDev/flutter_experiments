import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:list_effects/dismissable_list_item.dart';
import 'package:list_effects/ripple_effect_list_item.dart';
import 'package:random_color/random_color.dart';

import 'dismissable_list.dart';
import 'listview_builder_with_cached_anims.dart';

void main() {
  runApp(MaterialApp(
    builder: (_, child) => Scaffold(body: child),
    //home: const ListViewBuilderWithCachedAnims(),
    //home: const DismissableWithStaggeredCollapse(),
    home: const KeepAliveBuilderIssue(),
  ));
}

class KeepAliveBuilderIssue extends StatefulWidget {
  const KeepAliveBuilderIssue({Key? key}) : super(key: key);

  @override
  State<KeepAliveBuilderIssue> createState() => _KeepAliveBuilderIssueState();
}

class _KeepAliveBuilderIssueState extends State<KeepAliveBuilderIssue> {
  int _nextItemId = 0;
  int createRandomListItem() => _nextItemId++;
  late final List<int> items = List.generate(100, (_) => createRandomListItem());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 100),
        TextButton(
          onPressed: () {
            setState(() => items.insert(2, createRandomListItem()));
          },
          child: const Text('Add item at index 2'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, index) => _StatefulListItem(key: ValueKey(items[index]), id: '${items[index]}'),
          ),
        ),
      ],
    );
  }
}

class _StatefulListItem extends StatefulWidget {
  const _StatefulListItem({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<_StatefulListItem> createState() => _StatefulListItemState();
}

class _StatefulListItemState extends State<_StatefulListItem> with AutomaticKeepAliveClientMixin {
  int _ticks = 0;
  late Timer _timer;
  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) => setState(() => _ticks++));
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(height: 30, child: Text('id: ${widget.id}, ticks: $_ticks', style: TextStyle(fontSize: 24)));
  }

  @override
  bool get wantKeepAlive => true;
}
