import 'package:flutter/material.dart';

import '../utils/colors.dart';

Widget customPasswordField(
    {String? hint,
    isObscure,
    Color? fillColor,
    TextEditingController? controller,
    Function? iconCallback,
    String? title}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title != null
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                title.toString(),
                style: const TextStyle(
                  fontSize: 17,
                  color: darkGreen,
                ),
              ),
            )
          : const SizedBox(),

      Padding(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
        child: TextFormField(
          // onChanged: onChanged,
          controller: controller,
          obscureText: isObscure,
          // controller: controller,
          decoration: InputDecoration(
            hintStyle: const TextStyle(
              //fontFamily: semibold,
              fontSize: 14,
              color: hint_textColor,
            ),
            hintText: hint,
            isDense: true,
            filled: true,
            fillColor: fillColor,
            suffixIcon: InkWell(
                onTap: iconCallback != null
                    ? () {
                        iconCallback();
                      }
                    : () {},
                child: Icon(isObscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey)),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: textfield_borderlColor),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: textfield_borderlColor),
                borderRadius: BorderRadius.circular(10.0)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: textfield_borderlColor)),
          ),
        ),
      ),
      //10.heightBox,
    ],
  );
}
