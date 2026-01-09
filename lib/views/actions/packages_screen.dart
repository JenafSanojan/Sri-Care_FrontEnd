import 'package:flutter/material.dart';

import '../../entities/package.dart';
import '../../utils/colors.dart';
import '../../widget_common/responsive-layout.dart';
import '../../widget_common/special/package_section.dart';

class PackagesScreen extends StatelessWidget {
  PackagesScreen({super.key});

  // Sample Data Generation
  final List<Package> frequentPacks = [
    Package(title: "1.2 GB Anytime", description: "Valid for 10 Days. Best for light browsing.", price: "Rs. 119", demoColor: Colors.brown),
    Package(title: "2.8 GB Anytime", description: "Valid for 21 Days. Great for students.", price: "Rs. 239", demoColor: Colors.green),
    Package(title: "5 GB Work", description: "Valid for 30 Days. 8AM to 5PM.", price: "Rs. 450", demoColor: Colors.blueAccent),
  ];

  final List<Package> hotSellers = [
    Package(title: "Unlimited Calls", description: "Any Network Calls + Free 3GB.", price: "Rs. 351", demoColor: Colors.black87),
    Package(title: "Super Combo", description: "Non-stop Social Media + 30GB.", price: "Rs. 479", demoColor: Colors.teal),
  ];

  final List<Package> unlimitedPlans = [
    Package(title: "Non-Stop YouTube", description: "Unlimited YouTube 360p + 1GB Extra.", price: "Rs. 250", demoColor: Colors.redAccent),
    Package(title: "Gaming Blaster", description: "Low ping for PUBG/FreeFire.", price: "Rs. 500", demoColor: Colors.deepPurple),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: Scaffold(
        backgroundColor: lightYellow,
        appBar: AppBar(
          backgroundColor: orangeColor,
          title: const Text("Packages", style: TextStyle(color: white, fontWeight: FontWeight.w700)),
          elevation: 0,
          leading: const Icon(Icons.menu, color: white),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.mail, color: white)),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.only(top: 10, bottom: 30),
          children: [
            PackageSection(title: "Frequently Activated Packs", packages: frequentPacks),
            PackageSection(title: "HOT SELLERS", packages: hotSellers),
            PackageSection(title: "Unlimited Plans", packages: unlimitedPlans),
          ],
        ),
      ),
      webBody: Scaffold(
        backgroundColor: lightYellow,
        appBar: AppBar(title: Text("Packages", style: TextStyle(color: white, fontWeight: FontWeight.w700)), backgroundColor: orangeColor, centerTitle: true,),
        body: Center(
          child: Container(
            width: 800, // Constrain width for web
            color: white,
            child: ListView(
              padding: const EdgeInsets.all(40),
              children: [
                PackageSection(title: "Frequently Activated Packs", packages: frequentPacks),
                const SizedBox(height: 30),
                PackageSection(title: "HOT SELLERS", packages: hotSellers),
                const SizedBox(height: 30),
                PackageSection(title: "Unlimited Plans", packages: unlimitedPlans),
              ],
            ),
          ),
        ),
      ),
    );
  }
}