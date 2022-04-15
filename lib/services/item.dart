import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'item.g.dart';

abstract class Item implements Built<Item, ItemBuilder> {
  Item._();
  factory Item([void Function(ItemBuilder) updates]) = _$Item;

  // Can never be null.
  String get title;

  String get description;

  String get hidden;

  List<Item>? get items;

  static Serializer<Item> get serializer => _$itemSerializer;
}
