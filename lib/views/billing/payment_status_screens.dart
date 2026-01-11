import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/colors.dart'; // Your brand colors
import '../../widget_common/responsive-layout.dart';
import '../home/dashboard.dart';

// ==========================================
// 1. PAYMENT SUCCESS SCREEN
// ==========================================
class PaymentSuccessScreen extends StatelessWidget {
  final double? amount;
  final String? transactionId;

  const PaymentSuccessScreen({
    super.key,
    this.amount,
    this.transactionId,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: _buildContent(context, isWeb: false),
      webBody: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: _buildContent(context, isWeb: true),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, {required bool isWeb}) {
    return Scaffold(
      backgroundColor: white,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Success Animation/Icon
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, size: 80, color: Colors.green),
            ),
            const SizedBox(height: 30),

            const Text(
              "Payment Successful!",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textColorOne),
            ),
            const SizedBox(height: 10),
            const Text(
              "Your transaction has been completed.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: greyColor),
            ),

            const SizedBox(height: 30),

            // Optional Amount Display
            if (amount != null)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                decoration: BoxDecoration(
                  color: lightYellow,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: orangeColor.withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    const Text("Amount Paid", style: TextStyle(fontSize: 12, color: greyColor)),
                    const SizedBox(height: 5),
                    Text(
                      "LKR ${amount!.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColorOne),
                    ),
                    if (transactionId != null) ...[
                      const SizedBox(height: 10),
                      Text("Ref: $transactionId", style: const TextStyle(fontSize: 10, color: greyColor)),
                    ]
                  ],
                ),
              ),

            const Spacer(),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: orangeColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  // Clear stack and go to Dashboard
                  Get.offAll(() => const DashboardScreen());
                },
                child: const Text("Back to Home", style: TextStyle(color: white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. PAYMENT FAILED SCREEN
// ==========================================
class PaymentFailedScreen extends StatelessWidget {
  final double? amount; // Optional: show what amount failed

  const PaymentFailedScreen({
    super.key,
    this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: _buildContent(context, isWeb: false),
      webBody: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: _buildContent(context, isWeb: true),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, {required bool isWeb}) {
    return Scaffold(
      backgroundColor: white,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Failure Animation/Icon
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline, size: 80, color: Colors.red),
            ),
            const SizedBox(height: 30),

            const Text(
              "Payment Failed",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textColorOne),
            ),
            const SizedBox(height: 10),
            const Text(
              "Something went wrong with your transaction.\nPlease try again.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: greyColor),
            ),

            if (amount != null) ...[
              const SizedBox(height: 20),
              Text(
                "Attempted: LKR ${amount!.toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold, color: greyColor),
              ),
            ],

            const Spacer(),

            // Try Again Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: textColorOne, // Black/Dark for high contrast
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  // Go back to the previous screen (Payment Page) to retry
                  Get.back();
                },
                child: const Text("Try Again", style: TextStyle(color: white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 15),

            // Back to Home Button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Get.offAll(() => const DashboardScreen());
                },
                child: const Text("Cancel & Return Home", style: TextStyle(color: greyColor)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}