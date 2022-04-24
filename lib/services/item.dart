import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hider/services/authentication_model.dart';
import 'package:hider/utils/json.dart';

part 'item.freezed.dart';

var a = 1;

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
    print('data of item $data');
    return Item(
      id: documentSnapshot.id,
      // TODO: Decrypt
      name: data['name'] ?? 'name',
      value: AuthenticationModel.instance.decrypt(data['value'] ?? ''),
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
  Json toJson() {
    return {
      'value': AuthenticationModel.instance.encrypt(value),
      'name': name,
      'description': description,
    };
  }
}
