import 'package:auto_route/auto_route.dart';
import 'package:base_setup/application/auto_router/auto_router.gr.dart';
import 'package:flutter/cupertino.dart';

class NavigationService {
  static navigateToHomeScreen(BuildContext context) {
    context.router.pushAndPopUntil(
      const HomeScreen(),
      predicate: (route) => false,
    );
  }

  static navigateToLoginScreen(BuildContext context) {
    context.router.push(const LoginScreen());
  }

  static navigateToLogin(BuildContext context) {
    context.router.pushAndPopUntil(
      const LoginScreen(),
      predicate: (route) => false,
    );
  }

  static navigateToRegisterScreen(BuildContext context) {
    context.router.push(const RegisterScreen());
  }
}
