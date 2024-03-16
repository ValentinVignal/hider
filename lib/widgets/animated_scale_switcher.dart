import 'package:flutter/material.dart';

class AnimatedScaleSwitcher extends StatelessWidget {
  const AnimatedScaleSwitcher({
    required this.child,
    this.axis = Axis.vertical,
    super.key,
  });

  final Widget child;

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
      child: child,
    );
  }
}
