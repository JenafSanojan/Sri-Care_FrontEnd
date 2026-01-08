import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sri_tel_flutter_web_mob/entities/common.dart';

import '../utils/colors.dart';

Widget DropDawnButton(
    {TextEditingController? controller,
    TextEditingController? nameController,
    Color? fillColor,
    List<String>? listItems,
    List<CustomDropdownItem>? customListItems,
    required String hintText,
    Function? validation,
    bool isEmphasis = false,
    Function? action,
    FocusNode? focusNode,
    String? value}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
    child: DropdownButtonFormField2<String>(
      focusNode: focusNode,
      style: TextStyle(
        color: Colors.black,
        fontSize: isEmphasis ? 20 : 14,
        fontWeight: isEmphasis ? FontWeight.bold : FontWeight.normal,
      ),
      isExpanded: false,
      // onSaved: ,
      value: value,
      decoration: InputDecoration(
        hintStyle: TextStyle(
          color: isEmphasis ? Colors.white : hint_textColor,
          fontSize: isEmphasis ? 20 : 15,
          fontWeight: isEmphasis ? FontWeight.bold : FontWeight.normal,
        ),
        hintText: hintText,
        isDense: true,
        filled: true,
        fillColor: fillColor ?? (isEmphasis ? orangeColor : fillColor),
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
      hint: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: AutoSizeText(
          hintText,
          style: TextStyle(
            fontSize: isEmphasis ? 20 : 14,
            overflow: TextOverflow.fade,
            color: isEmphasis ? Colors.white : Colors.black,
          ),
          maxLines: 1,
          minFontSize: 5,
          presetFontSizes: [12, 8, 6],
        ),
      ),

      items: listItems != null
          ? listItems
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: AutoSizeText(
                      item,
                      style: const TextStyle(
                          fontSize: 14, overflow: TextOverflow.fade),
                      maxLines: 1,
                      presetFontSizes: [12, 11, 10],
                      minFontSize: 5,
                    ),
                  ))
              .toList()
          : customListItems!
              .map((item) => DropdownMenuItem<String>(
                    value: item.value,
                    child: AutoSizeText(
                      item.label,
                      style: const TextStyle(
                          fontSize: 14, overflow: TextOverflow.fade),
                      maxLines: 1,
                      presetFontSizes: [12, 11, 10],
                      minFontSize: 5,
                    ),
                  ))
              .toList(),
      onChanged: action == null
          ? (value) {
              controller?.text = value ?? '';
            }
          : (value) {
              controller?.text = value ?? '';
              // Set the label to the nameController
              if (nameController != null) {
                if (customListItems != null) {
                  final selectedCustomItem = customListItems
                      .firstWhereOrNull((item) => item.value == value);
                  nameController.text = selectedCustomItem?.label ?? '';
                } else if (listItems != null) {
                  // If using simple listItems, the value and label are the same
                  nameController.text = value ?? '';
                }
              }
              action.call(value);
            },
      buttonStyleData: const ButtonStyleData(
          //padding: EdgeInsets.only(right: 8),
          ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          //color: textGreenColor
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 5),
      ),
      validator: (validation as String? Function(String?)?),
    ),
  );
}

// Widget DropDawnButtonExtraCustom(
//     {TextEditingController? controller,
//     required List<String> listItems,
//     required String hintText,
//     Function? onChanged,
//     String? value,
//     Color color = Colors.black}) {
//   return DropdownButtonFormField2<String>(
//     // style: TextStyle(
//     //   color: color
//     // ),
//     isExpanded: true,
//     // onSaved: ,
//     value: value,
//     decoration: InputDecoration(
//       fillColor: Colors.white,
//       hintText: hintText,
//       // Add Horizontal padding using menuItemStyleData.padding so it matches
//       // the menu padding when button's width is not specified.
//       contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: textfield_borderlColor, width: 1),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(15),
//         borderSide: const BorderSide(color: textfield_borderlColor, width: 2),
//       ),
//       // Add more decoration..
//     ),
//     hint: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 5),
//       child: AutoSizeText(
//         hintText,
//         style: const TextStyle(fontSize: 14, overflow: TextOverflow.fade),
//         maxLines: 1,
//         minFontSize: 5,
//       ),
//     ),
//     items: listItems
//         .map((item) => DropdownMenuItem<String>(
//               value: item,
//               child: AutoSizeText(
//                 item,
//                 style:
//                     const TextStyle(fontSize: 9, overflow: TextOverflow.fade),
//                 maxLines: 1,
//                 minFontSize: 5,
//               ),
//             ))
//         .toList(),
//     onChanged: (value) {
//       controller?.text = value!;
//     },
//     buttonStyleData: const ButtonStyleData(
//         //padding: EdgeInsets.only(right: 8),
//         ),
//     iconStyleData: const IconStyleData(
//       icon: Icon(
//         Icons.arrow_drop_down,
//         color: Colors.black45,
//       ),
//       iconSize: 14,
//     ),
//     dropdownStyleData: DropdownStyleData(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//
//         //color: textGreenColor
//       ),
//     ),
//     menuItemStyleData: const MenuItemStyleData(
//       padding: EdgeInsets.symmetric(horizontal: 5),
//     ),
//   );
// }

// Widget EditDropDawnButton ({TextEditingController? controller,required List<String> listItems}){
//   return DropdownButtonFormField2<String>(
//     isExpanded: false,
//     decoration: InputDecoration(
//       fillColor: Colors.white,
//       // Add Horizontal padding using menuItemStyleData.padding so it matches
//       // the menu padding when button's width is not specified.
//       contentPadding: const EdgeInsets.symmetric(
//           vertical: 6, horizontal: 5),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(
//             color: textfield_borderlColor, width: 1
//         ),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(15),
//         borderSide: const BorderSide(
//             color: textfield_borderlColor, width: 3
//         ),
//       ),
//       // Add more decoration..
//     ),
//     hint: const Padding(
//       padding: EdgeInsets.symmetric(horizontal: 10),
//       child: Text(
//         "-----",
//         style: TextStyle(fontSize: 14),
//       ),
//     ),
//     items: listItems
//         .map((item) => DropdownMenuItem<String>(
//       value: item,
//       child: Text(
//         item,
//         style: const TextStyle(
//           fontSize: 14,
//         ),
//       ),
//     ))
//         .toList(),
//     onChanged: (value) {
//       controller?.text = value!;
//     },
//     buttonStyleData: const ButtonStyleData(
//       //padding: EdgeInsets.only(right: 8),
//     ),
//     iconStyleData: const IconStyleData(
//       icon: Icon(
//         Icons.arrow_drop_down,
//         color: Colors.black45,
//       ),
//       iconSize: 24,
//     ),
//     dropdownStyleData: DropdownStyleData(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//
//         //color: textGreenColor
//       ),
//     ),
//     menuItemStyleData: const MenuItemStyleData(
//       padding: EdgeInsets.symmetric(horizontal: 10),
//     ),
//     value: controller?.text.toString(),
//   );
// }
