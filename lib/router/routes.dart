import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hider/screens/home/home_screen.dart';
import 'package:hider/utils/path.dart';

import '../screens/login/login_screen.dart';
import '../screens/sign_up/sign_up_screen.dart';

part 'routes.g.dart';

const authenticatedRoutes = {
  HomeRoute.path,
};

const unauthenticatedRoutes = {
  LoginRoute.path,
  SignUpRoute.path,
};

@TypedGoRoute<LoginRoute>(path: '/${LoginRoute.path}')
class LoginRoute extends GoRouteData {
  const LoginRoute();

  static const path = 'login';

  @override
  Widget build(BuildContext context) => const LoginScreen();
}

@TypedGoRoute<SignUpRoute>(path: '/${SignUpRoute.path}')
class SignUpRoute extends GoRouteData {
  const SignUpRoute();
  static const path = 'sign-up';

  @override
  Widget build(BuildContext context) => const SignUpScreen();
}

@TypedGoRoute<HomeRoute>(
  path: '/${HomeRoute.path}',
  routes: [
    TypedGoRoute<ItemRoute>(path: ItemRoute.urlPath),
  ],
)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  static const path = 'home';

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}

class ItemRoute extends GoRouteData {
  const ItemRoute(
    this.path,
  );

  final Uri path;

  static const urlPath = ':path';

  @override
  Widget build(BuildContext context) => HomeScreen(
        path: HiderPath.fromUri(path),
      );
}
