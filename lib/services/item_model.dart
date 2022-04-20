import 'package:hider/services/firestore/firestore_item_service.dart';
import 'package:hider/services/item.dart';
import 'package:hider/utils/path.dart';
import 'package:riverpod/riverpod.dart';

final originalItemProvider =
    StreamProvider.autoDispose.family<Item, HiderPath>((ref, path) {
  return FirestoreItemService.watch(path);
});

final itemProvider =
    StateProvider.autoDispose.family<Item, HiderPath>((ref, path) {
  return ref.watch(originalItemProvider(path)).value ?? Item.empty(path.last);
});

final subItemsProvider =
    StreamProvider.autoDispose.family<Iterable<Item>, HiderPath>(
  (ref, path) {
    return FirestoreItemService.watchSubs(path);
  },
);
