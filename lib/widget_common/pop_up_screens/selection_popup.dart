import 'package:flutter/material.dart';

import '../../entities/popup_item.dart';
import '../../utils/colors.dart';

Future<int?> showSelectionPopup(BuildContext context, String title, List<PopupItem> items) async {
  return showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: lightYellow, // Brand background
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Wrap content
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColorOne,
                ),
              ),
              const SizedBox(height: 15),
              // List of Options
              ...items.map((item) {
                return GestureDetector(
                  onTap: () {
                    // Return the code when tapped
                    Navigator.of(context).pop(item.returnCode);
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: orangeColor.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(fontSize: 16, color: textColorOne),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 14, color: greyColor),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      );
    },
  );
}
