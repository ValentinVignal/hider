import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hider/utils/json.dart';

class Item with EquatableMixin {
  const Item({
    required this.id,
    required this.description,
    required this.name,
    required this.value,
    this.items = const [],
  });

  factory Item.fromDocumentSnapshot(DocumentSnapshot<Json> documentSnapshot) {
    final data = documentSnapshot.data() ?? const {};
    return Item(
      id: documentSnapshot.id,
      // TODO: Decrypt
      name: data['name'] ?? 'name',
      value: data['value'] ?? 'value',
      description: data['description'] ?? 'description',
      items: const [],
    );
  }

  final String id;
  final String description;
  final String name;

  final String value;

  final List<Item> items;

  @override
  List<Object> get props => [id];
}
