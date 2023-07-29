import 'package:go_router/go_router.dart';
import 'package:hider/router/routes.dart';
import 'package:hider/services/authentication_model.dart';
import 'package:riverpod/riverpod.dart';

/// Provides the router.
final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    routes: $appRoutes,
    refreshListenable: AuthenticationModel.instance,
    redirect: (context, state) {
      final uri = state.uri;
      if (uri.pathSegments.isNotEmpty) {
        if (AuthenticationModel.instance.value == null) {
          if (!unauthenticatedRoutes.contains(uri.pathSegments.first)) {
            return const LoginRoute().location;
          }
        } else {
          if (!authenticatedRoutes.contains(uri.pathSegments.first)) {
            return const HomeRoute().location;
          }
        }
      } else {
        if (AuthenticationModel.instance.value == null) {
          return const LoginRoute().location;
        } else {
          return const HomeRoute().location;
        }
      }
      return null;
    },
  );
  return router;
});
