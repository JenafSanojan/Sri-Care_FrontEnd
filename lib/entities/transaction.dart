import 'package:sri_tel_flutter_web_mob/entities/transaction_type.dart';

class TransactionItem {
  final String title;
  final String? description;
  final String? imagePath; // Asset path or IconData could be used
  final String date;
  final TransactionType type;
  final double amount;

  TransactionItem({
    required this.title,
    this.description,
    this.imagePath,
    required this.date,
    required this.type,
    required this.amount,
  });
}