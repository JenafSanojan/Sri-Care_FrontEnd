import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sri_tel_flutter_web_mob/utils/string.dart';
import 'package:sri_tel_flutter_web_mob/views/auth/reset_password_screen.dart';
import 'package:sri_tel_flutter_web_mob/views/auth/signup_screen.dart';
import 'package:sri_tel_flutter_web_mob/views/home/main_screen.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/loading_widgets/loading_widget.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/responsive-layout.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/colors.dart';
import '../../widget_common/custom_button_widget.dart';
import '../../widget_common/custom_password_field_widget.dart';
import '../../widget_common/custom_textwidget.dart';
import '../../widget_common/footer_credit_copyright_text.dart';
import '../../widget_common/social_media_button_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObscure = true;

  void toggleObscure() {
    if (mounted) {
      setState(() {
        isObscure = !isObscure;
      });
    }
  }

  bool isShowLoadingWidget = false;

  final controller = Get.put(AuthController());

  TextEditingController emailOrPhoneController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  void _login() async {
    if (mounted) {
      setState(() {
        isShowLoadingWidget = true;
      });
    }

    if (emailOrPhoneController.text.isNotEmpty &&
        pwdController.text.isNotEmpty) {
      await controller.emailAndPasswordSignIn(
        emailOrPhoneNumber: emailOrPhoneController.text,
        password: pwdController.text,
      );
    }

    if (mounted) {
      setState(() {
        isShowLoadingWidget = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    GetStorage().erase(); // for safety (erase company selection_popup.dart)
  }

  @override
  void dispose() {
    // Cancel any ongoing async operations if necessary
    emailOrPhoneController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: Stack(
          children: [
            SizedBox(
              width: Get.width,
              height: Get.height,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 27.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        // Login text.....................................................
                        // const Align(
                        //   alignment: Alignment.bottomLeft,
                        //   child: Padding(
                        //     padding: EdgeInsets.symmetric(horizontal: 28),
                        //     child: Text(
                        //       AppConstants.login,
                        //       style: TextStyle(
                        //           color: Color.fromARGB(255, 0, 0, 0),
                        //           fontSize: 28,
                        //           fontWeight: FontWeight.bold),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 20),
                        // Social Media Login Buttons ....................................
                        Row(
                          children: [
                            const Spacer(),
                            SocialMediaButton(
                              color: white,
                              onPress: () async {
                                if (mounted) {
                                  setState(() {
                                    isShowLoadingWidget = true;
                                  });
                                }
                                // await _signInWithFacebook(context);
                                if (mounted) {
                                  setState(() {
                                    isShowLoadingWidget = false;
                                  });
                                }
                              },
                              title: AppConstants.facebook,
                              txtColor: socoalmedia_btn_textcolor,
                              imagePath: "assets/images/facebook.png",
                            ),
                            Tooltip(
                              message: 'Facebook Sign-In is not Available Now.',
                              child: Icon(
                                Icons.info_outline,
                                size: 18,
                                color: Colors.grey,
                              ),
                            ),
                            const Spacer(),
                            SocialMediaButton(
                              color: white,
                              onPress: () async {
                                if (mounted) {
                                  setState(() {
                                    isShowLoadingWidget = true;
                                  });
                                }
                                // await logInWithGoogle();
                                if (mounted) {
                                  setState(() {
                                    isShowLoadingWidget = false;
                                  });
                                }
                              },
                              title: AppConstants.google,
                              txtColor: socoalmedia_btn_textcolor,
                              imagePath: "assets/images/google.png",
                            ),
                            Tooltip(
                              message: 'Google Sign-In is not Available Now.',
                              child: Icon(
                                Icons.info_outline,
                                size: 18,
                                color: Colors.grey,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(height: 29),
                        // Email , username , password Text field.........................
                        customTextField(
                            title: AppConstants.hintemailusernamephone,
                            controller: emailOrPhoneController,
                            hint: "Your E-mail Address",
                            isPass: false,
                            fillColor: textfield_fillColor),
                        SizedBox(height: 10),
                        customPasswordField(
                          title: AppConstants.password,
                          controller: pwdController,
                          hint: "Your Password",
                          isObscure: isObscure,
                          fillColor: textfield_fillColor,
                          iconCallback: toggleObscure,
                        ),
                        const SizedBox(height: 17),
                        // Login Button.....................................................
                        CustomButton(
                          color: loginBtn_fillColor,
                          onPress: _login,
                          title: AppConstants.login,
                          txtColor: white,
                        ),
                        const SizedBox(height: 7),
                        // Forget Password .................................................
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                            child: TextButton(
                              onPressed: () => Get.to(() => ResetPassword()),
                              child: const Text(
                                AppConstants.forgotpassword,
                                style: TextStyle(color: forget_txtColor),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        // Not register Not text ..........................................
                        GestureDetector(
                          onTap: () {
                            // Navigate to the sign-up screen here
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                              ),
                            );
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 34),
                              child: RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: AppConstants.notregistered,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: AppConstants.registerNow,
                                      style: TextStyle(
                                          color: forget_txtColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Proceed to test ..........................................
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainScreen(),
                              ),
                            );
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 34),
                              child: RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Proceed to Test",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: orangeColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        FooterCopyrightCreditText(),
                        Text(
                          AppConstants.version,
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.blue,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            isShowLoadingWidget
                ? SizedBox(
                    width: Get.width,
                    height: Get.height,
                    child: GestureDetector(
                      onTap: () {
                        if (mounted) {
                          setState(() {
                            isShowLoadingWidget = false;
                          });
                        }
                      },
                      child: LoadingScreen(),
                    ),
                  )
                : SizedBox(),
          ],
        ),
        webBody: Stack(
          children: [
            Row(
              children: [
                Expanded(
                    child: Stack(
                  children: [
                    Container(color: logo_back),
                    Center(
                      child: SizedBox(
                          width: 200,
                          height: 200,
                          child: Image.asset("assets/images/Logo_Quote.png")),
                    )
                  ],
                )), // Decorative Left Panel
                Expanded(
                  child: SizedBox(
                    width: 600,
                    height: Get.height,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 27.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 60),
                              // // Login text.....................................................
                              // const Align(
                              //   alignment: Alignment.bottomLeft,
                              //   child: Padding(
                              //     padding: EdgeInsets.symmetric(horizontal: 28),
                              //     child: Text(
                              //       AppConstants.login,
                              //       style: TextStyle(
                              //           color: Color.fromARGB(255, 0, 0, 0),
                              //           fontSize: 28,
                              //           fontWeight: FontWeight.bold),
                              //     ),
                              //   ),
                              // ),
                              const SizedBox(height: 20),
                              // Social Media Login Buttons ....................................
                              Row(
                                children: [
                                  const Spacer(),
                                  SocialMediaButton(
                                    color: white,
                                    onPress: () async {
                                      if (mounted) {
                                        setState(() {
                                          isShowLoadingWidget = true;
                                        });
                                      }
                                      // await _signInWithFacebook(context);
                                      if (mounted) {
                                        setState(() {
                                          isShowLoadingWidget = false;
                                        });
                                      }
                                    },
                                    title: AppConstants.facebook,
                                    txtColor: socoalmedia_btn_textcolor,
                                    imagePath: "assets/images/facebook.png",
                                  ),
                                  Tooltip(
                                    message:
                                        'Facebook Sign-In is not Available Now.',
                                    child: Icon(
                                      Icons.info_outline,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const Spacer(),
                                  SocialMediaButton(
                                    color: white,
                                    onPress: () async {
                                      if (mounted) {
                                        setState(() {
                                          isShowLoadingWidget = true;
                                        });
                                      }
                                      // await logInWithGoogle();
                                      if (mounted) {
                                        setState(() {
                                          isShowLoadingWidget = false;
                                        });
                                      }
                                    },
                                    title: AppConstants.google,
                                    txtColor: socoalmedia_btn_textcolor,
                                    imagePath: "assets/images/google.png",
                                  ),
                                  Tooltip(
                                    message:
                                        'Google Sign-In is not Available Now.',
                                    child: Icon(
                                      Icons.info_outline,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                              const SizedBox(height: 29),
                              // Email , username , password Text field.........................
                              customTextField(
                                  title: AppConstants.hintemailusernamephone,
                                  controller: emailOrPhoneController,
                                  hint: "Your E-mail Address",
                                  isPass: false,
                                  fillColor: textfield_fillColor),
                              SizedBox(height: 10),
                              customPasswordField(
                                  title: AppConstants.password,
                                  controller: pwdController,
                                  hint: "Your Password",
                                  isObscure: isObscure,
                                  iconCallback: toggleObscure),
                              const SizedBox(height: 17),
                              // Login Button.....................................................
                              CustomButton(
                                color: loginBtn_fillColor,
                                onPress: _login,
                                title: AppConstants.login,
                                txtColor: white,
                              ),
                              const SizedBox(height: 7),
                              // Forget Password .................................................
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 22),
                                  child: TextButton(
                                    onPressed: () =>
                                        Get.to(() => ResetPassword()),
                                    child: const Text(
                                      AppConstants.forgotpassword,
                                      style: TextStyle(color: forget_txtColor),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 7),
                              // Not register Not text ..........................................
                              GestureDetector(
                                onTap: () {
                                  // Navigate to the sign-up screen here
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignUpScreen(),
                                    ),
                                  );
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 34),
                                    child: RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: AppConstants.notregistered,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: AppConstants.registerNow,
                                            style: TextStyle(
                                                color: forget_txtColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Proceed to test ..........................................
                              // TextButton(
                              //   onPressed: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) => MainScreen(),
                              //       ),
                              //     );
                              //   },
                              //   child: Align(
                              //     alignment: Alignment.centerLeft,
                              //     child: Padding(
                              //       padding: const EdgeInsets.symmetric(
                              //           horizontal: 34),
                              //       child: RichText(
                              //         text: const TextSpan(
                              //           children: [
                              //             TextSpan(
                              //               text: "Proceed to Test",
                              //               style: TextStyle(
                              //                   fontWeight: FontWeight.bold,
                              //                   color: orangeColor),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              const SizedBox(height: 40),
                              FooterCopyrightCreditText(),
                              Text(
                                AppConstants.version,
                                style: TextStyle(
                                  fontSize: 10.0,
                                  color: Colors.blue,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            isShowLoadingWidget
                ? SizedBox(
                    width: Get.width,
                    height: Get.height,
                    child: GestureDetector(
                      onTap: () {
                        if (mounted) {
                          setState(() {
                            isShowLoadingWidget = false;
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
