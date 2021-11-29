import 'package:flutter/material.dart';

class RippleEffectListController with ChangeNotifier {
  List<_RippleEffectListItemState> items = [];

  void handleItemRemoved(Offset pos) {
    print('handleItemRemoved');
    for (var i in items) {
      i.handleSiblingRemoved(pos);
    }
  }

  void handleItemAdded(_RippleEffectListItemState item) {
    print('handleItemAdded');
    for (var i in items) {
      if (i == item) continue;
      i.handleSiblingAdded(item);
    }
  }

  void registerItem(_RippleEffectListItemState item) {
    if (items.contains(item)) return;
    items.add(item);
  }

  void unRegisterItem(_RippleEffectListItemState item) {
    if (items.contains(item)) items.remove(item);
  }

  @override
  void dispose() {
    items.clear();
    super.dispose();
  }
}

/// Takes a controller and calls it when it has started to be removed.
/// Also reacts to siblings and animates itself when siblings have been added or removed
/// Optimized for lists of < 100 items
class RippleEffectListItem extends StatefulWidget {
  RippleEffectListItem({Key? key, required this.controller, required this.child}) : super(key: key);
  final RippleEffectListController controller;
  final Widget child;

  @override
  State<RippleEffectListItem> createState() => _RippleEffectListItemState();
}

class _RippleEffectListItemState extends State<RippleEffectListItem>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
    ..addListener(() => setState(() {}));

  double _targetOffset = 0;

  Animation<double>? _offsetAnimation;

  @override
  void initState() {
    widget.controller.registerItem(this);
    super.initState();
  }

  @override
  void dispose() {
    _animController.dispose();
    widget.controller.unRegisterItem(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Transform.translate(offset: Offset(0, _offsetAnimation?.value ?? 0), child: widget.child);

  /// Called from the controller anytime a list item is removed, giving the other items a chance to react.
  /// This method will determine the bounds of the current list item, and then pass those to anther method
  /// to do the actual effect.
  void handleSiblingRemoved(Offset pos) {
    final myRb = context.findRenderObject() as RenderBox?;
    if (myRb == null) return; // Exit if we're offstage
    final myPos = myRb.localToGlobal(Offset(myRb.size.width / 2, myRb.size.height / 2));
    // Once we get all the information we need, trigger the actual animation.
    _doRippleTransformationEffect(isAdding: false, otherPos: pos, localPos: myPos, localSize: myRb.size);
  }

  void handleSiblingAdded(_RippleEffectListItemState item) {}

  void _doRippleTransformationEffect(
      {required bool isAdding, required Offset otherPos, required Offset localPos, required Size localSize}) {
    if (localSize.height == 0) {
      return;
    }
    final indexDelta = ((localPos.dy - otherPos.dy) / localSize.height).round();
    // We don't want to animate for items that are above us, or only 1 slot away
    if (indexDelta <= 1) {
      //print('$this Skipping [_doRippleTransformationEffect] because indexDelta <= 1');
      return;
    }

    // Figure out how long we want our tween, based on how many items we are away
    const delayPerIndex = .05;
    const collapseTime = .35;
    final holdTime = indexDelta * delayPerIndex;
    final totalTweenTime = collapseTime + holdTime;

    /// If we're removing, we want to increase the Y pos in order to hold our spot. If we're adding, the opposite is true.
    _targetOffset = 15 * indexDelta * (isAdding ? -1 : 1);
    // A two-part tween where the first part is variable length and the final portion is fixed.
    // To work with [TweenSequence] we need to convert from seconds to a fraction.
    final holdFraction = holdTime / totalTweenTime;
    _offsetAnimation = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: _targetOffset),
          weight: holdFraction,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: _targetOffset, end: 0),
          weight: 1 - holdFraction,
        ),
      ],
    ).animate(_animController);

    // Set the animators duration equal to the total tween time
    _animController.duration = Duration(milliseconds: (totalTweenTime * 1000).toInt());
    _animController.forward(from: 0);
  }

  @override
  bool get wantKeepAlive => true;
}
