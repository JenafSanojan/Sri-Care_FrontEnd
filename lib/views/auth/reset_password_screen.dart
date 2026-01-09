import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sri_tel_flutter_web_mob/utils/string.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/snack_bar.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/colors.dart';
import '../../widget_common/custom_button_widget.dart';
import '../../widget_common/custom_text_widget.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final controller = Get.put(AuthController());
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitEmail() async {
    final email = _emailController.text.trim().toLowerCase();

    // Validate email
    if (!_isValidEmail(email)) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enter a valid email address')),
        );
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await controller.sendResetPasswordLink(email: email);
    } catch (e) {
      CommonLoaders.errorSnackBar(
          title: "Something Went Wrong",
          message: "An error occurred. Please try again later.",
          duration: 3);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isValidEmail(String email) {
    const pattern = r'^[^@]+@[^@]+\.[^@]+';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.0,
              ),
              // Container(
              //   margin: EdgeInsets.only(top: 51),
              //   child: Image.asset(
              //     'assets/images/splash_top_image.svg',
              //     semanticLabel: 'A shark?!',
              //     width: double.infinity,
              //     height: 142,
              //   ),
              // ),
              const SizedBox(height: 60),
              const Text(
                AppConstants.enterEmailToReset,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              customTextField(
                hint: "Your Email Address",
                isPass: false,
                controller: _emailController,
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: CustomButton(
                  color: loginBtn_fillColor,
                  onPress: _submitEmail,
                  title: _isLoading ? 'Loading...' : 'Confirm',
                  txtColor: white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
