import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_ui/material_ui.dart';

mixin FirestoreInstance {
  @visibleForTesting
  static FirebaseFirestore? mockInstance;

  static FirebaseFirestore get instance {
    return mockInstance ?? FirebaseFirestore.instance;
  }
}
