import 'dart:convert';
import 'dart:io';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hider/screens/home/home_app_bar.dart';
import 'package:hider/screens/home/home_screen.dart';
import 'package:hider/services/authentication_model.dart';
import 'package:hider/services/firestore/firestore_item_service.dart';
import 'package:hider/services/firestore/instance.dart';
import 'package:hider/services/item.dart';
import 'package:hider/services/user.dart';
import 'package:hider/utils/path.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _MockPathProviderPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {}

class _MockFile extends Mock implements File {}

void main() {
  setUp(() {
    PathProviderPlatform.instance = _MockPathProviderPlatform();
  });
  testWidgets('It should export a single item', (tester) async {
    final file = _MockFile();
    when(file.existsSync).thenReturn(false);
    when(() => file.writeAsBytes(any())).thenAnswer(
      (invocation) => Future.value(file),
    );
    when(PathProviderPlatform.instance.getExternalStoragePath).thenAnswer(
      (invocation) => Future.value('/path'),
    );
    FirestoreInstance.mockInstance = FakeFirebaseFirestore();
    AuthenticationModel.instance.login(const User(
      id: 'userId',
      username: 'username',
      password: 'password',
    ));
    await FirestoreItemService.save(
      const HiderPath(),
      const Item(
        id: 'itemId',
        name: 'itemName',
        description: 'itemDescription',
        value: 'itemValue',
      ),
    );
    await IOOverrides.runZoned(
      () async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: HomeScreen(),
            ),
          ),
        );
        await tester.tap(find.byType(PopupMenuButton<PopupMenuOption>));
        await tester.pumpAndSettle(); // Wait for the menu to open.
        await tester.tap(find.text('Export'));
        await tester.pump();
      },
      createFile: (path) {
        return file;
      },
    );
    final captured = verify(() => file.writeAsBytes(captureAny())).captured;
    expect(captured, hasLength(1));
    final bytes = captured.first as List<int>;
    final string = String.fromCharCodes(bytes);
    final json = jsonDecode(string);

    expect(
      json,
      const {
        'id': 'userId',
        'description': 'itemDescription',
        'name': 'itemName',
        'value': 'itemValue'
      },
    );
  });
  testWidgets('It should export an item and its nested item', (tester) async {
    final file = _MockFile();
    when(file.existsSync).thenReturn(false);
    when(() => file.writeAsBytes(any())).thenAnswer(
      (invocation) => Future.value(file),
    );
    when(PathProviderPlatform.instance.getExternalStoragePath).thenAnswer(
      (invocation) => Future.value('/path'),
    );
    FirestoreInstance.mockInstance = FakeFirebaseFirestore();
    AuthenticationModel.instance.login(const User(
      id: 'userId',
      username: 'username',
      password: 'password',
    ));
    await FirestoreItemService.save(
      const HiderPath(),
      const Item(
        id: 'itemId',
        name: 'itemName',
        description: 'itemDescription',
        value: 'itemValue',
      ),
    );
    await FirestoreItemService.save(
      const HiderPath(['subItemId']),
      const Item(
        id: 'subItemId',
        name: 'subItemName',
        description: 'subItemDescription',
        value: 'subItemValue',
      ),
    );
    await IOOverrides.runZoned(
      () async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: HomeScreen(),
            ),
          ),
        );
        await tester.tap(find.byType(PopupMenuButton<PopupMenuOption>));
        await tester.pumpAndSettle(); // Wait for the menu to open.
        await tester.tap(find.text('Export'));
        await tester.pump();
      },
      createFile: (path) {
        return file;
      },
    );
    final captured = verify(() => file.writeAsBytes(captureAny())).captured;
    expect(captured, hasLength(1));
    final bytes = captured.first as List<int>;
    final string = String.fromCharCodes(bytes);
    final json = jsonDecode(string);

    expect(
      json,
      const {
        'id': 'userId',
        'description': 'itemDescription',
        'name': 'itemName',
        'value': 'itemValue',
        'items': [
          {
            'id': 'subItemId',
            'description': 'subItemDescription',
            'name': 'subItemName',
            'value': 'subItemValue'
          }
        ]
      },
    );
  });
}
