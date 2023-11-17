import 'package:flutter/material.dart';
import 'package:sdsolution_onboarding/api/auth_api.dart';

import '../../bloc/auth_bloc.dart';
import '../../config/call_bloc.dart';

class CustomDrawer extends StatefulWidget {
  final PageController pageController;
  const CustomDrawer({super.key, required this.pageController});

  @override
  State<CustomDrawer> createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> {
  Future<Map<String, dynamic>?> getUserProfileFuture =
      AuthRepository().getUserProfile();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FutureBuilder(
              future: getUserProfileFuture,
              builder: (context, snapshot) {
                return DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue[300]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data?["Name"] ?? "",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        snapshot.data?["Email"] ?? "",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                );
              }),
          ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              ListTile(
                onTap: () {
                  widget.pageController.jumpToPage(0);
                  Navigator.of(context).pop();
                },
                leading: const Icon(Icons.home),
                title: const Text("Home"),
              ),
              ListTile(
                onTap: () {
                  widget.pageController.jumpToPage(1);
                  Navigator.of(context).pop();
                },
                leading: const Icon(Icons.person),
                title: const Text("Profile"),
              ),
            ],
          ),
          const Spacer(),
          TextButton.icon(
              onPressed: () {
                authBloc.add(LogoutEvent());
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"))
        ],
      ),
    );
  }
}
