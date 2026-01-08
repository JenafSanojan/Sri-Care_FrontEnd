import 'package:flutter/material.dart';

import '../utils/colors.dart';

Widget customTextFieldWithIcon(
    {String? hint,
    TextEditingController? controller,
    Function? iconCallback,
    Widget? suffixIcon,
    final Function(String)? onChanged,
    String? title}) {
// Widget customTextFieldWithIcon({String? hint  ,isPass, TextEditingController? controller, VoidCallback? onIconPressed,}){
  return TextFormField(
    onChanged: onChanged,
    controller: controller,
    decoration: InputDecoration(
      hintStyle: const TextStyle(
        //fontFamily: semibold,
        fontSize: 13,
        color: hint_textColor,
      ),
      hintText: hint,
      isDense: true,
      suffixIcon: InkWell(
          onTap: iconCallback != null
              ? () {
                  iconCallback();
                }
              : () {},
          child: suffixIcon),

      // suffixIcon: IconButton(
      //   icon: Icon(
      //     isPass ? Icons.visibility_off : Icons.visibility,
      //     color: Colors.grey,
      //   ),
      //   onPressed: onIconPressed,
      // ),

      filled: true,
      fillColor: white,
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: textfield_borderlColor),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: textfield_borderlColor),
          borderRadius: BorderRadius.circular(10.0)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: textfield_borderlColor)),
    ),
  );
}
