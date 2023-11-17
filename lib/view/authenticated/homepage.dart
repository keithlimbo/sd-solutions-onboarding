import 'package:flutter/material.dart';
import 'package:sdsolution_onboarding/api/auth_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List?> getUserFuture = AuthRepository().getUsers();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );

          case ConnectionState.done:
            return RefreshIndicator(
              onRefresh: () async {
                getUserFuture = AuthRepository().getUsers();
                setState(() {});
              },
              child: ListView.separated(
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  final data = snapshot.data![index];
                  return ListTile(
                    title: Text(data["Name"]),
                    trailing: Icon(
                      Icons.circle,
                      color: data["IsActive"] ? Colors.green : Colors.red,
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
