import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hider/screens/login/login_screen.dart';
import 'package:hider/services/firestore/instance.dart';

void main() {
  tearDown(() {
    FirestoreInstance.mockInstance = null;
  });
  testWidgets('It should build the login screen', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );
    expect(find.text('Hider'), findsOneWidget);
  });

  testWidgets('It should wait for 500ms when the password is incorrect', (
    tester,
  ) async {
    FirestoreInstance.mockInstance = FakeFirebaseFirestore();

    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );

    await tester.enterText(find.byType(TextFormField).first, 'email@email.com');
    await tester.enterText(find.byType(TextFormField).last, 'password');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Incorrect username or password'), findsNothing);
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Incorrect username or password'), findsOne);
  });
}
