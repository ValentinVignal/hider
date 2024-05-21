import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// A [GoldenFileComparator] that allows for flexible golden file comparisons.
class FlexibleGoldenFileComparator extends LocalFileComparator {
  /// A [GoldenFileComparator] that allows for flexible golden file comparisons.
  FlexibleGoldenFileComparator(super.testFile);

  /// Whether to ignore golden files.
  static const flexibleGoldens = bool.fromEnvironment('flexible-goldens');

  /// The threshold for the comparison when [flexibleGoldens] is true.
  static const flexibleThreshold = 0.01;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    if (!flexibleGoldens) {
      return super.compare(imageBytes, golden);
    }

    final ComparisonResult result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    if (result.passed || (result.diffPercent < flexibleThreshold)) {
      result.dispose();
      return true;
    }

    final String error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }

  @override
  Future<void> update(Uri golden, Uint8List imageBytes) {
    throw StateError('Golden files should not be updated while ignored.');
  }
}
