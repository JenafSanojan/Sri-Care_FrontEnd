import 'package:flutter/material.dart';
import 'package:get/get.dart';

// background for delevery detail and Reset password screens ..............

Widget ResetBgScreens() {
  return Container(
    width: Get.width,
    height: Get.height * 0.27,
    child: Column(
      children: [
        const SizedBox(height: 100),

        SizedBox(
          height: 80,
          width: Get.width * 0.7,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: const Image(
              image: AssetImage('assets/images/Logo.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Row(
        //   children: [

        //     Container(
        //       width: 130,
        //       height: 131,
        //       child: Image.asset(
        //         "assets/images/bg_img1.png",
        //         fit: BoxFit.cover,
        //       ),
        //     ),

        //     Container(
        //       width: 130,
        //       height: 121,
        //       child: Image.asset(
        //         "assets/images/bg_img4.png",
        //         fit: BoxFit.cover,
        //       ),
        //     ),

        //     Container(
        //       width: 130,
        //       height: 121,
        //       child: Image.asset(
        //         "assets/images/bg_img5.png",
        //         fit: BoxFit.cover,
        //       ),
        //     ),
        //   ],
        // ),
      ],
    ),
  );
}
