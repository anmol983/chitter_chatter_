import 'dart:async';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone_app/features/app/theme/style.dart';
import 'package:whatsapp_clone_app/features/app/welcome/welcome_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const WelcomePage(),
          ),
          (route) => false,
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Image.asset(
              "assets/chat.jpeg",
              color: Colors.white,
              width: 100,
              height: 100,
            ),
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      "Chitter-chatter",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            )
          ],
        ));
  }
}
