import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hider/utils/json.dart';

class FirestoreUser {
  FirestoreUser({
    required this.id,
    required this.username,
    required this.password,
  });

  factory FirestoreUser.fromDocumentSnapshot(
      QueryDocumentSnapshot<Json> documentSnapshot) {
    final data = documentSnapshot.data();
    return FirestoreUser(
      id: documentSnapshot.id,
      username: List<int>.from(data['_0'] as List? ?? const []),
      password: List<int>.from(data['_1'] as List? ?? const []),
    );
  }

  final String id;
  final List<int> username;
  final List<int> password;
}
