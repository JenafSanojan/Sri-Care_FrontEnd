import 'package:flutter/material.dart';

import '../../entities/transaction.dart';
import '../../entities/transaction_type.dart';
import '../../utils/colors.dart';
import '../../widget_common/custom_date_picker.dart';
import '../../widget_common/special/transaction_tile.dart';

class BillingHistoryScreen extends StatefulWidget {
  const BillingHistoryScreen({super.key});

  @override
  State<BillingHistoryScreen> createState() => _BillingHistoryScreenState();
}

class _BillingHistoryScreenState extends State<BillingHistoryScreen> {
  // Dummy Data
  final List<TransactionItem> transactions = [
    TransactionItem(
      title: "Reload",
      date: "01 Mar 2026",
      type: TransactionType.credit,
      amount: 16,
    ),
    TransactionItem(
      title: "Netflix",
      description: "Entertainment",
      imagePath: "assets/netflix.png", // Example path
      date: "05 Mar 2026",
      type: TransactionType.debit,
      amount: 12,
    ),
    TransactionItem(
      title: "PlayStation Plus",
      description: "Gaming Subscription",
      imagePath: "assets/ps.png",
      date: "12 Mar 2026",
      type: TransactionType.debit,
      amount: 5,
    ),
    TransactionItem(
      title: "YouTube Music",
      description: "Music",
      imagePath: "assets/yt.png",
      date: "15 Mar 2026",
      type: TransactionType.debit,
      amount: 10,
    ),
    TransactionItem(
      title: "Data Top-up",
      description: "1GB Add-on",
      imagePath: "",
      date: "20 Mar 2026",
      type: TransactionType.debit,
      amount: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightYellow, // Brand Cream Background
      appBar: AppBar(
        backgroundColor: lightYellow,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: textColorOne),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Billing History",
          style: TextStyle(color: textColorOne, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // --- Date Picker Row ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomDatePickerButton(
                  dateText: "01 Mar 2026",
                  onTap: () {
                    // Logic to pick From date
                  },
                ),
                const Icon(Icons.arrow_forward, color: greyColor, size: 20),
                CustomDatePickerButton(
                  dateText: "31 Mar 2026",
                  onTap: () {
                    // Logic to pick To date
                  },
                ),
              ],
            ),

            const SizedBox(height: 25),

            // --- Total Spent Summary Card ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: orangeColor.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: const [
                  Text(
                    "\$29", // Calculated total based on visible transactions
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: textColorOne,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Total Spent",
                    style: TextStyle(
                      color: greyColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --- Transactions Header ---
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Transactions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColorOne,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // --- Transaction List ---
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                padding: const EdgeInsets.only(bottom: 20),
                itemBuilder: (context, index) {
                  return TransactionTile(transaction: transactions[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}