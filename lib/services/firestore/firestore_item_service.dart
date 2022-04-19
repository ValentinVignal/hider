import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hider/services/authentication_model.dart';
import 'package:hider/services/item.dart';
import 'package:hider/utils/path.dart';

mixin FirestoreItemService {
  static const _collectionName = 'items';

  static final _collection = FirebaseFirestore.instance.collection(
    _collectionName,
  );

  static Stream<Item> fromPath(HiderPath path) {
    var documentReference =
        _collection.doc(AuthenticationModel.instance.user.id);
    for (final _path in path) {
      documentReference =
          documentReference.collection(_collectionName).doc(_path);
    }
    // TODO: Combine children.
    return documentReference.snapshots().map((documentSnapshot) {
      return Item.fromDocumentSnapshot(documentSnapshot);
    });
  }
}
