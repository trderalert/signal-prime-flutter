import 'package:base_setup/data/service/navigation_service.dart';
import 'package:base_setup/data/viewmodels/base_viewmodel.dart';
import 'package:base_setup/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginViewModel extends BaseViewModel {
  LoginViewModel();

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  ///
  static ChangeNotifierProvider<LoginViewModel> buildWithProvider({
    required Widget Function(BuildContext context, Widget? child)? builder,
    Widget? child,
  }) {
    return ChangeNotifierProvider<LoginViewModel>(
      create: (BuildContext context) => LoginViewModel(),
      builder: builder,
      lazy: false,
      child: child,
    );
  }

  login(BuildContext context) async {
    if (emailTextEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        'Please enter your Email',
      )));
      return;
    }
    if (passwordTextEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        'Please enter password',
      )));
      return;
    }

    try {
      setBusy(true);
      final credential = await auth.signInWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text,
      );

      if (credential.user != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          'Logged in successfully...',
        )));
        NavigationService.navigateToHomeScreen(context);
      }
    } on FirebaseAuthException catch (e) {
      print('${e.code}');
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          'No user found for that email.',
        )));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          'Wrong password provided for that user.',
        )));
      } else if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          'Invalid email or password.',
        )));
      }
    } catch (e) {
      debugPrint('$e');
    } finally {
      setBusy(false);
    }
  }
}
