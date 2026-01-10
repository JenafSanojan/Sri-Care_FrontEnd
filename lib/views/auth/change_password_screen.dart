import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sri_tel_flutter_web_mob/Global/global_configs.dart';
import 'package:sri_tel_flutter_web_mob/utils/colors.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/custom_password_field_widget.dart';

import '../../controllers/auth_controller.dart';
import '../../widget_common/custom_text_widget.dart';
import '../../widget_common/snack_bar.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final controller = Get.find<AuthController>();
  bool isObscure = true;

  void toggleObscure() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  bool isChangingPassword = false;

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool passwordsMatch() {
    return newPasswordController.text == confirmPasswordController.text;
  }

  bool passwordIsValid() {
    return (newPasswordController.text.length >= 4 &&
        oldPasswordController.text.isNotEmpty);
  }

  void _changePassword() async {
    print("Changing Password...");
    if(mounted){
      setState(() {
        isChangingPassword = true;
      });
    }
    if (GlobalAuthData.isInitialized == false) {
      print("GlobalAuthData is not initialized");
      return;
    }
    if (passwordsMatch() && passwordIsValid()) {
      controller.changePassword(user: GlobalAuthData.instance.user,
          currentPassword: oldPasswordController.text,
          newPassword: newPasswordController.text);
    } else {
      CommonLoaders.errorSnackBar(
        title: "Invalid new password",
        duration: 3,
        message:
        "Password should have at least 4 characters and match",
      );
    }
    if(mounted){
      setState(() {
        isChangingPassword = false;
      });
    }
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: Get.width,
          height: 650,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Change Password",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                customPasswordField(
                  hint: "Old Password",
                  // title: "Old Password",
                  isObscure: isObscure,
                  iconCallback: toggleObscure,
                  // fillColor: textfield_fillColor,
                  controller: oldPasswordController, // Add controller
                ),
                const SizedBox(height: 20),
                customPasswordField(
                  hint: "New Password",
                  // title: "New Password",
                  isObscure: true,
                  // fillColor: textfield_fillColor,
                  controller: newPasswordController, // Add controller
                ),
                const SizedBox(height: 10),
                customPasswordField(
                  hint: "Confirm New Password",
                  // title: "Confirm new Password",
                  isObscure: true,
                  // fillColor: textfield_fillColor,
                  controller: confirmPasswordController, // Add controller
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: orangeColor,
                            elevation: 0.1,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 7,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _changePassword,
                          child: isChangingPassword
                              ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.green.shade900,
                            ),
                          )
                              : const Text(
                            "Save",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20.0),
                      SizedBox(
                        width: 150,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(color: Colors.red, width: 1),
                          ),
                          onPressed: () {
                            Get.back(result: 500);
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
