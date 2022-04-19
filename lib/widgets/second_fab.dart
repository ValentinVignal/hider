import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hider/services/edit_item_model.dart';
import 'package:hider/utils/path.dart';
import 'package:hider/widgets/animated_rotation_switcher.dart';

class SecondFAB extends ConsumerWidget {
  const SecondFAB(this.path, {Key? key}) : super(key: key);

  final HiderPath path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(editItemProvider(path));
    return FloatingActionButton(
      heroTag: 'secondFAB',
      onPressed: () {
        ref.read(editItemProvider(path).notifier).switchState();
      },
      child: AnimatedRotationSwitcher(
        child: Icon(
          isEditing ? Icons.close : Icons.add,
          key: ValueKey(isEditing),
        ),
      ),
    );
  }
}
