import 'package:flutter/material.dart';

import '../../utils/colors.dart';

Widget buildCircularIndicator(
    {required String title,
    required String value,
    required String unit,
    required double percent,
    double? height,
    double? width}) {
  return Column(
    children: [
      SizedBox(
        height: height ?? 110,
        width: width ?? 110,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Circle (Track)
            const CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 10,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEEEEEE)),
            ),
            // Progress Circle
            CircularProgressIndicator(
              value: percent,
              strokeWidth: 10,
              strokeCap: StrokeCap.round,
              valueColor: const AlwaysStoppedAnimation<Color>(orangeColor),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: textColorOne)),
                  Text(unit, style: const TextStyle(fontSize: 12, color: greyColor)),
                ],
              ),
            )
          ],
        ),
      ),
      if(title.isNotEmpty) ...{
        const SizedBox(height: 10),
        Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: textColorOne)),
      }
    ],
  );
}
