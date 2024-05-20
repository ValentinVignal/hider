import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hider/screens/home/home_screen.dart';
import 'package:hider/services/authentication_model.dart';
import 'package:hider/services/firestore/firestore_item_service.dart';
import 'package:hider/services/firestore/instance.dart';
import 'package:hider/services/item.dart';
import 'package:hider/services/user.dart';
import 'package:hider/utils/path.dart';

void main() {
  testWidgets('It should build the home screen', (tester) async {
    FirestoreInstance.mockInstance = FakeFirebaseFirestore();
    AuthenticationModel.instance.login(const User(
      id: 'userId',
      username: 'username',
      password: 'password',
    ));
    FirestoreItemService.save(
      const HiderPath(),
      const Item(
        id: 'itemId',
        name: 'itemName',
        description: 'itemDescription',
        value: 'itemValue',
      ),
    );
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
    expect(find.text('Home'), findsOneWidget);
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    expect(find.text('itemValue'), findsOneWidget);
    expect(find.text('itemDescription'), findsOneWidget);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('golden/home_screen.png'),
    );
  });
}
