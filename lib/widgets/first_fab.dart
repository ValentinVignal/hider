import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hider/services/edit_item_model.dart';
import 'package:hider/services/firestore/firestore_item_service.dart';
import 'package:hider/services/item_model.dart';
import 'package:hider/utils/path.dart';
import 'package:hider/widgets/animated_rotation_switcher.dart';

class FirstFAB extends ConsumerWidget {
  const FirstFAB(this.path, {Key? key}) : super(key: key);

  final HiderPath path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(editItemProvider(path));
    return FloatingActionButton(
      heroTag: 'firstFAB',
      onPressed: () async {
        if (isEditing) {
          // Save the item in the db
          final modifiedItem = ref.read(itemProvider(path));
          await FirestoreItemService.save(path, modifiedItem);
        }
        ref.read(editItemProvider(path).notifier).state = !isEditing;
      },
      child: AnimatedRotationSwitcher(
        child: Icon(
          isEditing ? Icons.done : Icons.edit,
          key: ValueKey(isEditing),
        ),
      ),
    );
  }
}
