import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hider/services/authentication_model.dart';
import 'package:hider/services/item.dart';
import 'package:hider/utils/path.dart';

import '../../utils/json.dart';
import 'instance.dart';

mixin FirestoreItemService {
  static const _collectionName = 'items';

  static final collection = FirestoreInstance.instance.collection(
    _collectionName,
  );

  static DocumentReference<Map<String, dynamic>> _documentReference(
      HiderPath path) {
    var documentReference = collection.doc(
      AuthenticationModel.instance.user.id,
    );
    for (final pathItem in path) {
      documentReference =
          documentReference.collection(_collectionName).doc(pathItem);
    }
    return documentReference;
  }

  static Stream<Item> watch(HiderPath path) {
    return _documentReference(path).snapshots().map((documentSnapshot) {
      return Item.fromDocumentSnapshot(documentSnapshot);
    });
  }

  /// Watches the sub items below the item with the path [path].
  static Stream<Iterable<Item>> watchSubs(HiderPath path) {
    return _documentReference(path)
        .collection(_collectionName)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((documentSnapshot) {
        return Item.fromDocumentSnapshot(documentSnapshot);
      });
    });
  }

  /// Creates a sub item below the item with the path [path].
  static Future<String> create(HiderPath path) async {
    final collectionReference = _documentReference(path).collection(
      _collectionName,
    );
    final documentReference = await collectionReference.add(const {});
    return documentReference.id;
  }

  /// Saved the item with the path [path].
  static Future<void> save(HiderPath path, Item item) async {
    final documentReference = _documentReference(path);
    await documentReference.set(item.toEncryptedJson());
  }

  static Stream<List<Item>> watchAllFromPath(HiderPath path) {
    return StreamZip([
      for (var index = 1, indexEnd = path.length; index <= indexEnd; index++)
        watch(path.subPath(0, index)),
    ]);
  }

  static Future<void> delete(HiderPath path) {
    final documentReference = _documentReference(path);
    return documentReference.delete();
  }

  static Future<Json> getAll() async {
    final json = <String, dynamic>{};
    await _getAllRecursive(const HiderPath(), json);
    final rootItem = Item.fromDocumentSnapshot(
      await _documentReference(const HiderPath()).get(),
    );
    json.addAll(rootItem.toJson());

    return json;
  }

  static Future<void> _getAllRecursive(HiderPath path, Json json) async {
    final item = Item.fromDocumentSnapshot(
      await _documentReference(path).get(),
    );
    json.addAll(item.toJson());
    final subItems =
        await _documentReference(path).collection(_collectionName).get();
    if (subItems.docs.isNotEmpty) {
      final subItemsJson = <Map<String, dynamic>>[];
      json[_collectionName] = subItemsJson;
      for (final subItem in subItems.docs) {
        final subJson = <String, dynamic>{};
        subItemsJson.add(subJson);
        await _getAllRecursive(path.add(subItem.id), subJson);
      }
    }
  }
}
