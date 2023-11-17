import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sdsolution_onboarding/api/auth_api.dart';
import 'package:sdsolution_onboarding/config/validators.dart';
import 'package:sdsolution_onboarding/view/widgets/form_fields.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthRepository().getUserProfile(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );

          case ConnectionState.done:
            final data = snapshot.data;
            final createdDate = DateTime.parse(data?["CreatedDate"]);
            String formattedCreatedDate =
                DateFormat("MMMM dd, yyyy").format(createdDate);
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name: ${data?["Name"]}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Username: ${data?["Username"]}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Email: ${data?["Email"]}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "IsActive: ${data?["IsActive"]}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Created Date: $formattedCreatedDate",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  Future<Map<String, dynamic>?> getUserProfileFuture =
      AuthRepository().getUserProfile();
  bool? isActive;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: FutureBuilder(
        future: getUserProfileFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );

            case ConnectionState.done:
              final data = snapshot.data;
              nameController.text = data?["Name"];
              emailController.text = data?["Email"];
              isActive = data?["IsActive"];
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextForm(
                        controller: nameController,
                        hintText: "Full Name",
                        validator: validateName),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextForm(
                        controller: emailController,
                        hintText: "Email",
                        validator: validateEmail),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        const Text("Is Active: "),
                        Switch(
                          value: isActive ?? false,
                          onChanged: (value) {
                            isActive = value;
                            setState(() {});
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                            onPressed: () async {
                              await AuthRepository().updateUser(
                                  id: data?["Id"],
                                  name: nameController.text,
                                  isActive: isActive!,
                                  email: emailController.text);
                            },
                            child: const Text("Update")))
                  ],
                ),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
