import 'package:auto_route/annotations.dart';
import 'package:base_setup/data/service/navigation_service.dart';
import 'package:base_setup/data/viewmodels/register.viewmodel.dart';
import 'package:base_setup/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage(name: 'registerScreen')
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RegisterViewModel.buildWithProvider(
      builder: (_, __) {
        return const _RegisterScreen();
      },
    );
  }
}

class _RegisterScreen extends StatelessWidget {
  const _RegisterScreen();

  @override
  Widget build(BuildContext context) {
    RegisterViewModel model = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 32,
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 36.0),
                child: Center(
                  child: Text(
                    'Signals Prime',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: onSurface),
                  ),
                ),
              ),
              TextFormField(
                controller: model.nameTextEditingController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Username',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff101F5A)),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff101F5A)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff101F5A)),
                  ),
                  prefixIcon: Icon(
                    Icons.perm_identity,
                    color: onSurface,
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              // const Row(
              //   children: [
              //     SizedBox(
              //       width: 12,
              //     ),
              //     Text(
              //       'Will publicly visible. ',
              //       style: TextStyle(
              //           fontSize: 14,
              //           fontWeight: FontWeight.w700,
              //           color: Colors.grey),
              //     ),
              //     Text(
              //       'Learn more',
              //       style: TextStyle(
              //           fontSize: 14,
              //           decoration: TextDecoration.underline,
              //           decorationColor: Colors.blue,
              //           fontWeight: FontWeight.w700,
              //           color: Colors.blue),
              //     ),
              //   ],
              // ),
              const SizedBox(
                height: 32,
              ),
              TextFormField(
                controller: model.emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff101F5A)),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff101F5A)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff101F5A)),
                  ),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: onSurface,
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              TextFormField(
                obscureText: true,
                controller: model.passwordTextEditingController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Password (Ex : Test@123)',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff101F5A)),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff101F5A)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff101F5A)),
                  ),
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: onSurface,
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),

              /*TextFormField(
                controller: model.countryTextEditingController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  hintText: 'Country',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff101F5A)),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff101F5A)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff101F5A)),
                  ),
                  prefixIcon: Icon(
                    Icons.flag_outlined,
                    color: onSurface,
                  ),
                ),
              ),*/
              const SizedBox(
                height: 32,
              ),
              Row(
                children: [
                  Checkbox(
                      value: model.isCheckTerms,
                      activeColor: onSurface,
                      onChanged: (onChanged) {
                        model.updateTerms(onChanged);
                      }),
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        text: 'I confirm that I have read, understood, and agree with the ',
                        style: TextStyle(color: Colors.grey),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Terms of service ',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                          TextSpan(
                            text: 'and ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              Center(
                child: model.busy
                    ? const Center(child: CircularProgressIndicator())
                    : InkWell(
                        onTap: () {
                          if (!model.busy) model.register(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(color: onSurface, borderRadius: BorderRadius.circular(16)),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 46),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Center(
                child: Text(
                  'or',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    NavigationService.navigateToLoginScreen(context);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'If you already have an account ',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.grey),
                      ),
                      Text(
                        'Sign in',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue,
                            color: onSurface),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
