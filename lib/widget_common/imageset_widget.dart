import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

Widget ImageSet() {
  return Container(
    width: Get.width,
    height: Get.height * 0.15,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
    
        Container(

          height: 139,
          child: Image.asset(
            "assets/images/bg_img1.png",
            fit: BoxFit.cover,
          ),
        ),
    
        Container(

          height: 121,
          child: Image.asset(
            "assets/images/bg_img4.png",
            fit: BoxFit.cover,
          ),
        ),
    
        Container(

          height: 121,
          child: Image.asset(
            "assets/images/bg_img5.png",
            fit: BoxFit.cover,
          ),
        ),
      ],
    ),
  );
}
