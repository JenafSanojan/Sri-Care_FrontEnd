import 'package:flutter/cupertino.dart';

class CustomDropdownItem {
  final String value;
  final String label;

  CustomDropdownItem({required this.value, required this.label});

  @override
  String toString() => label;
}

class MenuItem {
  final IconData icon;
  final String title;

  MenuItem({required this.icon, required this.title});
}