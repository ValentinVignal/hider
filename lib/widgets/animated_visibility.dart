import 'package:flutter/material.dart';

/// Displays the child when [visible] is `true` and a [SizedBox.shrink] when
/// [visible] is `false`, but does it with a size transition.
class AnimatedVisibility extends StatelessWidget {
  /// Displays the child when [visible] is `true` and a [SizedBox.shrink] when
  /// [visible] is `false`, but does it with a size transition.
  const AnimatedVisibility({
    required this.visible,
    required this.child,
    this.axis = Axis.vertical,
    Key? key,
  }) : super(key: key);

  /// The child to display when [visible] is `true`.
  final Widget child;

  /// If `true`, it displays the [child], else if displays a [SizedBox.shrink].
  final bool visible;

  /// The axis of the transition. The default is [Axis.vertical].
  final Axis axis;

  /// The duration of the transition.
  @visibleForTesting
  static const duration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (child, animation) {
        return SizeTransition(
          sizeFactor: animation,
          axis: axis,
          child: child,
        );
      },
      child: visible ? child : const SizedBox.shrink(),
    );
  }
}
