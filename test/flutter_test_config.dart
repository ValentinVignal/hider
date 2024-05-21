import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;

import 'utils/flexible_golden_file_comparator.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  if (FlexibleGoldenFileComparator.flexibleGoldens) {
    goldenFileComparator = FlexibleGoldenFileComparator(
      Uri.parse(
        path.join(
          (goldenFileComparator as LocalFileComparator).basedir.toString(),
          'just_arbitrary_string.dart',
        ),
      ),
    );
  }

  await testMain();
}
