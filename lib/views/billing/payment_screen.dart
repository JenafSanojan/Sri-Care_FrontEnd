import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatters
import 'package:sri_tel_flutter_web_mob/Global/global_configs.dart';
import 'package:sri_tel_flutter_web_mob/entities/packageBilling/bill.dart';
import 'package:sri_tel_flutter_web_mob/entities/packageBilling/payment_response.dart';
import 'package:sri_tel_flutter_web_mob/entities/provisioning/telco_package.dart';
import 'package:sri_tel_flutter_web_mob/services/payment_service.dart';
import 'package:sri_tel_flutter_web_mob/views/home/main_screen.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/snack_bar.dart';
import '../../utils/colors.dart';
import '../../widget_common/loading_widgets/loading_widget.dart';
import '../../widget_common/responsive-layout.dart';
import '../../widget_common/special/credit_card.dart';
import 'package:get/get.dart';

import '../../widget_common/special/otp_popup.dart';

class PaymentScreen extends StatefulWidget {
  final bool dontShowBackButton;
  final TelcoPackage? package;
  final Bill? bill;

  const PaymentScreen(
      {super.key, this.dontShowBackButton = false, this.package, this.bill});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _amountController = TextEditingController();
  final _cardNumberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  bool isReadOnlyAmt = false;
  bool _isShowLoadingWidget = false;
  PaymentService paymentService = PaymentService();

  // Quick amount suggestions
  final List<int> _quickAmounts = [100, 350, 500, 1000];

  @override
  void initState() {
    super.initState();
    if (widget.package != null) {
      _amountController.text = widget.package!.cost.toStringAsFixed(2);
      isReadOnlyAmt = true;
    }
    if (widget.bill != null) {
      _amountController.text = widget.bill!.amount.toStringAsFixed(2);
      isReadOnlyAmt = true;
    }
  }

