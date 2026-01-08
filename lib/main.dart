// https://api-gateway-ysfa.onrender.com -- api gateway

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:sri_tel_flutter_web_mob/views/home/splash_screen.dart';
import 'controllers/network_manager.dart';

import 'package:sri_tel_flutter_web_mob/providers/catgory_provider.dart';

Future<void> main() async {
  // should show a splash screen before initializing firebase and all
  // await initializeFirebase();
  await GetStorage.init();
  Get.put(NetworkManager());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

// Future<void> initializeFirebase() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
// }



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sri Care',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
    );
  }
}