import 'package:flutter/material.dart';

Widget LogoWidget() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(48.0),
      child: Image.asset(
        "assets/images/Logo_Only.png",
        fit: BoxFit.cover,
      ),
    ),
  );
}
