import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/custom_password_field_widget.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/footer_credit_copyright_text.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/loading_widgets/loading_widget.dart';

import '../../controllers/auth_controller.dart';
import '../../utils/colors.dart';
import '../../utils/string.dart';
import '../../widget_common/custom_button_widget.dart';
import '../../widget_common/custom_textwidget.dart';
import '../../widget_common/snack_bar.dart';
import '../../widget_common/social_media_button_widget.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isObscure1 = true;

  void toggleObscure1() {
    setState(() {
      isObscure1 = !isObscure1;
    });
  }

  bool isObscure2 = true;

  void toggleObscure2() {
    setState(() {
      isObscure2 = !isObscure2;
    });
  }

  bool isShowLoadingWidget = false;

  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordRetypeController =
      TextEditingController();

  final controller = Get.put(AuthController());

  void _signUp() async {
    if (mounted) {
      setState(() {
        isShowLoadingWidget = true;
      });
    }
    if (displayNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        mobileNumberController.text.isNotEmpty) {
      if (passwordController.text.toString() ==
          passwordRetypeController.text.toString()) {
        // print("Signup started");
        await controller.signUp(
            email: emailController.text,
            password: passwordController.text,
            displayName: displayNameController.text,
            mobileNumber: mobileNumberController.text,
            profilePhoto: '',
            isSocialMedia: false);
      }
    }
    if (mounted) {
      setState(() {
        isShowLoadingWidget = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: Get.width,
            height: Get.height,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 27.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),

                          // Signup text.....................................................

                          const Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 28),
                              child: Text(
                                AppConstants.signup,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          const SizedBox(height: 7),

                          // Social Media Login Buttons ....................................

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              SocialMediaButton(
                                  color: white,
                                  onPress: () async {
                                    // await signInWithFacebook(context);
                                  },
                                  title: AppConstants.facebook,
                                  txtColor: socoalmedia_btn_textcolor,
                                  imagePath: "assets/images/facebook.png"),
                              const Spacer(),
                              SocialMediaButton(
                                  color: white,
                                  onPress: () async {
                                    // await signInWithGoogle();
                                  },
                                  title: AppConstants.google,
                                  txtColor: socoalmedia_btn_textcolor,
                                  imagePath: "assets/images/google.png"),
                              const Spacer(),
                            ],
                          ),

                          const SizedBox(
                            height: 30,
                          ),

                          // Full Name Field ..............................................................

                          customTextField(
                              controller: displayNameController,
                              title: AppConstants.fullname,
                              hint: "Your Name",
                              isPass: false,
                              fillColor: textfield_fillColor2),

                          const SizedBox(
                            height: 5,
                          ),

                          // Email Or Phone Number Field ...................................................

                          customTextField(
                              controller: emailController,
                              title: AppConstants.emailorPhone,
                              hint: "Your E-mail Address",
                              isPass: false,
                              fillColor: textfield_fillColor2),

                          const SizedBox(
                            height: 8,
                          ),

                          customTextField(
                            controller: mobileNumberController,
                              title: 'Sri-Tel Mobile Number',
                              hint: "074 XXX XXXX",
                              isPass: false,
                              fillColor: textfield_fillColor2,
                            validation: (value) {
                              String pattern = r'^(074\d{7})$';
                              RegExp regExp = RegExp(pattern);
                              if (value == null || value.isEmpty) {
                                return 'Please enter your mobile number';
                              } else if (!regExp.hasMatch(value)) {
                                return 'Please enter a valid Sri-Tel mobile number (074 XXX XXXX)';
                              }
                              return null;
                            },
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(
                          //       vertical: 10, horizontal: 20),
                          //   child: Align(
                          //     alignment: Alignment.centerLeft,
                          //     child: Text(
                          //       'Mobile Number',
                          //       style: const TextStyle(
                          //         fontSize: 17,
                          //         color: darkGreen,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 5.0,
                          // ),
                          //
                          // Container(
                          //   padding: EdgeInsets.symmetric(horizontal: 18.0),
                          //   height: 78.0,
                          //   width: double.infinity,
                          //   child: IntlPhoneField(
                          //     controller: mobileNumber,
                          //     decoration: InputDecoration(
                          //       hintStyle: const TextStyle(
                          //           //fontFamily: semibold,
                          //           color: hint_textColor,
                          //           fontSize: 15),
                          //       hintText: '',
                          //       isDense: true,
                          //       filled: true,
                          //       fillColor: textfield_fillColor2,
                          //       border: OutlineInputBorder(
                          //         borderSide:
                          //             BorderSide(color: Colors.amberAccent),
                          //         // Change the border color as needed
                          //         borderRadius: BorderRadius.circular(
                          //             10.0), // Adjust the radius as needed
                          //       ),
                          //       enabledBorder: OutlineInputBorder(
                          //           borderSide: BorderSide(
                          //               color: textfield_borderlColor),
                          //           borderRadius: BorderRadius.circular(10.0)),
                          //       focusedBorder: const OutlineInputBorder(
                          //           borderSide: BorderSide(
                          //               color: textfield_borderlColor)),
                          //     ),
                          //     initialCountryCode: 'AU',
                          //     onChanged: (phone) {
                          //       print('hello');
                          //       print(phone.completeNumber);
                          //     },
                          //   ),
                          // ),

                          const SizedBox(
                            height: 5,
                          ),

                          // Password Field ..............................................................

                          customPasswordField(
                              controller: passwordController,
                              title: AppConstants.password,
                              hint: "Your Password",
                              isObscure: isObscure1,
                              iconCallback: toggleObscure1
                              // fillColor: textfield_fillColor2
                              ),

                          const SizedBox(
                            height: 5,
                          ),

                          // Comfirm Password Field........................................................

                          customPasswordField(
                              controller: passwordRetypeController,
                              title: AppConstants.confirmPassword,
                              hint: "Confirm Your Password",
                              isObscure: isObscure2,
                              iconCallback: toggleObscure2),

                          const SizedBox(
                            height: 15,
                          ),

                          // Login Button.......................................................

                          CustomButton(
                              color: loginBtn_fillColor,
                              onPress: _signUp,
                              title: AppConstants.signup,
                              txtColor: white),

                          // ......................................................................

                          const SizedBox(
                            height: 20,
                          ),
                          FooterCopyrightCreditText(),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          if (isShowLoadingWidget)
            SizedBox(
              width: Get.width,
              height: Get.height,
              child: LoadingScreen(),
            ),
        ],
      ),
    );
  }
}
