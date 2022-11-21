import 'package:hider/services/authentication_model.dart';
import 'package:hider/services/firestore/firestore_user.dart';

import 'instance.dart';

mixin FirestoreUserService {
  static const _collectionName = 'users';

  static final _collection = FirestoreInstance.instance.collection(
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
    final hashedUsername = AuthenticationModel.hash(username);
    final hashedPassword = AuthenticationModel.hash(password);
    final documentReference = await _collection.add({
      '_0': hashedUsername,
      '_1': hashedPassword,
    });
    return FirestoreUser(
      id: documentReference.id,
      username: hashedUsername,
      password: hashedPassword,
    );
  }
}
