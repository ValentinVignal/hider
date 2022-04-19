import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hider/services/authentication_model.dart';
import 'package:hider/services/firestore/firestore_user.dart';

mixin FirestoreUserService {
  static const _collectionName = 'users';

  static final _collection = FirebaseFirestore.instance.collection(
    _collectionName,
  );

  static Future<FirestoreUser?> getByUsername(String username) async {
    final querySnapshot = await _collection
        .where('_0', isEqualTo: AuthenticationModel.hash(username))
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }
    return FirestoreUser.fromDocumentSnapshot(querySnapshot.docs.first);
  }

  static Future<FirestoreUser> save({
    required String username,
    required String password,
  }) async {
    final _username = AuthenticationModel.hash(username);
    final _password = AuthenticationModel.hash(password);
    final documentReference = await _collection.add({
      '_0': _username,
      '_1': _password,
    });
    return FirestoreUser(
      id: documentReference.id,
      username: _username,
      password: _password,
    );
  }
}
