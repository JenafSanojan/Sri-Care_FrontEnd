import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          fit: BoxFit.cover,
        )
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
