import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sri_tel_flutter_web_mob/Global/global_configs.dart';
import '../../utils/colors.dart'; // Your brand colors

class OtpPopup extends StatefulWidget {
  final String phoneNumber;
  final Function(String) onVerify; // Callback when user clicks verify
  final Future<void> Function() onResend; // Callback for resend logic

  const OtpPopup({
    super.key,
    required this.phoneNumber,
    required this.onVerify,
    required this.onResend,
  });

  @override
  State<OtpPopup> createState() => _OtpPopupState();
}

class _OtpPopupState extends State<OtpPopup> {
  // Controllers for 4 digits
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  // Timer State
  int _secondsRemaining = 30;
  Timer? _timer;
  bool _canResend = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 30;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  Future<void> _handleVerify() async {
    String otp = _controllers.map((c) => c.text).join();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please enter the full 6-digit code"),
            backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Call the parent's verify function
    await widget.onVerify(otp);

    // Note: The parent is responsible for closing the dialog upon success
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _handleResend() async {
    if (!_canResend) return;
    await widget.onResend();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: lightYellow,
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(25),
        constraints: const BoxConstraints(maxWidth: 400), // Limit width on Web
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: orangeColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_clock, size: 40, color: orangeColor),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              "Verification Code",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColorOne),
            ),
            const SizedBox(height: 10),
            Text(
              "Please enter the 6-digit code you received.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: greyColor, fontSize: 14),
            ),
            const SizedBox(height: 30),

            // OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) => _buildDigitInput(index)),
            ),

            const SizedBox(height: 30),

            // Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: orangeColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _isLoading ? null : _handleVerify,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: white, strokeWidth: 2))
                    : const Text("Verify",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: white)),
              ),
            ),
            const SizedBox(height: 20),

            // Resend Timer
            GestureDetector(
              onTap: _handleResend,
              child: RichText(
                text: TextSpan(
                  text:
                      _canResend ? "Didn't receive code? " : "Resend code in ",
                  style: const TextStyle(color: greyColor, fontSize: 14),
                  children: [
                    TextSpan(
                      text: _canResend ? "Resend" : "${_secondsRemaining}s",
                      style: TextStyle(
                        color: _canResend ? orangeColor : textColorOne,
                        fontWeight: FontWeight.bold,
                        decoration:
                            _canResend ? TextDecoration.underline : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDigitInput(int index) {
    return SizedBox(
      width: 50,
      height: 60,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: textColorOne),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: "",
          // Hide length counter
          filled: true,
          fillColor: white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: orangeColor, width: 2)),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            // Auto-focus next field
            if (index < 5) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            } else {
              // Hide keyboard if last digit entered
              FocusScope.of(context).unfocus();
            }
          } else if (value.isEmpty) {
            // Auto-focus previous field on delete
            if (index > 0) {
              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
            }
          }
        },
      ),
    );
  }
}
