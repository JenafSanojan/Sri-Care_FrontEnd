import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sri_tel_flutter_web_mob/utils/colors.dart';
import 'splashscreenlogo_widget.dart';

class SplashScreenWidget extends StatelessWidget {
  const SplashScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      //...............................................
      width: Get.width,
      height: Get.height,

      decoration: const BoxDecoration(
        color: Colors.white,
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //main logo .............................................
          LogoWidget(),
        ],
      ),
    );
  }
}
