import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:whatsapp_clone_app/features/app/const/app_const.dart';
import 'package:whatsapp_clone_app/features/app/home/home_page.dart';
import 'package:whatsapp_clone_app/features/app/theme/style.dart';
import 'package:whatsapp_clone_app/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:whatsapp_clone_app/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:whatsapp_clone_app/features/user/presentation/pages/inital_profile_submit_page.dart';
import 'package:whatsapp_clone_app/features/user/presentation/pages/otp_page.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  String _initialCountry = 'IN';
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'IN');

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CredentialCubit, CredentialState>(
      listener: (context, credentialListenerState) {
        if (credentialListenerState is CredentialSuccess) {
          BlocProvider.of<AuthCubit>(context).loggedIn();
        }
        if (credentialListenerState is CredentialFailure) {
          toast("Something went wrong");
        }
      },
      builder: (context, credentialBuilderState) {
        if (credentialBuilderState is CredentialLoading) {
          return const Center(
            child: CircularProgressIndicator(color: tabColor),
          );
        }
        if (credentialBuilderState is CredentialPhoneAuthSmsCodeReceived) {
          return const OtpPage();
        }
        if (credentialBuilderState is CredentialPhoneAuthProfileInfo) {
          return InitialProfileSubmitPage(phoneNumber: _phoneController.text);
        }
        if (credentialBuilderState is CredentialSuccess) {
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              if (authState is Authenticated) {
                return HomePage(uid: authState.uid);
              }
              return _bodyWidget();
            },
          );
        }
        return _bodyWidget();
      },
    );
  }

  Widget _bodyWidget() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  const Center(
                    child: Text(
                      "Verify your phone number",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: tabColor),
                    ),
                  ),
                  Lottie.asset(
                    'animations/callp2.json', // Replace with your Lottie animation file path
                    width: 200,

                    height: 200,
                    fit: BoxFit
                        .contain, // Adjust this based on your animation's requirements
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      _phoneNumber = number;
                    },
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.DROPDOWN,
                    ),
                    initialValue: _phoneNumber,
                    textFieldController: _phoneController,
                    formatInput: false,
                    maxLength: 15,
                    inputDecoration: const InputDecoration(
                      hintText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.5),
                      ),
                    ),
                    selectorTextStyle: const TextStyle(
                        color: Color.fromARGB(255, 239, 237, 237)),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _submitVerifyPhoneNumber,
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

  void _submitVerifyPhoneNumber() {
    if (_phoneController.text.isNotEmpty) {
      String phoneNumber = _phoneNumber.phoneNumber!;
      print("phoneNumber $phoneNumber");
      BlocProvider.of<CredentialCubit>(context).submitVerifyPhoneNumber(
        phoneNumber: phoneNumber,
      );
    } else {
      toast("Enter your phone number");
    }
  }
}
