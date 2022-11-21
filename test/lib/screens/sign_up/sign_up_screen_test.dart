import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hider/screens/sign_up/sign_up_screen.dart';

void main() {
  testWidgets('It should build the sign up screen', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SignUpScreen(),
        ),
      ),
    );
    expect(find.text('Hider'), findsOneWidget);
  });
}
