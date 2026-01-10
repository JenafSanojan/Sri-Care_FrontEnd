import 'package:flutter/material.dart';
import 'package:sri_tel_flutter_web_mob/entities/packageBilling/bill.dart';
import 'package:sri_tel_flutter_web_mob/utils/colors.dart'; // Your brand colors
import 'package:sri_tel_flutter_web_mob/views/billing/payment_screen.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/responsive-layout.dart';
import 'package:get/get.dart';

import '../../services/billing_service.dart'; // For payment navigation

class PendingBillsScreen extends StatefulWidget {
  final bool dontShowBackButton;
  const PendingBillsScreen(
      {super.key, this.dontShowBackButton = false,});


  @override
  State<PendingBillsScreen> createState() => _PendingBillsScreenState();
}

class _PendingBillsScreenState extends State<PendingBillsScreen> {
  final BillingService _billingService = BillingService();

  List<Bill> _pendingBills = [];
  bool _isLoading = true;
  double _totalOutstanding = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchBills();
  }

  Future<void> _fetchBills() async {
    setState(() => _isLoading = true);

    final allBills = await _billingService.getUserBills();

    if (mounted) {
      if (allBills != null) {
        // Filter for bills that are NOT paid
        // Adjust status strings based on your actual API response (e.g., "PENDING", "Overdue")
        final unpaid = allBills.where((bill) {
          final status = bill.status.toUpperCase();
          return status != 'PAID' && status != 'COMPLETED';
        }).toList();

        // Sort: Overdue/Oldest first
        unpaid.sort((a, b) => (a.createdAt ?? DateTime.now()).compareTo(b.createdAt ?? DateTime.now()));

        setState(() {
          _pendingBills = unpaid;
          _totalOutstanding = unpaid.fold(0, (sum, item) => sum + item.amount);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handlePayBill(Bill bill) {
    Get.to(() => PaymentScreen(bill: bill));
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: _buildContent(isWeb: false),
      webBody: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: _buildContent(isWeb: true),
        ),
      ),
    );
  }

  Widget _buildContent({required bool isWeb}) {
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        backgroundColor: logo_back,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textColorOne),
          onPressed: () => Get.back(),
        ),
        title: const Text("Pending Payments",
            style: TextStyle(color: textColorOne, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: orangeColor))
          : RefreshIndicator(
        color: orangeColor,
        onRefresh: _fetchBills,
        child: Column(
          children: [
            // --- 1. TOTAL OUTSTANDING SUMMARY ---
            if (_pendingBills.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [orangeColor, textLightGreenColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: orangeColor.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Total Outstanding",
                      style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "LKR ${_totalOutstanding.toStringAsFixed(2)}",
                      style: const TextStyle(color: white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${_pendingBills.length} Bills Due",
                        style: const TextStyle(color: white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

            // --- 2. BILL LIST ---
            Expanded(
              child: _pendingBills.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: _pendingBills.length,
                itemBuilder: (context, index) {
                  return _buildBillCard(_pendingBills[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillCard(Bill bill) {
    bool isOverdue = bill.status.toUpperCase() == 'OVERDUE';
    Color statusColor = isOverdue ? Colors.red : orangeColor;

    // Formatting date (Using basic string splitting if intl not available, or simpler logic)
    String dateStr = bill.createdAt != null
        ? "${bill.createdAt!.year}-${bill.createdAt!.month.toString().padLeft(2, '0')}-${bill.createdAt!.day.toString().padLeft(2, '0')}"
        : "Unknown Date";

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: isOverdue ? Border.all(color: Colors.red.withValues(alpha: 0.3), width: 1) : null,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Month & ID
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bill.billingMonth.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColorOne),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Bill #${bill.id.substring(bill.id.length - 6)}", // Show last 6 chars of ID
                    style: const TextStyle(color: greyColor, fontSize: 12),
                  ),
                ],
              ),
              // Right: Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  bill.status.toUpperCase(),
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Amount Details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Due Amount", style: TextStyle(fontSize: 12, color: greyColor)),
                  const SizedBox(height: 5),
                  Text(
                    "LKR ${bill.amount.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColorOne),
                  ),
                  const SizedBox(height: 5),
                  Text("Generated: $dateStr", style: const TextStyle(fontSize: 11, color: greyColor)),
                ],
              ),
              // Pay Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: statusColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  elevation: 2,
                ),
                onPressed: () => _handlePayBill(bill),
                child: const Text("Pay Now", style: TextStyle(color: white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: 400,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
            SizedBox(height: 20),
            Text("No Pending Payments!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColorOne)),
            SizedBox(height: 10),
            Text("You are all caught up.", style: TextStyle(color: greyColor)),
          ],
        ),
      ),
    );
  }
}