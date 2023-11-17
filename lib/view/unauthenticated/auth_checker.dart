import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdsolution_onboarding/bloc/auth_bloc.dart';

import '../unauthenticated/login.dart';
import '../authenticated/wrapper.dart';

class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) {
        if (current is LoadingAuthState) {
          return false;
        }
        return true;
      },
      builder: (context, state) {
        if (state is LoadingAuthState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is AuthenticatedState) {
          return const Wrapper();
        }

        if (state is UnauthenticatedState ||
            state is RegisterSuccessState ||
            state is AuthError) {
          return const LoginPage();
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
