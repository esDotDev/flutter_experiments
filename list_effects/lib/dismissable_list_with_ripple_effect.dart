import 'package:flutter/material.dart';
import 'package:list_effects/main.dart';

import 'dismissable_list_item.dart';
import 'ripple_effect_list_item.dart';

class ListItemData {
  ListItemData(this.index);
  final int index;
}

class DismissableWithStaggeredCollapse extends StatefulWidget {
  const DismissableWithStaggeredCollapse({Key? key}) : super(key: key);

  @override
  State<DismissableWithStaggeredCollapse> createState() => _DismissableWithStaggeredCollapseState();
}

class _DismissableWithStaggeredCollapseState extends State<DismissableWithStaggeredCollapse> {
  final List<ListItemData> _items = List.generate(30, (index) => ListItemData(index));
  @override
  Widget build(BuildContext context) {
    return ScalingDismissableListWithRippleEffect<ListItemData>(
      onItemDismissed: (item) => setState(() => _items.remove(item)),
      itemBuilder: (_, item) {
        return Padding(
          key: ValueKey(item.index),
          padding: const EdgeInsets.all(2),
          child: Container(
            color: Colors.grey,
            alignment: Alignment.center,
            height: 80,
            child: Text('${item.index}', style: const TextStyle(fontSize: 40)),
          ),
        );
      },
      items: _items,
    );
  }
}

/// Each item can be drag to dismiss, and also performs a cool offset animations in it's children.
/// New items will expand when they are first shown, and shrink when they are removed
/// When an item begins shrinking, the items around it will animate their translations to
/// give a staggered timing effect.
class ScalingDismissableListWithRippleEffect<T> extends StatefulWidget {
  const ScalingDismissableListWithRippleEffect(
      {Key? key, required this.items, required this.itemBuilder, this.onItemDismissed})
      : super(key: key);
  final List<T> items;
  final Widget Function(BuildContext c, T item) itemBuilder;
  final void Function(dynamic value)? onItemDismissed;

  @override
  State<ScalingDismissableListWithRippleEffect<T>> createState() => _ScalingDismissableListWithRippleEffectState<T>();
}

class _ScalingDismissableListWithRippleEffectState<T> extends State<ScalingDismissableListWithRippleEffect<T>> {
  final _transformingListController = RippleEffectListController();
  int _buildCount = 0;

  @override
  Widget build(BuildContext context) {
    _buildCount++;
    return SingleChildScrollView(
      child: Column(
        children: widget.items.map((item) {
          Widget itemWidget = widget.itemBuilder(context, item);
          return RippleEffectListItem(
            controller: _transformingListController,
            child: SwipeableItem(
              key: ObjectKey(item),
              child: itemWidget,
              skipOpeningAnimation: _buildCount <= 1,
              // Tie the dismiss animation into the ripple effect
              onSwipeStart: (pos) => _transformingListController.handleItemRemoved(pos),
              onSwipeComplete: () => widget.onItemDismissed?.call(item),
            ),
          );
        }).toList(),
      ),
    );
  }
}
