import 'dart:ui';

class Package {
  final String title;
  final String description;
  final String price;
  final Color demoColor; // Used to simulate an image if you don't have assets yet // should be changed to image

  Package({
    required this.title,
    required this.description,
    required this.price,
    required this.demoColor,
  });
}