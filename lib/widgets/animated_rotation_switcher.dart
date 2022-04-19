import 'package:flutter/material.dart';

class AnimatedRotationSwitcher extends StatelessWidget {
  const AnimatedRotationSwitcher({
    required this.child,
    Key? key,
  }) : super(key: key);

  /// The child to display when [visible] is `true`.
  final Widget child;

  /// The duration of the transition.
  @visibleForTesting
  static const duration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (child, animation) {
        return RotationTransition(
          turns: animation,
          child: child,
        );
      },
      child: child,
    );
  }
}
