import 'package:flutter/material.dart';

import '../../entities/transaction.dart';
import '../../entities/transaction_type.dart';
import '../../utils/colors.dart';

class TransactionTile extends StatelessWidget {
  final TransactionItem transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    bool isCredit = transaction.type == TransactionType.credit;
    bool hasImage = transaction.imagePath != null && transaction.imagePath!.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left Icon/Image Container
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: lightYellow, // Brand cream background for icon
              borderRadius: BorderRadius.circular(12),
            ),
            child: hasImage
                ? Center(child: Icon(Icons.receipt, color: orangeColor)) // Placeholder for Image Asset
                : const Center(child: Icon(Icons.swap_horiz, color: orangeColor)),
          ),
          const SizedBox(width: 15),

          // Middle: Title & Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textColorOne,
                  ),
                ),
                if (transaction.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    transaction.description!,
                    style: const TextStyle(
                      color: greyColor,
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  transaction.date,
                  style: TextStyle(
                    color: greyColor.withValues(alpha: 0.7),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          // Right: Amount
          Text(
            "${isCredit ? '+' : '-'} \$${transaction.amount.toStringAsFixed(0)}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              // Green for Credit (Reload), Red for Debit (Spend)
              color: isCredit ? darkGreen : redBtnColor,
            ),
          ),
        ],
      ),
    );
  }
}
