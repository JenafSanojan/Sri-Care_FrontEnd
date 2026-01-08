import 'package:flutter/material.dart';
import 'package:sri_tel_flutter_web_mob/utils/colors.dart';
import 'package:sri_tel_flutter_web_mob/views/auth/login_screen.dart';
import 'package:get/get.dart';

import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // final controller = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const LoginScreen(); // if no user is logged in, show login screen
  }
}
