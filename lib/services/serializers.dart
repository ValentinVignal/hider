library serializers;

import 'package:built_value/serializer.dart';
import 'package:hider/services/item.dart';

part 'serializers.g.dart';

@SerializersFor([Item])
final Serializers serializers = _$serializers;
