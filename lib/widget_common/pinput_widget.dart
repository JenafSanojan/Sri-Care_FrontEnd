import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:sri_tel_flutter_web_mob/utils/string.dart';

import '../utils/colors.dart';

class PinputWidget extends StatefulWidget {
  final TextEditingController controller;
  const PinputWidget({super.key, required this.controller});

  @override
  State<PinputWidget> createState() => _PinputWidgetState();
}

class _PinputWidgetState extends State<PinputWidget> {

final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

    const focusedBorderColor = Color.fromRGBO(117, 117, 116, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromARGB(255, 172, 172, 171);

    
    final defaultPinTheme = PinTheme(
      width: 84,
      height: 84,
      margin: EdgeInsets.all(2),
      textStyle: const TextStyle(
        fontSize: 22,
        // color: Color.fromRGBO(30, 60, 87, 1),
        color: Colors.grey,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: borderColor),
      ),
    );

    /// Optionally you can use form to validate the Pinput
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Directionality(
            // Specify direction if desired
            textDirection: TextDirection.ltr,
            
            child: Pinput(
              length: 6,
              controller: widget.controller,
              focusNode: focusNode,
              // onCompleted: (String input){
              //   authController.verifyOtp(input);
              // },
              // androidSmsAutofillMethod:
              // AndroidSmsAutofillMethod.smsUserConsentApi,
              // listenForMultipleSmsOnAndroid: true,
              defaultPinTheme: defaultPinTheme,
              // validator: (value) {
              //   return value == '2222' ? null : 'Pin is incorrect';
              // },
              // onClipboardFound: (value) {
              //   debugPrint('onClipboardFound: $value');
              //   pinController.setText(value);
              // },
              //           hapticFeedbackType: HapticFeedbackType.lightImpact,
              // onCompleted: (pin) {
              //   debugPrint('onCompleted: $pin');
              // },
              // onChanged: (value) {
              //   debugPrint('onChanged: $value');
              // },
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    width: 22,
                    height: 1,
                    color: focusedBorderColor,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: const Color.fromARGB(255, 113, 113, 113)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}