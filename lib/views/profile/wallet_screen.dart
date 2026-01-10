import 'package:flutter/material.dart';
import 'package:sri_tel_flutter_web_mob/views/billing/payment_screen.dart';
import '../../utils/colors.dart';
import '../../widget_common/responsive-layout.dart';
import 'package:get/get.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: _buildContent(context, isWeb: false),
      webBody: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: _buildContent(context, isWeb: true),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, {required bool isWeb}) {
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        backgroundColor: logo_back,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textColorOne),
          onPressed: () => Get.back(),
        ),
        title: const Text("My Wallet", style: TextStyle(color: textColorOne, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- 1. WALLET CARD ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [orangeColor, textLightGreenColor], // Brand Gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: orangeColor.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Available Balance",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text("PREPAID", style: TextStyle(color: white, fontSize: 10, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "LKR 450.50",
                    style: TextStyle(color: white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("**** 1234", style: TextStyle(color: white, fontSize: 16)),
                      Text("Exp 12/28", style: TextStyle(color: white, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --- 2. QUICK ACTIONS ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.add,
                  label: "Top Up",
                  onTap: () {
                    // Navigate to the Reload Screen we created earlier
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentScreen()));
                  },
                ),
                _buildActionButton(
                  context,
                  icon: Icons.send,
                  label: "Transfer",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Transfer Feature Coming Soon")));
                  },
                ),
                _buildActionButton(
                  context,
                  icon: Icons.qr_code,
                  label: "Scan",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("QR Scanner Coming Soon")));
                  },
                ),
              ],
            ),

            const SizedBox(height: 30),

            // --- 3. LOYALTY POINTS BANNER ---
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: orangeColor.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: lightYellow, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.star, color: orangeColor),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Star Points", style: TextStyle(fontWeight: FontWeight.bold, color: textColorOne)),
                      Text("You have 1,250 points", style: TextStyle(fontSize: 12, color: greyColor)),
                    ],
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text("Redeem", style: TextStyle(color: orangeColor, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- 4. RECENT TRANSACTIONS HEADER ---
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recent Transactions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColorOne),
              ),
            ),
            const SizedBox(height: 15),

            // --- 5. TRANSACTIONS LIST ---
            _buildTransactionTile(
              title: "Data Add-on 5GB",
              date: "Today, 10:30 AM",
              amount: "- LKR 250.00",
              isCredit: false,
            ),
            _buildTransactionTile(
              title: "Account Reload",
              date: "Yesterday, 06:45 PM",
              amount: "+ LKR 1,000.00",
              isCredit: true,
            ),
            _buildTransactionTile(
              title: "Star Points Redeem",
              date: "12 Jan, 02:00 PM",
              amount: "+ LKR 100.00",
              isCredit: true,
            ),
          ],
        ),
      ),
    );
  }

  // Helper for Action Buttons (Top Up, Transfer, etc.)
  Widget _buildActionButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(icon, color: orangeColor, size: 28),
          ),
        ),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColorOne)),
      ],
    );
  }

  // Helper for Transaction Rows
  Widget _buildTransactionTile({required String title, required String date, required String amount, required bool isCredit}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isCredit ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isCredit ? Icons.arrow_downward : Icons.arrow_upward,
              color: isCredit ? Colors.green : Colors.red,
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: textColorOne)),
                const SizedBox(height: 5),
                Text(date, style: const TextStyle(fontSize: 12, color: greyColor)),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isCredit ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}