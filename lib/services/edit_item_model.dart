import 'package:hider/utils/path.dart';

import '../utils/state_provider.dart';

final editItemProvider = StateProvider.autoDisposeFamily<bool, HiderPath>((
  ref,
  path,
) {
  return false;
});
