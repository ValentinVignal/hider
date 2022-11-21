import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

mixin FirestoreInstance {
  @visibleForTesting
  static FirebaseFirestore? mockInstance;

  static FirebaseFirestore get instance {
    return mockInstance ?? FirestoreInstance.instance;
  }
}
