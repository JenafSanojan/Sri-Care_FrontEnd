import 'package:flutter/cupertino.dart';

import '../../utils/colors.dart';

Widget buildFeatureItem(IconData icon, String label) {
  return Expanded(
    child: Container(
      height: 100,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: orangeColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: orangeColor, size: 30),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, color: textColorOne, fontSize: 12),
          ),
        ],
      ),
    ),
  );
}
