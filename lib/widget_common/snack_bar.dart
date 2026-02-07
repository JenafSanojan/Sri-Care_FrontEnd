import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonLoaders{

  static void successSnackBar({
    required String title,
    String message = '',
    dynamic duration = 3
  }){
    Get.snackbar(
        title,
        message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: Colors.white,
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: duration),
        margin: EdgeInsets.all(10),
        icon: Icon(Icons.check, color: Colors.white,)
    );
  }

  static void errorSnackBar({
    required String title,
    String message = '',
    dynamic duration = 3
  }){
    Get.snackbar(
        title,
        message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: duration),
        margin: const EdgeInsets.all(10),
        icon: const Icon(Icons.dangerous, color: Colors.white,)
    );
  }

  static void warningSnackBar({
    required String title,
    String message = '',
    dynamic duration = 3
  }){
    Get.snackbar(
        title,
        message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: Colors.white,
        backgroundColor: Color.fromARGB(255, 254, 178, 90),
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: duration),
        margin: EdgeInsets.all(10),
        icon: Icon(Icons.warning, color: Colors.white,)
    );
  }

}