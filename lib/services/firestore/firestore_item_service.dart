import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hider/services/authentication_model.dart';
import 'package:hider/services/item.dart';
import 'package:hider/utils/path.dart';

mixin FirestoreItemService {
  static const _collectionName = 'items';

  static final collection = FirebaseFirestore.instance.collection(
    _collectionName,
  );

  static DocumentReference<Map<String, dynamic>> _documentReference(
      HiderPath path) {
    var documentReference = collection.doc(
      AuthenticationModel.instance.user.id,
    );
    for (final _path in path) {
      documentReference =
          documentReference.collection(_collectionName).doc(_path);
    }
    return documentReference;
  }

  static Stream<Item> watch(HiderPath path) {
    return _documentReference(path).snapshots().map((documentSnapshot) {
      return Item.fromDocumentSnapshot(documentSnapshot);
    });
  }

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

  static Future<String> create(HiderPath path) async {
    final collectionReference = _documentReference(path).collection(
      _collectionName,
    );
    final documentReference = await collectionReference.add(const {});
    return documentReference.id;
  }

  static Future<void> save(HiderPath path, Item item) async {
    final documentReference = _documentReference(path);
    await documentReference.set(item.toJson());
  }
}
