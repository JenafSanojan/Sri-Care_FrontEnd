import 'package:flutter/material.dart';
import 'package:sri_tel_flutter_web_mob/views/auth/login_screen.dart';
import 'package:get/get.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/responsive-layout.dart';
import '../../controllers/auth_controller.dart';
import '../../widget_common/splashscreen_widget.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final controller = Get.put(AuthController());

  @override
  void initState() {
    super.initState();

    // Schedule the check to run AFTER the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      additionalUserCheck();
    });
  }

  Future<void> additionalUserCheck() async {
    // A small artificial delay for the splash effect
    await Future.delayed(const Duration(seconds: 2));

    if (await controller.isLocalLoginRecordsExist()) {
      await controller.reVerifyLogin();
      Get.offAll(() => const MainScreen(), transition: Transition.fadeIn);
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold
      (
        body: Center(
            child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                    color: Colors.blue, strokeWidth: 10.0)
            )
        ));
  }
}
