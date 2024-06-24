import 'package:auto_route/auto_route.dart';
import 'package:base_setup/application/auto_router/auto_router.gr.dart';
import 'package:base_setup/main.dart';

///
/// [AuthGuard]
///
class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (auth.currentUser != null) {
      router.pushAndPopUntil(const HomeScreen(), predicate: (_) => false);
    } else {
      resolver.next();
    }
  }
}
