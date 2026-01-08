import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sri_tel_flutter_web_mob/utils/colors.dart';

Widget CustomOrangeFillButton({
  required VoidCallback onPress,
  String? title,
  Color? color
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color ?? orangeColor,
      elevation: 0.1,
      padding: const EdgeInsets.symmetric(vertical: 12 , horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      
    ),
    onPressed: onPress, // Use the provided onPressed callback
    child: AutoSizeText(
      title!,
      presetFontSizes: [12,11,10,9,8,7],
      style: const TextStyle(
        fontWeight: FontWeight.normal,
        color: white,
        fontSize: 12
      ),
      maxLines: 1,
    ),
  );
}