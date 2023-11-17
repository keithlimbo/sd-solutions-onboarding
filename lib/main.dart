import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdsolution_onboarding/view/authenticated/homepage.dart';

import 'bloc/auth_bloc.dart';
import 'view/authenticated/profile.dart';
import 'view/unauthenticated/auth_checker.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc()..add(CheckUserEvent()),
      child: MaterialApp(
        navigatorKey: MainApp.navigatorKey,
        initialRoute: '/',
        routes: {
          "/": (context) => const AuthChecker(),
          "/home": (context) => const HomePage(),
          "/profile": (context) => const ProfilePage()
        },
      ),
    );
  }
}
