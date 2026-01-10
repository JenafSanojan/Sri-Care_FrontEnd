import 'package:flutter/material.dart';

class ServiceModel {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final double price; // Monthly or One-time
  bool isActive;

  ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.price,
    this.isActive = false,
  });
}