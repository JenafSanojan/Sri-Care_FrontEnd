import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/bgcircle_widget.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/splashscreenlogo_widget.dart';

//background for login and sign up screens  .......................................

Widget LoginSignUpBgScreens() {
  return Container(
    width: Get.width,
    height: Get.height * 0.32,
    decoration: const BoxDecoration(
        // color: Color.fromARGB(255, 133, 26, 26),
        image: DecorationImage(
      image: AssetImage("assets/images/bg_circle2.png"),
      fit: BoxFit.fill,
    )),
    child: Column(
      children: [
        SizedBox(
          height: 90,
        ),
        SizedBox(
          height: 70,
          width: Get.width * 0.7,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: const Image(
              image: AssetImage('assets/images/Logo.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    ),
  );
}
