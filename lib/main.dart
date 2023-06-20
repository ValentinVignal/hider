import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:hider/firebase_options.dart';
import 'package:hider/utils/theme.dart';
import 'package:hider/widgets/hider.dart';

import 'router/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
  );
  usePathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;

  runApp(
    const ProviderScope(
      child: HiderApp(),
    ),
  );
}

class HiderApp extends ConsumerWidget {
  const HiderApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      title: 'Hider',
      theme: lightTheme,
      darkTheme: darkTheme,
      builder: (context, child) {
        return Hider(
          child: child!,
        );
      },
    );
  }
}
