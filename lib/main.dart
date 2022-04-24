import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hider/firebase_options.dart';
import 'package:hider/screens/login/login_screen.dart';
import 'package:hider/services/navigator_key.dart';
import 'package:hider/utils/theme.dart';
import 'package:hider/widgets/hider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Hider',
        theme: lightTheme,
        darkTheme: darkTheme,
        navigatorKey: navigatorKey,
        home: const LoginScreen(),
        builder: (context, child) {
          return Hider(
            child: child!,
          );
        },
      ),
    );
  }
}
