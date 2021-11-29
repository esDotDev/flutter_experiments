import 'package:flutter/material.dart';

/// When a swipe is definitely going to happen,
/// the item will set it's status to confirmed or dismissed
enum SwipedStatus {
  none,
  dismissed,
  confirmed,
}

/// A custom dismissible that shows a card underneath the dismissed item and
/// has a fun feel when items are added or removed.
class SwipeableItem extends StatefulWidget {
  const SwipeableItem({
    required Key key,
    required this.child,
    this.onSwipeStart,
    this.onSwipeComplete,
    this.skipOpeningAnimation = false,
    this.padding,
    this.confirmText,
    this.cancelText,
    this.postSwipeAnimationBuilder,
    this.postSwipeAnimationDuration = const Duration(milliseconds: 1000),
  }) : super(key: key);
  final Widget child;

  /// Called when a dismiss has been initiated and the animation is about to begin.
  final void Function(Offset pos)? onSwipeStart;

  /// Called when the dismiss animation is fully complete, including any post-animations
  final VoidCallback? onSwipeComplete;

  /// Widget will jump to it's open state, rather than expanding and fading in.
  /// Used when a list is first shown, and you don't want all of the items to animate open.
  final bool skipOpeningAnimation;

  /// Add padding to the item that will be maintained as the content grows and shrinks, which looks better.
  final EdgeInsets? padding;

  /// The text used in the background layer when user is dragging the item.
  final String? confirmText;
  final String? cancelText;

  /// The length of the postSwipeAnimation, defaults to 1000ms. Only used if [postSwipeAnimationBuilder] is declared.
  final Duration postSwipeAnimationDuration;

  /// Builds a custom animation when a widget has been dismissed.
  /// Can return null to skip the animation.
  final Widget? Function(BuildContext context, AnimationController anim, SwipedStatus status)?
      postSwipeAnimationBuilder;

  @override
  SwipeableItemState createState() => SwipeableItemState();
}

class SwipeableItemState extends State<SwipeableItem>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  /// Drives the expanding and collapsing size effect
  late final AnimationController _sizeAnim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  )..addListener(_handleSizeAnimationUpdate);
  late final _easedSizeAnim = CurvedAnimation(parent: _sizeAnim, curve: Curves.easeOutBack);

  /// Drives the bg layer as it slides off the screen
  late final AnimationController _bgAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 200))
    ..addListener(() => setState(() {}));
  late final _easedBgAnim = CurvedAnimation(parent: _bgAnim, curve: Curves.easeIn);

  /// Drives a custom post dismiss animation if there is one
  late final AnimationController _postDismissAnim =
      AnimationController(vsync: this, duration: widget.postSwipeAnimationDuration);

  SwipedStatus _status = SwipedStatus.none;
  DismissDirection _lastDragDir = DismissDirection.none;
  bool _isPlayingPostDismissAnim = false;

  bool get hasBeenDismissedOrConfirmed => _status != SwipedStatus.none;
  bool get hasBeenConfirmed => _status == SwipedStatus.confirmed;
  double get bgAnimScale => _lastDragDir == DismissDirection.startToEnd ? 1 : -1;

  @override
  initState() {
    if (widget.skipOpeningAnimation) {
      _sizeAnim.value = 1.0; // Jump immediately to the 'open' state
    } else {
      _sizeAnim.forward();
    }
    super.initState();
  }

  @override
  void dispose() {
    _sizeAnim.dispose();
    _bgAnim.dispose();
    _postDismissAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizeTransition(
        sizeFactor: _easedSizeAnim,
        child: Padding(
          padding: widget.padding ?? EdgeInsets.zero,
          child: FadeTransition(
            opacity: _sizeAnim,
            child: Stack(
              children: [
                /// The underlay that sits underneath the list item and is exposed when
                /// the list item is dragged.
                Positioned.fill(
                  child: FractionalTranslation(
                    translation: Offset(_easedBgAnim.value * bgAnimScale, 0),
                    child: _SwipeableItemBg(this),
                  ),
                ),

                /// The child is always showing. It begins wrapped in a standard Dismissible.
                /// Once the dismiss has been started, we remove the dismissible, leave the
                /// invisible child in place, and run the custom dismiss effect.
                if (hasBeenDismissedOrConfirmed) ...[
                  Opacity(child: widget.child, opacity: 0),
                ] else ...[
                  Dismissible(
                      key: widget.key!,
                      child: widget.child,
                      onUpdate: (d) => setState(() => _lastDragDir = d.direction),
                      confirmDismiss: (d) async {
                        swipe(confirm: d == DismissDirection.startToEnd);
                        return false;
                      })
                ],

                /// Enable a custom postDismissBuilder
                if (_isPlayingPostDismissAnim && widget.postSwipeAnimationBuilder != null) ...[
                  AnimatedBuilder(
                      animation: _postDismissAnim,
                      builder: (_, __) {
                        Widget? content = widget.postSwipeAnimationBuilder!.call(context, _postDismissAnim, _status);
                        return content ?? const SizedBox.shrink();
                      })
                ]
              ],
            ),
          ),
        ),
      );

  void swipe({required bool confirm}) async {
    if (hasBeenDismissedOrConfirmed) return;
    setState(() => _status = confirm ? SwipedStatus.confirmed : SwipedStatus.dismissed);

    final rb = context.findRenderObject() as RenderBox;
    widget.onSwipeStart?.call(rb.localToGlobal(Offset(rb.size.width / 2, rb.size.height / 2)));
    _bgAnim.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    // This is where we would wait for a custom animation...
    if (hasBeenConfirmed && widget.postSwipeAnimationBuilder != null) {
      setState(() => _isPlayingPostDismissAnim = true);
      // Start the custom animation builder, and wait for it to complete.
      // Just before it is finished completing, initiate the closing animation
      _postDismissAnim.forward();
      var delay = widget.postSwipeAnimationDuration;
      if (delay.inMilliseconds > 500) delay -= const Duration(milliseconds: 500);
      await Future.delayed(delay);
      if (!mounted) return;
    }
    // Close the content
    _sizeAnim.reverse(from: 1);
  }

  void _handleSizeAnimationUpdate() async {
    if (hasBeenDismissedOrConfirmed) {
      if (_sizeAnim.status == AnimationStatus.dismissed) {
        widget.onSwipeComplete?.call();
        //_sizeAnim.value = 1;
      }
    }
  }

  @override
  bool get wantKeepAlive => _sizeAnim.isAnimating;
}

class _SwipeableItemBg extends StatelessWidget {
  const _SwipeableItemBg(this.state, {Key? key}) : super(key: key);
  final SwipeableItemState state;

  @override
  Widget build(BuildContext context) {
    bool isConfirming = state._lastDragDir == DismissDirection.startToEnd;
    return Container(
      color: isConfirming ? Colors.green : Colors.red,
      alignment: Alignment(isConfirming ? -1 : 1, 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(isConfirming ? state.widget.confirmText ?? 'Confirm' : state.widget.cancelText ?? 'Dismiss',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
