import 'package:hider/services/firestore/firestore_item_service.dart';
import 'package:hider/services/item.dart';
import 'package:hider/utils/path.dart';
import 'package:riverpod/riverpod.dart';

/// The item from the database.
final originalItemProvider =
    StreamProvider.autoDispose.family<Item, HiderPath>((ref, path) {
  return FirestoreItemService.watch(path);
});

/// The database in the front end which is potentially edited.
final itemProvider = StateProvider.autoDispose.family<Item, HiderPath>(
  (ref, path) {
    final value = ref.watch(originalItemProvider(path)).value;
    if (value != null) return value;
    return Item.empty(path.isNotEmpty ? path.last : '');
  },
  dependencies: [originalItemProvider],
);

/// The items from the database.
final _subItemsProvider =
    StreamProvider.autoDispose.family<Iterable<Item>, HiderPath>(
  (ref, path) {
    return FirestoreItemService.watchSubs(path);
  },
);

/// The ordered items in the front end.
final subItemsProvider =
    Provider.autoDispose.family<AsyncValue<Iterable<Item>>, HiderPath>(
  (ref, path) {
    return ref.watch(_subItemsProvider(path)).whenData((items) {
      return [...items]
        ..sort((itemA, itemB) => itemA.name.compareTo(itemB.name));
    });
  },
  dependencies: [_subItemsProvider],
);

final allItemsOfPathProvider =
    StreamProvider.autoDispose.family<List<Item>, HiderPath>((ref, path) {
  return FirestoreItemService.watchAllFromPath(path);
});