  bool _validateCard() {
    // 1. Validate Name
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please enter the cardholder's name"),
            backgroundColor: Colors.red),
      );
      return false;
    }

    // 2. Validate Card Number (Simple length check for prototype)
    // Remove spaces if you decide to add a formatter that adds them later
    String cleanCardNum = _cardNumberCtrl.text.replaceAll(RegExp(r'\s+'), '');
    if (cleanCardNum.length != 16) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Card number must be 16 digits"),
            backgroundColor: Colors.red),
      );
      return false;
    }

    // 3. Validate CVV
    if (_cvvCtrl.text.length != 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("CVV must be 3 digits"), backgroundColor: Colors.red),
      );
      return false;
    }

    // 4. Validate Expiry Date (MM/YY)
    if (_expiryCtrl.text.isEmpty || !_expiryCtrl.text.contains('/')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Invalid Expiry Date format (MM/YY)"),
            backgroundColor: Colors.red),
      );
      return false;
    }

    try {
      List<String> parts = _expiryCtrl.text.split('/');
      int month = int.parse(parts[0]);
      int year = int.parse(parts[1]) + 2000; // Assume 20xx

      // Check Month range
      if (month < 1 || month > 12) {
        throw Exception("Invalid Month");
      }

      // Check if expired
      DateTime now = DateTime.now();
      // Create a date for the end of that month (roughly)
      DateTime cardDate = DateTime(year, month);

      if (cardDate.isBefore(DateTime(now.year, now.month))) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Card has expired"), backgroundColor: Colors.red),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Invalid Expiry Date"), backgroundColor: Colors.red),
      );
      return false;
    }

    return true;
  }

  void _validateOTPandConfirmPayment(
      String otp, PaymentResponse progressingPayment) {
    paymentService
        .confirmPayment(
            providerRef: "${progressingPayment.transaction.providerRef}",
            otp: otp)
        .then((confirmResponse) {
      if (confirmResponse == null ||
          confirmResponse.transaction.isCompleted == false) {
        // Error handled in service
        return;
      } else {
        // Payment successful
        if (mounted) {
          Navigator.of(context).pop(); // Close OTP dialog
          // Get.back(); // Close payment screen
          Get.offAll(() => MainScreen());
          CommonLoaders.successSnackBar(
              title: "Payment Successful",
              duration: 3,
              message: "Your payment was completed successfully.");
        }
      }
    });
  }

  void showOtpValidation(
      BuildContext context, PaymentResponse progressingPayment) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must verify or close explicitly
      builder: (context) => OtpPopup(
        phoneNumber: "${GlobalAuthData.instance.user.mobileNumber}",
        onResend: () async {
          // paymentService.
          CommonLoaders.successSnackBar(
              title: "OTP Resent",
              duration: 3,
              message: "A new OTP has been sent, please check.");
          print("OTP Resent!");
        },
        onVerify: (otp) =>
            _validateOTPandConfirmPayment(otp, progressingPayment),
      ),
    );
  }

  void _pay() async {
    if (mounted) {
      setState(() {
        _isShowLoadingWidget = true;
      });
    }
    try{
      // Validate and Process Payment
      if (_amountController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Please enter an amount"),
              backgroundColor: Colors.red),
        );
        return;
      }
      double amount = double.tryParse(_amountController.text) ?? 0;
      if (amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Please enter a valid amount"),
              backgroundColor: Colors.red),
        );
        return;
      }
      if (!_validateCard()) {
        return; // Stop if card validation fails
      }
      PaymentResponse? paymentResponse;
      if (widget.bill != null) {
        paymentResponse = await paymentService.payBill(
            amount: amount,
            cardNumber: _cardNumberCtrl.text,
            expiry: _expiryCtrl.text,
            cvv: _cvvCtrl.text,
            billId: '${widget.bill?.id}');
      } else {
        paymentResponse = await paymentService.topUpWallet(
          amount: amount,
          cardNumber: _cardNumberCtrl.text,
          expiry: _expiryCtrl.text,
          cvv: _cvvCtrl.text,
        );
      }
      if (paymentResponse == null || paymentResponse.otpSent == false) {
        CommonLoaders.errorSnackBar(
            title: "Payment Failed",
            duration: 3,
            message:
                paymentResponse?.message ?? "An error occurred during payment");
        return;
      } else {
        // show otp popup
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Please enter the OTP you received"),
              backgroundColor: Colors.red),
        );
        if (mounted) {
          showOtpValidation(context, paymentResponse);
        }
      }
    } catch (ex){
      print("Error during payment: $ex");
      CommonLoaders.errorSnackBar(
          title: "Payment Error",
          duration: 3,
          message: "An unexpected error occurred. Please try again.");
    } finally {
      if (mounted) {
        setState(() {
          _isShowLoadingWidget = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: _buildContent(isWeb: false),
      webBody: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          // Limit width on web
          child: _buildContent(isWeb: true),
        ),
      ),
    );
  }

  Widget _buildContent({required bool isWeb}) {
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        backgroundColor: orangeColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: white),
          onPressed: () => Get.back(),
        ),
        title: const Text("Reloads & Payment",
            style: TextStyle(color: white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- 1. AMOUNT SECTION ---
                Text(
                  isReadOnlyAmt && widget.bill == null
                      ? "${widget.package?.name} - ${widget.package?.validity} days"
                      : "Enter Amount",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: greyColor),
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: orangeColor, width: 1.5), // Highlight border
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: orangeColor),
                        decoration: const InputDecoration(
                          prefixText: "LKR ",
                          prefixStyle:
                              TextStyle(fontSize: 24, color: greyColor),
                          border: InputBorder.none,
                          hintText: "0.00",
                          hintStyle: TextStyle(color: Colors.black12),
                        ),
                        readOnly: isReadOnlyAmt,
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
                            label: Text("Rs. $amount",
                                style: const TextStyle(
                                    color: textColorOne,
                                    fontWeight: FontWeight.bold)),
                            onPressed: isReadOnlyAmt
                                ? null
                                : () {
                                    setState(() {
                                      _amountController.text =
                                          amount.toString();
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
                CreditCardInput(
                  cardNumberController: _cardNumberCtrl,
                  cardHolderNameController: _nameCtrl,
                  cvvController: _cvvCtrl,
                  expiryController: _expiryCtrl,
                ),

                const SizedBox(height: 15),

                // Security Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.lock, size: 14, color: greyColor),
                    SizedBox(width: 5),
                    Text("Payments are secure and encrypted",
                        style: TextStyle(color: greyColor, fontSize: 12)),
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 5,
                      shadowColor: orangeColor.withValues(alpha: 0.4),
                    ),
                    onPressed: _pay,
                    child: const Text("Reload Now",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: white)),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel Transaction",
                        style: TextStyle(color: greyColor, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
            _isShowLoadingWidget
                ? SizedBox(
                    width: Get.width,
                    height: Get.height,
                    child: GestureDetector(
                      onTap: () {
                        if (mounted) {
                          setState(() {
                            _isShowLoadingWidget = false;
                          });
                        }
                      },
                      child: LoadingScreen(),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
