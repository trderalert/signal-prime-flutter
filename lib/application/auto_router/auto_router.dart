import 'package:auto_route/auto_route.dart';
import 'package:base_setup/application/auto_router/app.guard.dart';

import 'auto_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          guards: [AuthGuard()],
          page: LoginScreen.page,
          initial: true,
          path: '/',
        ),
        AutoRoute(page: RegisterScreen.page),
        AutoRoute(page: HomeScreen.page),
        AutoRoute(page: NewsDetailViewScreen.page),
      ];
}
