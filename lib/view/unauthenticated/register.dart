import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdsolution_onboarding/main.dart';
import 'package:sdsolution_onboarding/view/widgets/form_fields.dart';

import '../../bloc/auth_bloc.dart';
import '../../config/call_bloc.dart';
import '../../config/validators.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            Navigator.of(context).pop();
          }

          if (state is AuthError) {
            final snackBar = SnackBar(
              content: Text(state.errorMsg),
            );
            ScaffoldMessenger.of(MainApp.navigatorKey.currentContext!)
                .showSnackBar(snackBar);
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
                    height: 12,
                  ),
                  CustomTextForm(
                    controller: nameController,
                    hintText: "Full Name",
                    validator: validateName,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextForm(
                    controller: emailController,
                    hintText: "Email",
                    validator: validateEmail,
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          authBloc.add(RegisterEvent(
                              usernameController.text,
                              passwordController.text,
                              emailController.text,
                              nameController.text));
                        }
                      },
                      child: const Text("REGISTER")),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
