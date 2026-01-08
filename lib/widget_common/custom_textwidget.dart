import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sri_tel_flutter_web_mob/utils/string.dart';

import '../utils/colors.dart';

Widget customTextField(
    {String? hint,
    bool isPass = false,
    Color? fillColor,
    TextEditingController? controller,
    bool isNumeric = false,
    bool isDate = false,
    bool isMust = false,
    String? title,
    FocusNode? focusNode,
    Function? validation}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      double screenWidth = MediaQuery.of(context).size.width;
      double fieldWidth = screenWidth; // Default width for medium devices

      // if (screenWidth < 600) {
      //   // Small devices (phones)
      //   fieldWidth = screenWidth;
      // } else if (screenWidth < 1024) {
      //   // Medium devices (tablets)
      //   fieldWidth = screenWidth / 2;
      // } else {
      //   // Large devices (laptops/desktops)
      //   fieldWidth = screenWidth / 4;
      // }

      return SizedBox(
        width: fieldWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  title.toString(),
                  style: const TextStyle(
                    fontSize: 17,
                    color: darkGreen,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
              child: TextFormField(
                focusNode: focusNode,
                validator: validation != null
                    ? (validation as String? Function(String?)?)
                    : (value) {
                        if (isMust && (value == null || value.trim().isEmpty)) {
                          return 'Required field. Please enter a valid input.';
                        }
                        return null;
                      },
                controller: controller,
                obscureText: isPass,
                keyboardType: isNumeric
                    ? TextInputType.number
                    : isDate
                        ? TextInputType.datetime
                        : TextInputType.text,
                decoration: InputDecoration(
                  hintStyle: const TextStyle(
                    color: hint_textColor,
                    fontSize: 15,
                  ),
                  hintText: hint,
                  isDense: true,
                  filled: true,
                  fillColor: fillColor,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.amberAccent),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: textfield_borderlColor),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: textfield_borderlColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class MonthYearInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length == 3 && oldValue.text.length == 2) {
      // Insert a slash when the user enters the third character
      final newText = newValue.text.replaceRange(2, 3, '/');
      return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
    return newValue;
  }
}

Widget customNewTextField({
  String? hint,
  bool isPass = false,
  Color? fillColor,
  TextEditingController? controller,
  bool isNumeric = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
        child: TextFormField(
          controller: controller,
          obscureText: isPass,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          inputFormatters: isNumeric
              ? <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  if (hint == "MM/YY") MonthYearInputFormatter(),
                ]
              : null,
          decoration: InputDecoration(
            hintStyle: const TextStyle(
              color: hint_textColor,
              fontSize: 15,
            ),
            hintText: hint,
            isDense: true,
            filled: true,
            fillColor: fillColor,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.amberAccent),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: textfield_borderlColor),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: textfield_borderlColor),
            ),
          ),
        ),
      ),
    ],
  );
}
