import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chitter_chatter/features/app/const/app_const.dart';
import 'package:chitter_chatter/features/app/global/widgets/profile_widget.dart';
import 'package:chitter_chatter/features/user/domain/entities/user_entity.dart';
import 'package:chitter_chatter/features/user/presentation/cubit/user/user_cubit.dart';
import 'package:chitter_chatter/storage/storage_provider.dart';

class EditProfilePage extends StatefulWidget {
  final UserEntity currentUser;

  const EditProfilePage({super.key, required this.currentUser});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _aboutController = TextEditingController();

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
          print("No image selected");
        }
      });
    } catch (e) {
      toast("An error occurred: $e");
    }
  }

  @override
  void initState() {
    _usernameController =
        TextEditingController(text: widget.currentUser.username);
    _aboutController = TextEditingController(text: widget.currentUser.status);
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A), // Dark navy blue background
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF102A43), // Dark navy blue
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(75),
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(75),
                        child: profileWidget(
                          imageUrl: widget.currentUser.profileUrl,
                          image: _image,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: selectImage,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.deepPurple,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                                spreadRadius: 2,
                              )
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _profileInputField(
                controller: _usernameController,
                title: "Username",
                hint: "Enter your username",
                icon: Icons.person,
              ),
              const SizedBox(height: 20),
              _profileInputField(
                controller: _aboutController,
                title: "About",
                hint: "Say something about yourself",
                icon: Icons.info_outline,
              ),
              const SizedBox(height: 20),
              _settingsItem(
                title: "Phone Number",
                description: widget.currentUser.phoneNumber!,
                icon: Icons.phone,
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: submitProfileInfo,
                child: Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
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
                  child: _isProfileUpdating
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Center(
                          child: Text(
                            "Save Changes",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileInputField({
    required TextEditingController controller,
    required String title,
    required String hint,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 28),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              TextFormField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _settingsItem({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 28),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
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
      _profileInfo(profileUrl: widget.currentUser.profileUrl);
    }
  }

  void _profileInfo({String? profileUrl}) {
    if (_usernameController.text.isNotEmpty) {
      BlocProvider.of<UserCubit>(context)
          .updateUser(
              user: UserEntity(
        uid: widget.currentUser.uid,
        email: "",
        username: _usernameController.text,
        phoneNumber: widget.currentUser.phoneNumber,
        status: _aboutController.text,
        isOnline: false,
        profileUrl: profileUrl,
      ))
          .then((value) {
        toast("Profile updated successfully!");
      });
    }
  }
}
