import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:whatsapp_clone_app/features/app/const/page_const.dart';
import 'package:whatsapp_clone_app/features/app/global/widgets/dialog_widget.dart';
import 'package:whatsapp_clone_app/features/app/global/widgets/profile_widget.dart';
import 'package:whatsapp_clone_app/features/app/theme/style.dart';
import 'package:whatsapp_clone_app/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:whatsapp_clone_app/features/user/presentation/cubit/get_single_user/get_single_user_cubit.dart';

class SettingsPage extends StatefulWidget {
  final String uid;
  const SettingsPage({super.key, required this.uid});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade800,
        title: const Text(
          "Settings",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 4,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
              builder: (context, state) {
                if (state is GetSingleUserLoaded) {
                  final singleUser = state.singleUser;
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            PageConst.editProfilePage,
                            arguments: singleUser,
                          );
                        },
                        child: CircleAvatar(
                          radius: 32,
                          backgroundImage: NetworkImage(singleUser.profileUrl!),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              singleUser.username!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              singleUser.status!,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, PageConst.editProfilePage);
                      },
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.grey.shade700,
                        child: profileWidget(),
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "...",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "...",
                            style: TextStyle(color: greyColor),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.qr_code_2,
                      color: Colors.white.withOpacity(0.8),
                      size: 30,
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          Lottie.asset(
            'animations/logout.json', // Replace with your Lottie animation file path
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          _settingsItemWidget(
            title: "Logout",
            description: "Logout from Chitter-chatter",
            icon: Icons.exit_to_app,
            onTap: () {
              displayAlertDialog(context, onTap: () {
                BlocProvider.of<AuthCubit>(context).loggedOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  PageConst.welcomePage,
                  (route) => false,
                );
              },
                  confirmTitle: "Logout",
                  content: "Are you sure you want to logout?");
            },
          ),
        ],
      ),
    );
  }

  Widget _settingsItemWidget({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.blueGrey.shade600,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.lightBlueAccent,
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
