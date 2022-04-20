import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hider/utils/json.dart';

part 'item.freezed.dart';

@freezed
class Item with _$Item {
  const factory Item({
    required String id,
    required String description,
    required String name,
    required String value,
  }) = _Item;

  factory Item.fromDocumentSnapshot(DocumentSnapshot<Json> documentSnapshot) {
    final data = documentSnapshot.data() ?? const {};
    return Item(
      id: documentSnapshot.id,
      // TODO: Decrypt
      name: data['name'] ?? 'name',
      value: data['value'] ?? 'value',
      description: data['description'] ?? 'description',
    );
  }

  factory Item.empty(String id) => Item(
        id: id,
        description: '',
        name: '',
        value: '',
      );
}

extension ExtensionItem on Item {
  Json toJson() => {
        'test': 'test',
      };
}
