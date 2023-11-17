import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdsolution_onboarding/bloc/auth_bloc.dart';
import 'package:sdsolution_onboarding/config/call_bloc.dart';
import 'package:sdsolution_onboarding/config/validators.dart';
import 'package:sdsolution_onboarding/view/authenticated/wrapper.dart';
import 'package:sdsolution_onboarding/view/unauthenticated/register.dart';

import '../widgets/form_fields.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("SD SOLUTIONS"),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthenticatedState) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const Wrapper(),
            ));
          }

          if (state is AuthError) {
            final snackBar = SnackBar(
              content: Text(state.errorMsg),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
          if (state is LoadingAuthState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 10),
              child: Column(
                children: [
                  CustomTextForm(
                    controller: usernameController,
                    hintText: "Username",
                    validator: validateEmpty,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextForm(
                    controller: passwordController,
                    hintText: "Password",
                    validator: validateEmpty,
                    isPassword: true,
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          authBloc.add(LoginEvent(usernameController.text,
                              passwordController.text));
                        }
                      },
                      child: const Text("LOG IN")),
                  const Spacer(
                    flex: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ));
                          },
                          child: const Text("Create an account"))
                    ],
                  ),
                  const Spacer(
                    flex: 1,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
