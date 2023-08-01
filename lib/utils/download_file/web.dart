@JS()

import 'dart:async';
import 'dart:typed_data';

import 'package:js/js.dart';
import 'package:universal_html/html.dart' as html;

/// Annotates `webSaveAs` to invoke JavaScript `window.webSaveAs`.
@JS('webSaveAs')
external void webSaveAs(html.Blob blob, String fileName);

/// Downloads the file on to the local machine.
Future<void> saveFileLocally(String fileName, Uint8List content) async {
  webSaveAs(html.Blob([content]), fileName);
}
