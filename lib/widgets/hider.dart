import 'package:flutter/material.dart';

class Hider extends StatefulWidget {
  const Hider({required this.child, super.key});

  /// Child widget
  final Widget child;

  @override
  State<Hider> createState() => _HiderState();
}

class _HiderState extends State<Hider> with WidgetsBindingObserver {
  AppLifecycleState? lifeCycleState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      lifeCycleState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (lifeCycleState == AppLifecycleState.inactive ||
            lifeCycleState == AppLifecycleState.paused)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: const Center(
                child: Icon(Icons.visibility_off),
              ),
            ),
          ),
      ],
    );
  }
}
