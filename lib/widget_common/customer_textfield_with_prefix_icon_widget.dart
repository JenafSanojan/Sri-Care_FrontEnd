import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

Widget customTextFieldWithPreIcon({String? hint  ,isPass}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      

      Padding(
        padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 20),
        child: TextFormField(
          obscureText:  isPass,
         // controller: controller,
          decoration:  InputDecoration(
            hintStyle: const TextStyle(
              //fontFamily: semibold,
              fontSize: 14,
              color: hint_textColor,
            ),
            hintText: hint,
            isDense: true,
            prefixIcon: const Icon(Icons.location_on, color: Colors.grey),
            
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: textfield_borderlColor), // Change the border color as needed
              borderRadius: BorderRadius.circular(1.0), // Adjust the radius as needed
            ),
            enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: textfield_borderlColor) , borderRadius: BorderRadius.circular(10.0)),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: textfield_borderlColor)),
          ),
      
        ),
      ),
      //10.heightBox,
    ],
    
  );
  
}