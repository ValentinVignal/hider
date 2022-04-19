import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hider/utils/path.dart';

final editItemProvider = StateNotifierProvider.autoDispose
    .family<EditItemModel, bool, HiderPath>((ref, path) {
  return EditItemModel();
});

class EditItemModel extends StateNotifier<bool> {
  EditItemModel() : super(false);

  bool get isEditing => state;

  void switchState() {
    state = !state;
  }
}
