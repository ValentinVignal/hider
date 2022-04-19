import 'package:hider/services/firestore/firestore_item_service.dart';
import 'package:hider/services/item.dart';
import 'package:hider/utils/path.dart';
import 'package:riverpod/riverpod.dart';

final itemProvider =
    StreamProvider.autoDispose.family<Item, HiderPath>((ref, path) {
  return FirestoreItemService.fromPath(path);
});
