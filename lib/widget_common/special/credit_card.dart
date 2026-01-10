import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/colors.dart';

class CreditCardInput extends StatelessWidget {
  const CreditCardInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Card Details",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColorOne),
          ),
          const SizedBox(height: 20),

          // Card Number
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16)],
            decoration: InputDecoration(
              labelText: "Card Number",
              hintText: "0000 0000 0000 0000",
              prefixIcon: const Icon(Icons.credit_card, color: orangeColor),
              filled: true,
              fillColor: lightYellow, // Subtle contrast
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: orangeColor)),
            ),
          ),
          const SizedBox(height: 15),

          // Expiry & CVC Row
          Row(
            children: [
              // Expiry Date
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: "Expiry",
                    hintText: "MM/YY",
                    prefixIcon: const Icon(Icons.calendar_today, color: greyColor),
                    filled: true,
                    fillColor: lightYellow,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: orangeColor)),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              // CVV
              Expanded(
                child: TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [LengthLimitingTextInputFormatter(3)],
                  decoration: InputDecoration(
                    labelText: "CVV",
                    hintText: "123",
                    prefixIcon: const Icon(Icons.lock_outline, color: greyColor),
                    filled: true,
                    fillColor: lightYellow,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: orangeColor)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Name on Card
          TextFormField(
            decoration: InputDecoration(
              labelText: "Cardholder Name",
              prefixIcon: const Icon(Icons.person_outline, color: greyColor),
              filled: true,
              fillColor: lightYellow,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: orangeColor)),
            ),
          ),
        ],
      ),
    );
  }
}
