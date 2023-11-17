import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdsolution_onboarding/bloc/auth_bloc.dart';
import 'package:sdsolution_onboarding/view/authenticated/homepage.dart';
import 'package:sdsolution_onboarding/view/authenticated/profile.dart';
import 'package:sdsolution_onboarding/view/unauthenticated/auth_checker.dart';
import 'package:sdsolution_onboarding/view/widgets/drawer.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final pageController = PageController();
  ValueNotifier<String> titleNotifier = ValueNotifier<String>("Home");
  ValueNotifier<bool> fabNotifier = ValueNotifier<bool>(false);
  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      if (pageController.page == 0) {
        titleNotifier.value = "Home";
        fabNotifier.value = false;
      }
      if (pageController.page == 1) {
        titleNotifier.value = "Profile";
        fabNotifier.value = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UnauthenticatedState) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const AuthChecker(),
              ),
              ModalRoute.withName('/'));
        }
      },
      child: Scaffold(
        drawer: CustomDrawer(pageController: pageController),
        appBar: AppBar(
          title: ValueListenableBuilder(
              valueListenable: titleNotifier,
              builder: (context, value, child) => Text(value)),
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: const [HomePage(), ProfilePage()],
        ),
        floatingActionButton: ValueListenableBuilder(
            valueListenable: fabNotifier,
            builder: (context, value, child) {
              return value
                  ? FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ));
                      },
                      child: const Icon(Icons.edit),
                    )
                  : const SizedBox.shrink();
            }),
      ),
    );
  }
}
