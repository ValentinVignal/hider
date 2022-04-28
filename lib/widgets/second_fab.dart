import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hider/screens/home/home_screen.dart';
import 'package:hider/services/edit_item_model.dart';
import 'package:hider/services/firestore/firestore_item_service.dart';
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
      onPressed: () async {
        if (isEditing) {
          // Cancels the edition.
          ref.read(editItemProvider(path).notifier).state = !isEditing;
        } else {
          // Creates a sub item.
          final id = await FirestoreItemService.create(path);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HomeScreen(path: path.add(id)),
              ));
        }
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