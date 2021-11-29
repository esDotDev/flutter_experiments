import 'dart:math';

import 'package:flutter/material.dart';

import 'dismissable_list_item.dart';

class ListItemData {
  ListItemData(this.index);
  final int index;
}

class MoneySavedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DismissibleListView extends StatefulWidget {
  const DismissibleListView({Key? key}) : super(key: key);

  @override
  _DismissibleListViewState createState() => _DismissibleListViewState();
}

class _DismissibleListViewState extends State<DismissibleListView> {
  final List<ListItemData> _items = List.generate(30, (index) => ListItemData(index));

  @override
  Widget build(BuildContext context) {
    SwipeableItem buildItem(ListItemData e) => SwipeableItem(
          key: ValueKey(e.index),
          padding: const EdgeInsets.only(bottom: 6),
          onSwipeComplete: () => setState(() => _items.remove(e)),
          postSwipeAnimationBuilder: (_, anim, status) {
            if (status == SwipedStatus.dismissed) return null;
            return AnimatedPostSwipeMessage(animation: anim, label: 'You saved \$${e.index * 4}!');
          },
          child: _SomeCard(title: 'item${e.index}'),
        );

    return Column(
      children: [
        TextButton(
            onPressed: () {
              final newItem = ListItemData(Random().nextInt(999));
              setState(() => _items.insert(Random().nextInt(4), newItem));
            },
            child: Text('addItem')),
        Expanded(
          child: ListView(
            children: _items.map(buildItem).toList(),
          ),
        ),
      ],
    );
  }
}

class _SomeCard extends StatelessWidget {
  const _SomeCard({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) => Container(
        height: 80,
        width: double.infinity,
        color: Colors.grey.shade300,
        alignment: Alignment.center,
        child: Text(title, style: const TextStyle(fontSize: 24)),
      );
}

///
class AnimatedPostSwipeMessage extends StatelessWidget {
  AnimatedPostSwipeMessage({Key? key, required this.label, required this.animation}) : super(key: key);
  final String label;
  final AnimationController animation;

  final _tween = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 20),
    TweenSequenceItem(tween: Tween(begin: 1, end: 1), weight: 80),
    TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 20),
  ]);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: FadeTransition(
        opacity: animation.drive(_tween),
        child: Center(child: Text(label, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w600))),
      ),
    );
  }
}
