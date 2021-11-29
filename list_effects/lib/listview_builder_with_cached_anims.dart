import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class StatefulAnimationFactory {
  StatefulAnimationFactory(this.vsync, {this.duration = const Duration(milliseconds: 300)});
  final Duration duration;
  final TickerProviderStateMixin vsync;
  final Map<Key, AnimationController> _animationsByKey = {};
  final Map<Key, Timer> _timersByKey = {};

  AnimationController get(Key key) {
    clearScheduledDispose(key);
    if (_animationsByKey.containsKey(key) == false) {
      print('Creating new AnimationController, key=$key');
      _animationsByKey[key] = AnimationController(vsync: vsync, duration: duration);
    }
    return _animationsByKey[key]!;
  }

  void scheduleDispose(Key key) {
    clearScheduledDispose(key);
    _timersByKey[key] = Timer.periodic(const Duration(seconds: 1), (t) {
      debugPrint('Disposing AnimationController, key=$key');
      _animationsByKey[key]?.dispose();
      _animationsByKey.remove(key);
      clearScheduledDispose(key);
      t.cancel();
    });
  }

  void clearScheduledDispose(Key key) {
    _timersByKey[key]?.cancel();
    _timersByKey.remove(key);
  }
}

class ListViewBuilderWithCachedAnims extends StatefulWidget {
  const ListViewBuilderWithCachedAnims({Key? key}) : super(key: key);

  @override
  State<ListViewBuilderWithCachedAnims> createState() => _ListViewBuilderWithCachedAnimsState();
}

class _ListViewBuilderWithCachedAnimsState extends State<ListViewBuilderWithCachedAnims> with TickerProviderStateMixin {
  List<String> items = List.generate(12, (index) => 'item$index');
  late StatefulAnimationFactory animationFactory =
      StatefulAnimationFactory(this, duration: const Duration(milliseconds: 600));

  @override
  Widget build(BuildContext context) {
    timeDilation = 1;
    final cards = items
        .map((e) => DismissableWithDelayedSizeTransition(
              animationFactory: animationFactory,
              padding: const EdgeInsets.only(bottom: 6),
              key: ValueKey(e),
              onDismissed: () {
                scheduleMicrotask(() => setState(() => items.remove(e)));
              },
              child: SizedBox(
                height: 110,
                child: Column(
                  children: [
                    Container(height: 100, child: Text(e), alignment: Alignment.center, color: Colors.grey.shade300),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ))
        .toList();
    return Column(
      children: [
        TextButton(
          child: Text('Add Item'),
          onPressed: () => setState(() => items.insert(0, 'item${100 + Random().nextInt(999999)}')),
        ),
        TextButton(
          child: Text('Remove Item'),
          onPressed: () => setState(() => items.removeAt(0)),
        ),
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverList(
                //delegate: SliverChildBuilderDelegate((_, i) => cards[i], childCount: cards.length),
                delegate: SliverChildListDelegate(cards),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DismissableWithDelayedSizeTransition extends StatefulWidget {
  const DismissableWithDelayedSizeTransition(
      {Key? key, required this.child, required this.onDismissed, required this.animationFactory, this.padding})
      : super(key: key);
  final Widget child;
  final VoidCallback onDismissed;
  final StatefulAnimationFactory animationFactory;
  final EdgeInsets? padding;

  @override
  State<DismissableWithDelayedSizeTransition> createState() => _DismissableWithDelayedSizeTransitionState();
}

class _DismissableWithDelayedSizeTransitionState extends State<DismissableWithDelayedSizeTransition>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final Color _color = Colors.grey.withOpacity(Random().nextDouble());
  AnimationController get _animController => widget.animationFactory.get(widget.key!);
  late final curvedAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOutBack);

  @override
  void initState() {
    if (_animController.value == 0) {
      _animController.forward(from: 0);
    }
    scheduleMicrotask(() => widget.animationFactory.clearScheduledDispose(widget.key!));
    super.initState();
  }

  void close() {
    _animController.reverse();
  }

  @override
  void dispose() {
    widget.animationFactory.scheduleDispose(widget.key!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: close,
      child: AnimatedBuilder(
        animation: _animController,
        builder: (_, __) {
          if (_animController.status == AnimationStatus.dismissed) {
            widget.onDismissed.call();
          }
          return SizeTransition(
            sizeFactor: curvedAnim,
            child: FadeTransition(
                opacity: _animController,
                child: Padding(padding: widget.padding ?? EdgeInsets.zero, child: widget.child)),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true; //_animController.isAnimating;
}

class CustomDisimissableController {
  List<_DismissableWithDelayedSizeTransitionState> _states = [];

  void attach(_DismissableWithDelayedSizeTransitionState s) {
    if (_states.contains(s) == false) {
      _states.add(s);
    }
  }

  void detach(_DismissableWithDelayedSizeTransitionState s) {
    if (_states.contains(s)) {
      _states.remove(s);
    }
  }
}
