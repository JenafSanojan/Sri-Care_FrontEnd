import 'package:flutter/material.dart';

import '../../entities/provisioning/telco_package.dart';
import '../../utils/colors.dart';
import '../../widget_common/responsive-layout.dart';
import '../../widget_common/special/package_section.dart';
import 'package:get/get.dart';

import 'notification_screen.dart';

class PackagesScreen extends StatelessWidget {
  final VoidCallback? drawerCallback;
  final bool dontShowBackButton;

  PackagesScreen(
      {Key? key, this.drawerCallback, this.dontShowBackButton = false})
      : super(key: key);

  // Sample Data Generation
  final List<TelcoPackage> frequentPacks = [
    TelcoPackage(
        name: "1.2 GB Anytime",
        description: "Valid for 10 Days. Best for light browsing.",
        cost: 119,
        validity: 10,
        demoColor: Colors.brown),
    TelcoPackage(
        name: "2.8 GB Anytime",
        description: "Valid for 21 Days. Great for students.",
        cost: 239,
        validity: 21,
        demoColor: Colors.green),
    TelcoPackage(
        name: "5 GB Work",
        description: "Valid for 30 Days. 8AM to 5PM.",
        validity: 30,
        cost: 450,
        demoColor: Colors.blueAccent),
  ];

  final List<TelcoPackage> hotSellers = [
    TelcoPackage(
        name: "Unlimited Calls",
        description: "Any Network Calls + Free 3GB. Valid for 30 days.",
        cost: 351,
        validity: 30,
        demoColor: Colors.black87),
    TelcoPackage(
        name: "Super Combo",
        description: "Non-stop Social Media + 30GB. Valid for 30 days.",
        cost: 479,
        validity: 30,
        demoColor: Colors.teal),
  ];

  final List<TelcoPackage> unlimitedPlans = [
    TelcoPackage(
        name: "Non-Stop YouTube",
        description: "Unlimited YouTube 360p + 1GB Extra. Valid for 30 days.",
        cost: 250,
        validity: 30,
        demoColor: Colors.redAccent),
    TelcoPackage(
        name: "Gaming Blaster",
        description: "Low ping for PUBG/FreeFire. Valid for 30 days.",
        cost: 500,
        validity: 30,
        demoColor: Colors.deepPurple),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: Scaffold(
        backgroundColor: lightYellow,
        appBar: AppBar(
          backgroundColor: orangeColor,
          title: const Text("Packages",
              style: TextStyle(color: white, fontWeight: FontWeight.w700)),
          elevation: 0,
          centerTitle: true,
          leading: dontShowBackButton
              ? SizedBox()
              : IconButton(
                  icon: const Icon(Icons.arrow_back, color: white),
                  onPressed: Get.back),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationScreen()));
                },
                icon: const Icon(Icons.mail, color: white)),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.only(top: 10, bottom: 30),
          children: [
            PackageSection(title: "Internet Packages", packages: frequentPacks),
            PackageSection(title: "Voice Packages", packages: hotSellers),
          ],
        ),
      ),
      webBody: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Scaffold(
          backgroundColor: lightYellow,
          appBar: AppBar(
            title: Text("Packages",
                style: TextStyle(color: white, fontWeight: FontWeight.w700)),
            backgroundColor: orangeColor,
            centerTitle: true,
          ),
          body: Center(
            child: Container(
              width: 800, // Constrain width for web
              color: white,
              child: ListView(
                padding: const EdgeInsets.all(40),
                children: [
                  PackageSection(
                      title: "Data Packages",
                      packages: frequentPacks),
                  const SizedBox(height: 30),
                  PackageSection(
                      title: "Voice Packages", packages: unlimitedPlans),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
