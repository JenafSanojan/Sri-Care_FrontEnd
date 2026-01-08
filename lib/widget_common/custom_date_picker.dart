import 'package:flutter/material.dart';

import '../utils/colors.dart';

class CustomDatePickerButton extends StatelessWidget {
  final String dateText;
  final VoidCallback onTap;

  const CustomDatePickerButton({
    super.key,
    required this.dateText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: orangeColor.withValues(alpha: 0.3)), // Subtle orange border
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dateText,
              style: const TextStyle(
                color: textColorOne,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_down, color: orangeColor, size: 20),
          ],
        ),
      ),
    );
  }
}
