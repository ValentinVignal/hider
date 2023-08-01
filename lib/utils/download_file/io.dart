import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;

/// Save the file locally in the "download" directory.
Future<void> saveFileLocally(String fileName, Uint8List content) async {
  late final io.Directory directory;
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      directory = (await path_provider.getExternalStorageDirectory())!;
      break;
    case TargetPlatform.iOS:
      directory = await path_provider.getApplicationSupportDirectory();
      break;
    case TargetPlatform.linux:
    case TargetPlatform.macOS:
    case TargetPlatform.windows:
      directory = (await path_provider.getDownloadsDirectory())!;
      break;
    default:
      await path_provider.getApplicationDocumentsDirectory();
  }
  final newFile = io.File(_getUniquePath(path.join(directory.path, fileName)));
  await newFile.writeAsBytes(content);
}

/// Returns a unique file path from [filePath].
///
/// - If [filePath] does not exist, it will be created.
/// - If [filePath] already exists, it will be renamed to a unique path by
///   adding `" (${count})"` to the file name.
String _getUniquePath(String filePath) {
  final name = path.basenameWithoutExtension(filePath);
  final ext = path.extension(filePath);
  final directory = path.dirname(filePath);
  var count = 0;

  String getPath() {
    var fileName = name;
    if (count > 0) {
      fileName = '$fileName ($count)';
    }
    fileName = '$fileName$ext';
    return path.join(directory, fileName);
  }

  while (io.File(getPath()).existsSync()) {
    count++;
  }

  return getPath();
}
