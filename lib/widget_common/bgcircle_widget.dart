import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget BackgroundCircleView(){
  return Container(
    width: Get.width,
    height: Get.height,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image:  AssetImage("assets/images/bg_circle.png"),
          fit: BoxFit.cover,
      ),
    ),
  );
}