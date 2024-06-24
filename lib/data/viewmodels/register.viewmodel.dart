import 'dart:collection';

import 'package:base_setup/data/service/navigation_service.dart';
import 'package:base_setup/data/viewmodels/base_viewmodel.dart';
import 'package:base_setup/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterViewModel extends BaseViewModel {
  RegisterViewModel();

  bool isCheckTerms = false;
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController countryTextEditingController = TextEditingController();

  ///
  static ChangeNotifierProvider<RegisterViewModel> buildWithProvider({
    required Widget Function(BuildContext context, Widget? child)? builder,
    Widget? child,
  }) {
    return ChangeNotifierProvider<RegisterViewModel>(
      create: (BuildContext context) => RegisterViewModel(),
      builder: builder,
      lazy: false,
      child: child,
    );
  }

  register(BuildContext context) async {
    if (nameTextEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        'Please enter your name',
      )));
      return;
    }
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
    if (!isCheckTerms) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        'Please check the Terms and Conditions',
      )));
      return;
    }

    try {
      setBusy(true);
      final credential = await auth.createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text,
      );
      if (credential.user != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          'Registered successfully...',
        )));

        final map = HashMap<String, dynamic>();
        map['id'] = credential.user!.uid.toString();
        map['name'] = nameTextEditingController.text.toString();
        map['country'] = countryTextEditingController.text.toString();
        map['created'] = Timestamp.now();

        await FirebaseFirestore.instance.collection('users').add(map);
        NavigationService.navigateToLogin(context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          'The password provided is too weak.',
        )));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          'The account already exists for that email.',
        )));
      }
    } catch (e) {
      debugPrint('$e');
    } finally {
      setBusy(false);
    }
  }

  void updateTerms(bool? checked) {
    isCheckTerms = checked ?? false;
    notifyListeners();
  }
}
