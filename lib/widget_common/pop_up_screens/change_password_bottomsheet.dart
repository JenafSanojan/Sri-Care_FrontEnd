// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:tasty_owner/common_widget/custom_text_field_with_icon.dart';
// import 'package:tasty_owner/common_widget/custom_text_widget.dart';
// import 'package:tasty_owner/common_widget/snack_bar.dart';
// import 'package:tasty_owner/controller/sign_in_controller.dart';
// import 'package:tasty_owner/services/api_services/user_api_service.dart';
// import 'package:tasty_owner/utils/colors.dart';
//
// class ChangePasswordBottomSheet extends StatefulWidget {
//   final String userId;
//   const ChangePasswordBottomSheet({super.key, required this.userId});
//
//   @override
//   _ChangePasswordBottomSheetState createState() =>
//       _ChangePasswordBottomSheetState();
// }
//
// class _ChangePasswordBottomSheetState extends State<ChangePasswordBottomSheet> {
//   bool isObscure = true;
//   void toggleObscure(){
//     setState(() {
//       isObscure = !isObscure;
//     });
//   }
//
//   bool isChangingPassword = false;
//
// TextEditingController oldPasswordController = TextEditingController();
//   TextEditingController newPasswordController = TextEditingController();
//   TextEditingController confirmPasswordController = TextEditingController();
//
//   bool passwordsMatch() {
//     return newPasswordController.text == confirmPasswordController.text;
//   }
//
//   bool passwordIsValid() {
//     return (newPasswordController.text.length >= 4 && oldPasswordController.text.isNotEmpty);
//   }
//
//   @override
//   void dispose() {
//     newPasswordController.dispose();
//     confirmPasswordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: SizedBox(
//         width: Get.width,
//         height: 650,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 "Change Password",
//                 style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(
//                 height: 50,
//               ),
//               customTextFieldWithIcon(
//                 hint: "Old Password",
//                 // title: "Old Password",
//                 isPass: isObscure,
//                 callback: toggleObscure,
//                 // fillColor: textfield_fillColor,
//                 controller: oldPasswordController, // Add controller
//               ),
//               const SizedBox(height: 20,),
//               customTextField(
//                 hint: "New Password",
//                 // title: "New Password",
//                 isPass: true,
//                 // fillColor: textfield_fillColor,
//                 controller: newPasswordController, // Add controller
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               customTextField(
//                 hint: "Confirm Password",
//                 // title: "Confirm new Password",
//                 isPass: true,
//                 // fillColor: textfield_fillColor,
//                 controller: confirmPasswordController, // Add controller
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               Padding(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     SizedBox(
//                       width: 150,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: orangeColor,
//                           elevation: 0.1,
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 10, horizontal: 7),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         onPressed: () async {
//                           print("Changing Password...");
//                           setState(() {
//                             isChangingPassword = true;
//                           });
//                           if (passwordsMatch() && passwordIsValid()) {
//                             UserApiService userApiService = UserApiService();
//                             bool result = await userApiService.updatePassword(widget.userId, oldPasswordController.text, newPasswordController.text);
//
//                             if(result == true){
//                               // Get.back();
//                               var controller = Get.put(SignInController());
//                               controller.logout();
//                               CommonLoaders.successSnackBar(title: "Password Changed Successfully", duration: 3, message: "Please Login again to continue");
//                             }
//                           } else {
//                             CommonLoaders.errorSnackBar(title: "Invalid new password", duration: 3, message: "Password should have atleast 4 chars and match");
//                           }
//                           setState(() {
//                             isChangingPassword = false;
//                           });
//                         },
//                         child:
//                         isChangingPassword
//                             ?
//                         Center(
//                           child: CircularProgressIndicator(
//                             color: Colors.green.shade900,
//                           ),
//                         )
//                             :
//                         const Text(
//                           "Save",
//                           style: TextStyle(
//                               fontWeight: FontWeight.normal,
//                               color: white,
//                               fontSize: 14),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 20.0,
//                     ),
//                     SizedBox(
//                       width: 150,
//                       child: OutlinedButton(
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 10, horizontal: 2),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           side: const BorderSide(
//                             color: Colors.red,
//                             width: 1,
//                           ),
//                         ),
//                         onPressed: () {
//                           Get.back(result: 500);
//                         },
//                         child: const Text(
//                           "Cancel",
//                           style: TextStyle(
//                             fontWeight: FontWeight.normal,
//                             color: Colors.red,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
