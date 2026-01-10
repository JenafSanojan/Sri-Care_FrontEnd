import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatters
import '../../utils/colors.dart';
import '../../widget_common/responsive-layout.dart';
import '../../widget_common/special/credit_card.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatefulWidget {
  final bool dontShowBackButton;
  const PaymentScreen({super.key, this.dontShowBackButton = false});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _amountController = TextEditingController();

  // Quick amount suggestions
  final List<int> _quickAmounts = [100, 350, 500, 1000];

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: _buildContent(isWeb: false),
      webBody: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600), // Limit width on web
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
        title: const Text("Reloads & Payment", style: TextStyle(color: textColorOne, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. AMOUNT SECTION ---
            const Text(
              "Enter Amount",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: greyColor),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: orangeColor, width: 1.5), // Highlight border
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: orangeColor),
                    decoration: const InputDecoration(
                      prefixText: "LKR ",
                      prefixStyle: TextStyle(fontSize: 24, color: greyColor),
                      border: InputBorder.none,
                      hintText: "0.00",
                      hintStyle: TextStyle(color: Colors.black12),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Quick Amount Chips
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: _quickAmounts.map((amount) {
                      return ActionChip(
                        backgroundColor: lightYellow,
                        label: Text("Rs. $amount", style: const TextStyle(color: textColorOne, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          setState(() {
                            _amountController.text = amount.toString();
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- 2. PAYMENT METHOD SECTION ---
            // Using the separate component we created
            const CreditCardInput(),

            const SizedBox(height: 15),

            // Security Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.lock, size: 14, color: greyColor),
                SizedBox(width: 5),
                Text("Payments are secure and encrypted", style: TextStyle(color: greyColor, fontSize: 12)),
              ],
            ),

            const SizedBox(height: 40),

            // --- 3. ACTION BUTTONS ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: orangeColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                  shadowColor: orangeColor.withOpacity(0.4),
                ),
                onPressed: () {
                  // Validate and Process Payment
                  if (_amountController.text.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Processing Payment..."), backgroundColor: darkGreen),
                    );
                    // Add your payment logic here
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter an amount"), backgroundColor: Colors.red),
                    );
                  }
                },
                child: const Text("Reload Now", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: white)),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel Transaction", style: TextStyle(color: greyColor, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}