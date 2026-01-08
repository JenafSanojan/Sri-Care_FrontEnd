import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:sri_tel_flutter_web_mob/views/delivety_detail_screens/DeliveryDetailsScreen.dart';
// import 'package:sri_tel_flutter_web_mob/views/reset_password_screens/otp_verification_screen.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/custom_password_field_widget.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/footer_credit_copyright_text.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/loading_widgets/loading_widget.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/snack_bar.dart';

// import '../../services/api_services/firebase_service.dart';
import '../../utils/colors.dart';
import '../../utils/string.dart';
import '../../widget_common/custom_button_widget.dart';
import '../../widget_common/custom_textwidget.dart';
import '../../widget_common/login_signup_bg_screen.dart';
import '../../widget_common/social_media_button_widget.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isObscure1 = true;
  void toggleObscure1(){
    setState(() {
      isObscure1 = !isObscure1;
    });
  }
  bool isObscure2 = true;
  void toggleObscure2(){
    setState(() {
      isObscure2 = !isObscure2;
    });
  }

  bool isShowLoadingWidget = false;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailOrPhoneNumberController = TextEditingController();
  final TextEditingController secondaryNumber = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordRetypeController = TextEditingController();

  // final controller = Get.put(AuthController());


  // Future<void> signUp() async {
  //   setState(() {
  //     isShowLoadingWidget = true;
  //   });
  //   if(
  //   fullNameController.text.isNotEmpty &&
  //       emailOrPhoneNumberController.text.isNotEmpty &&
  //       passwordController.text.isNotEmpty &&
  //       secondaryNumber.text.isNotEmpty
  //   ){
  //     if(passwordController.text.toString() == passwordRetypeController.text.toString()){
  //       // print("Signup started");
  //       String? userId = await controller.signUp(
  //           firstName: fullNameController.text,
  //           email: emailOrPhoneNumberController.text,
  //           password: passwordController.text,
  //           secondaryNumber: secondaryNumber.text,
  //           profilePhoto: '',
  //           isSocialMedia: false
  //       );
  //
  //       if (userId != null && userId.isNotEmpty) {
  //         print("Signup successful");
  //         CommonLoaders.successSnackBar(
  //           title: "Success",
  //           duration: 3,
  //           message: "Sign up successful. Please login to continue.",
  //         );
  //         Get.offAll(() => LoginScreen());
  //       } else {
  //         print("Signup failed");
  //         CommonLoaders.errorSnackBar(
  //           title: "Error",
  //           duration: 3,
  //           message: "Sign up failed. Please try again.",
  //         );
  //       }
  //     }
  //   }
  //   setState(() {
  //     isShowLoadingWidget = false;
  //   });
  // }

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

                          // Login text.....................................................

                          const Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 28),
                              child: Text(
                                AppConstants.signup,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
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
                                  onPress: () async{
                                    // await signInWithFacebook(context);
                                  },
                                  title: AppConstants.facebook,
                                  txtColor: socoalmedia_btn_textcolor,
                                  imagePath: "assets/images/facebook.png"),
                              const Spacer(),
                              SocialMediaButton(
                                  color: white,
                                  onPress: () async{
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
                              controller: fullNameController,
                              title: AppConstants.fullname,
                              hint: "Your Full Name",
                              isPass: false,
                              fillColor: textfield_fillColor2),

                          const SizedBox(
                            height: 5,
                          ),

                          // Email Or Phone Number Field ...................................................

                          customTextField(
                              controller: emailOrPhoneNumberController,
                              title: AppConstants.emailorPhone,
                              hint: "Your E-mail Address",
                              isPass: false,
                              fillColor: textfield_fillColor2
                          ),

                          const SizedBox(
                            height: 8,
                          ),


                          // customTextField(
                          //   controller: secondaryNumber,
                          //     title: 'Mobile Number',
                          //     hint: "Your Mobile Number",
                          //     isPass: false,
                          //     fillColor: textfield_fillColor2
                          // ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Mobile Number',
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: darkGreen,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 18.0),
                            height: 78.0,
                            width: double.infinity,
                            child: IntlPhoneField(
                              controller: secondaryNumber,
                              decoration:  InputDecoration(
                                hintStyle: const TextStyle(
                                  //fontFamily: semibold,
                                    color: hint_textColor,
                                    fontSize: 15
                                ),
                                hintText: '',
                                isDense: true,
                                filled: true,
                                fillColor: textfield_fillColor2,
                                border: OutlineInputBorder(

                                  borderSide: BorderSide(color: Colors.amberAccent), // Change the border color as needed
                                  borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                                ),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: textfield_borderlColor) , borderRadius: BorderRadius.circular(10.0)),
                                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: textfield_borderlColor)),
                              ),
                              initialCountryCode: 'AU',
                              onChanged: (phone) {
                                print('hello');
                                print(phone.completeNumber);
                              },
                            ),
                          ),

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
                              iconCallback: toggleObscure2
                          ),

                          const SizedBox(
                            height: 15,
                          ),

                          // Login Button.......................................................

                          CustomButton(
                              color: loginBtn_fillColor,
                              onPress: () {
                                // Get.to(DeliveryDetailsScreen(userId: '', userName: '', emailOrPhoneNumberController: ''));
                                // signUp();
                                // CommonLoaders.errorSnackBar(
                                //   title: "Disabled",
                                //   duration: 3,
                                //   message: "Own Sign Up is disabled for now. Please contact your company admin for more information.",
                                // );
                              },
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


          if (isShowLoadingWidget) SizedBox(
            width: Get.width,
            height: Get.height,
            child: LoadingScreen(),
          ),
        ],
      ),
    );
  }
}
