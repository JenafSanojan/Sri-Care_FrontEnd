import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:sri_tel_flutter_web_mob/views/home/main_screen.dart';
import '../Global/global_configs.dart';
import '../services/user_service.dart';
import '../views/auth/login_screen.dart';
import '../widget_common/snack_bar.dart';
import '../entities/user.dart';
import 'network_manager.dart';

class AuthController extends GetxController {
  final localStorage = GetStorage();
  UserService userApiService = UserService();

  Future<bool> isLocalLoginRecordsExist() async {
    User? user = localStorage.read("CurrentUser") != null
        ? User.fromJson(localStorage.read("CurrentUser"))
        : null;
    // old records exist ---------------------------
    if (user != null && user.uid != null && user.uid!.isNotEmpty) {
      return true; // this says go to home screen
    }
    // old records doesn't exist -------------------
    localStorage.erase();
    Get.offAll(() => LoginScreen());
    return false;
  }
  Future<bool> reVerifyLogin() async {
    User? user = localStorage.read("CurrentUser") != null
        ? User.fromJson(localStorage.read("CurrentUser"))
        : null;
    String? password = localStorage.read("Password");
    if (user != null &&
        user.uid != null &&
        user.email.isNotEmpty &&
        user.token != null &&
        user.token!.isNotEmpty &&
        password != null &&
        password.isNotEmpty) {
      final User? responseUser = await userApiService
          .signInWithEmailAndPassword(user.email, password);
      if (responseUser != null) {
        setAuthGlobals(responseUser);
        return true;
      }
      return false;
    }
    return false;
  }
  Future<bool> persistLoginInStorage(User user, String password) async {
    try {
      localStorage.write("CurrentUser", user.toJson());
      localStorage.write("Password", password);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
  void setAuthGlobals(User user) {
    if (GlobalAuthConfigs.isInitialized == false) {
      GlobalAuthConfigs.initialize(user);
    }
  }


  Future<String?> signUp(
      {required String displayName,
      required String email,
      required String password,
      required String profilePhoto,
      required String mobileNumber,
      required bool isSocialMedia}) async {
    try {
      // checking the connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        CommonLoaders.warningSnackBar(
            title: "No internet",
            duration: 2,
            message: "Connect and try again");
        return null;
      }

      if (email.isEmpty || password.isEmpty) {
        throw Exception("Email and Password cannot be empty");
      }
      // calling api
      await userApiService
          .signUpWithEmailAndPassword(
              email: email,
              password: password,
              displayName: displayName,
              mobileNumber: mobileNumber)
          .then((user) async {
        if (user != null &&
            user.uid != null &&
            user.uid!.isNotEmpty &&
            user.token != null) {
          var userId = user.uid;
          await persistLoginInStorage(user, password);
          setAuthGlobals(user);
          CommonLoaders.successSnackBar(
              title: "Sign Up Successful",
              message: "Welcome, $displayName",
              duration: 3);
          print("User signed up with ID: $userId");
          await Get.offAll(() => MainScreen());
          return userId;
        } else {
          print("Failed to sign up user.");
        }
      }).catchError((error) {
        print("Error signing up admin user: $error");
        CommonLoaders.errorSnackBar(
            title: "Something went wrong",
            duration: 3,
            message: "Please try again later");
      });
    } catch (e) {
      print(e);
      CommonLoaders.errorSnackBar(
          title: 'Error..', duration: 3, message: e.toString());
      return null;
    }
    return null;
  }

  Future<void> emailAndPasswordSignIn(
      {required String emailOrPhoneNumber, required String password}) async {
    try {
      // checking the connection
      final isConnected = await NetworkManager.instance.isConnected();
      // print(isConnected);
      if (!isConnected) {
        CommonLoaders.errorSnackBar(
            title: "No Internet",
            duration: 3,
            message: "Make sure you're connected and try again");
        return;
      }

      // signing in with email and password
      final User? user = await userApiService.signInWithEmailAndPassword(
          emailOrPhoneNumber, password);

      // Checking response
      if (user != null && user.uid != null && user.uid!.isNotEmpty && user.token != null) {
        print(user.toString());

        CommonLoaders.successSnackBar(
            title: "Login Successful",
            message: 'Login attempt is successful.',
            duration: 3);

        await persistLoginInStorage(user, password);
        setAuthGlobals(user);
        await Get.offAll(() => MainScreen());
      }
      // last resort
      // Get.offAll(()=>LoginScreen());
    } catch (e) {
      CommonLoaders.errorSnackBar(
          title: "Error..", duration: 3, message: e.toString());
    }
  }

  Future<void> logout() async {
    GlobalAuthConfigs.clear();
    await localStorage.erase();
    Get.offAll(() => LoginScreen());
  }

  Future<void> sendResetPasswordLink({required String email}) async {
    try {
      // checking the connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        CommonLoaders.errorSnackBar(
            title: "No Internet",
            duration: 3,
            message: "Make sure you're connected and try again");
        return;
      }
      bool isSent = await userApiService.sendPasswordResetEmail(email);
      if(isSent){
        CommonLoaders.successSnackBar(
            title: "Email Sent",
            message: "Password reset link has been sent to $email",
            duration: 3);
        await Get.offAll(() => LoginScreen());
      }
    } catch (e) {
      CommonLoaders.errorSnackBar(
          title: "Error..", duration: 3, message: e.toString());
    }
  }

  Future<void> changePassword({required User user, required String currentPassword, required String newPassword}) async {
    try {
      // checking the connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        CommonLoaders.errorSnackBar(
            title: "No Internet",
            duration: 3,
            message: "Make sure you're connected and try again");
        return;
      }
      if(GlobalAuthConfigs.isInitialized == false){
        throw Exception("User not logged in");
      }
      bool? isChanged = await userApiService.changePassword(user, currentPassword, newPassword);
      if(isChanged != null && isChanged == true){
        CommonLoaders.successSnackBar(
            title: "Password Changed",
            message: "Your password has been changed successfully. Login again to continue.",
            duration: 3);
        await logout();
      }
    } catch (e) {
      CommonLoaders.errorSnackBar(
          title: "Error..", duration: 3, message: e.toString());
    }
  }

  // Future<void> verifyOtp({required String otp}) async {
  //   final currentUserInJson = localStorage.read("CurrentUser");
  //   if (currentUserInJson != null) {
  //     User _user = User.fromJson(currentUserInJson);
  //     if (_user.otp == otp) {
  //       Get.offAll(() => HomeScreen());
  //     } else {
  //       Get.offAll(
  //           () => VerificationScreen()); // Have to count the attempts too.
  //     }
  //   }
  // }
}
