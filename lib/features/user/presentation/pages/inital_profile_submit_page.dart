import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chitter_chatter/features/app/const/app_const.dart';
import 'package:chitter_chatter/features/app/global/widgets/profile_widget.dart';
import 'package:chitter_chatter/features/app/home/home_page.dart';
import 'package:chitter_chatter/features/app/theme/style.dart';
import 'package:chitter_chatter/features/user/domain/entities/user_entity.dart';
import 'package:chitter_chatter/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:chitter_chatter/storage/storage_provider.dart';

class InitialProfileSubmitPage extends StatefulWidget {
  final String phoneNumber;
  const InitialProfileSubmitPage({super.key, required this.phoneNumber});

  @override
  State<InitialProfileSubmitPage> createState() =>
      _InitialProfileSubmitPageState();
}

class _InitialProfileSubmitPageState extends State<InitialProfileSubmitPage> {
  final TextEditingController _usernameController = TextEditingController();
  File? _image;

  bool _isProfileUpdating = false;

  Future selectImage() async {
    try {
      final pickedFile =
          await ImagePicker.platform.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });
    } catch (e) {
      toast("some error occured $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            const Center(
              child: Text(
                "Profile Info",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: tabColor),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Please provide your name and an optional profile photo",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(
              height: 150,
            ),
            GestureDetector(
              onTap: selectImage,
              child: SizedBox(
                width: 50,
                height: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: profileWidget(image: _image),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 40,
              margin: const EdgeInsets.only(top: 1.5),
              decoration: const BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: tabColor, width: 1.5))),
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                    hintText: "Username", border: InputBorder.none),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: submitProfileInfo,
              child: Container(
                width: 200,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple, // Start color of the gradient
                      Colors.deepPurple, // End color of the gradient
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.6),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 3), // Positioning the shadow
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    "Next",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void submitProfileInfo() {
    if (_image != null) {
      StorageProviderRemoteDataSource.uploadProfileImage(
          file: _image!,
          onComplete: (onProfileUpdateComplete) {
            setState(() {
              _isProfileUpdating = onProfileUpdateComplete;
            });
          }).then((profileImageUrl) {
        _profileInfo(profileUrl: profileImageUrl);
      });
    } else {
      _profileInfo(profileUrl: "");
    }
  }

  void _profileInfo({String? profileUrl}) {
    if (_usernameController.text.isNotEmpty) {
      BlocProvider.of<CredentialCubit>(context).submitProfileInfo(
          user: UserEntity(
        email: "",
        username: _usernameController.text,
        phoneNumber: widget.phoneNumber,
        status: " Born To Be Awesome.",
        isOnline: false,
        profileUrl: profileUrl,
      ));
    }
  }
}
