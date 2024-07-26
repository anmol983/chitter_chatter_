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
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          Card(
            elevation: 2,
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
                builder: (context, state) {
                  if (state is GetSingleUserLoaded) {
                    final singleUser = state.singleUser;
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, PageConst.editProfilePage,
                                arguments: singleUser);
                          },
                          child: SizedBox(
                            width: 65,
                            height: 65,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(32.5),
                              child: profileWidget(
                                  imageUrl: singleUser.profileUrl),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${singleUser.username}",
                                style: const TextStyle(fontSize: 15),
                              ),
                              Text(
                                "${singleUser.status}",
                                style: const TextStyle(color: greyColor),
                              )
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
                          Navigator.pushNamed(
                              context, PageConst.editProfilePage);
                        },
                        child: SizedBox(
                          width: 65,
                          height: 65,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32.5),
                            child: profileWidget(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "...",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              "...",
                              style: TextStyle(color: greyColor),
                            )
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.qr_code_sharp,
                        color: tabColor,
                      )
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Container(
            width: double.infinity,
            height: 0.5,
            color: greyColor.withOpacity(.4),
          ),
          const SizedBox(
            height: 10,
          ),
          Lottie.asset(
            'animations/logout.json', // Replace with your Lottie animation file path
            width: 200,
            height: 200,
            fit: BoxFit
                .contain, // Adjust this based on your animation's requirements
          ),
          _settingsItemWidget(
              title: "Logout",
              description: "Logout from Chitter-chatter",
              icon: Icons.exit_to_app,
              onTap: () {
                displayAlertDialog(context, onTap: () {
                  BlocProvider.of<AuthCubit>(context).loggedOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, PageConst.welcomePage, (route) => false);
                },
                    confirmTitle: "Logout",
                    content: "Are you sure you want to logout?");
              }),
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
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Icon(
              icon,
              color: greyColor,
              size: 25,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 17),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  description,
                  style: const TextStyle(color: greyColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
