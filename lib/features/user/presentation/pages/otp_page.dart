import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:lottie/lottie.dart';
import 'package:whatsapp_clone_app/features/app/theme/style.dart';
import 'package:whatsapp_clone_app/features/user/presentation/cubit/credential/credential_cubit.dart';

import 'inital_profile_submit_page.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const Center(
                    child: Text(
                      "Verify your OTP",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: tabColor),
                    ),
                  ),
                  Lottie.asset(
                    'animations/ottp.json', // Replace with your Lottie animation file path
                    width: 200,
                    height: 200,
                    fit: BoxFit
                        .contain, // Adjust this based on your animation's requirements
                  ),
                  _pinCodeWidget(),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _submitSmsCode,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _pinCodeWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          PinCodeFields(
            controller: _otpController,
            length: 6,
            activeBorderColor: tabColor,
            onComplete: (String pinCode) {},
          ),
          const Text("Enter your 6 digit code")
        ],
      ),
    );
  }

  void _submitSmsCode() {
    print("otpCode ${_otpController.text}");
    if (_otpController.text.isNotEmpty) {
      BlocProvider.of<CredentialCubit>(context)
          .submitSmsCode(smsCode: _otpController.text);
    }
  }
}
