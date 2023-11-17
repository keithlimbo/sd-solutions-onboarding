import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sdsolution_onboarding/api/auth_api.dart';
import 'package:sdsolution_onboarding/config/validators.dart';
import 'package:sdsolution_onboarding/view/widgets/form_fields.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? getUserProfileData;
  bool isActive = false;
  late Future<Map<String, dynamic>?> getUserDataFuture = getUserData();

  Future<Map<String, dynamic>?> getUserData() async {
    getUserProfileData = await AuthRepository().getUserProfile();
    setState(() {
      isActive = getUserProfileData?["IsActive"];
    });

    return getUserProfileData;
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        getUserDataFuture = getUserData();
        setState(() {});
      },
      child: FutureBuilder(
        future: getUserDataFuture,
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
              return ListView(
                padding: const EdgeInsets.all(24.0),
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
                  Row(
                    children: [
                      const Text(
                        "IsActive: ",
                        style: TextStyle(fontSize: 18),
                      ),
                      Switch(
                          value: isActive,
                          onChanged: (val) async {
                            await AuthRepository()
                                .updateStatus(data?["Id"], val);
                            setState(() {
                              isActive = val;
                            });
                          })
                    ],
                  ),
                  Text(
                    "Created Date: $formattedCreatedDate",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
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
  Map<String, dynamic>? userProfile;

  getUserProfile() async {
    userProfile = await AuthRepository().getUserProfile();
    nameController.text = userProfile?["Name"];
    emailController.text = userProfile?["Email"];
  }

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
        ),
        body: Padding(
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
              const SizedBox(
                height: 24,
              ),
              Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      onPressed: () async {
                        await AuthRepository().updateUser(
                            id: userProfile?["Id"],
                            name: nameController.text,
                            isActive: userProfile?["IsActive"],
                            email: emailController.text);
                        if (mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text("Update")))
            ],
          ),
        ));
  }
}
