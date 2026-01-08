import 'package:flutter/material.dart';

import '../utils/colors.dart';

Widget customButton({
  required VoidCallback onPress, // Change the type to VoidCallback
  required Color color,
  required Color txtColor,
  String? title,
}) {
  return ElevatedButton(

    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      elevation: 0.1,
      padding: const EdgeInsets.symmetric(vertical: 10 , horizontal: 27),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

    ),
    onPressed: onPress, // Use the provided onPressed callback
    child: Text(
      title! ,
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: white,
          fontSize: 19
      ),
    ),
  );
}