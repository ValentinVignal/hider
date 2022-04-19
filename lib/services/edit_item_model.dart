import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hider/utils/path.dart';

final editItemProvider = StateProvider.autoDispose.family<bool, HiderPath>(
  (ref, path) {
    return false;
  },
);
