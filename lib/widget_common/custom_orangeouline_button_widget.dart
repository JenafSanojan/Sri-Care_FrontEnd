import 'package:flutter/material.dart';

Widget customOrangeOutlineButton({
  required VoidCallback onPress,
  String? title,
}) {
  return OutlinedButton(
    style: OutlinedButton.styleFrom(
      
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.circular(12),
      ),

      side: BorderSide(
        color: Colors.red, 
        width: 1,
      ),
    ),
    onPressed: onPress,
    child: Text(
      title!,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        color: Colors.red,
        fontSize: 12,
      ),
    ),
  );
}