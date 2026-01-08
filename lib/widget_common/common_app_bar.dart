import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/colors.dart';

PreferredSizeWidget commonAppBar({
  required BuildContext context,
  required String title,
  List<Widget>? actions,
  bool canGoBack = true,
}) {
  return AppBar(
    backgroundColor: darkGreen,
    leading: canGoBack
        ? InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
          )
        : null,
    title: Text(
      title,
      style: const TextStyle(color: Colors.white, fontSize: 21),
    ),
    actions: actions ?? [],
  );
}
