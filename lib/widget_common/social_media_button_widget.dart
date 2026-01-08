
import 'package:flutter/material.dart';

Widget SocialMediaButton({
  required onPress,
  required color,
  required txtColor,
  required String title,
  required String imagePath, // Add this parameter for the image path
}) {
  return ElevatedButton(
    
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      
      padding: const EdgeInsets.symmetric( vertical: 5,horizontal: 17),
    ),
    onPressed: onPress,
    child: Row(
      
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Image.asset(
          imagePath,
          height: 36, // Adjust the height as needed
          width: 36, // Adjust the width as needed
        ),

        const SizedBox(width: 3), 
        // Adjust the width as needed
        Padding(
          padding: const EdgeInsets.symmetric(horizontal :2 , vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              color: txtColor,
              ),
          ),
        ),
      ],
    ),
  );
}