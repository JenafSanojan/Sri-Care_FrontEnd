import 'package:flutter/material.dart';
import 'package:sri_tel_flutter_web_mob/Global/global_configs.dart';
import 'package:sri_tel_flutter_web_mob/views/actions/billing_history_screen.dart';
import 'package:sri_tel_flutter_web_mob/views/actions/notification_screen.dart';
import 'package:sri_tel_flutter_web_mob/views/profile/profile_screen.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/responsive-layout.dart';
import '../../utils/colors.dart';
import '../../widget_common/special/bill_tile.dart';
import '../../widget_common/special/circular_usage_indicator.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback? drawerCallback;

  const DashboardScreen({Key? key, this.drawerCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: const MobileDashboard(),
      webBody: const WebDashboard(),
    );
  }
}

// --- MOBILE DASHBOARD ---
class MobileDashboard extends StatelessWidget {
  final VoidCallback? openDrawer;

  const MobileDashboard({super.key, this.openDrawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        title: const Text("Sri Care",
            style: TextStyle(color: white, fontWeight: FontWeight.w700)),
        backgroundColor: orangeColor,
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.menu, color: white),
            onPressed: () => {
                  openDrawer != null
                      ? openDrawer!()
                      : Scaffold.of(context).openDrawer(),
                }),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Header Section with Gradient
            Container(
              padding: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [orangeColor, textLightGreenColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Greetings, ${GlobalAuthConfigs.instance.user.displayName}",
                              style:
                                  const TextStyle(color: white, fontSize: 16)),
                          const SizedBox(height: 5),
                          Text("${GlobalAuthConfigs.instance.user.mobileNumber}",
                              style: TextStyle(
                                  color: white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      InkWell(
                        child: const CircleAvatar(
                          radius: 25,
                          backgroundColor: white,
                          child:
                              Icon(Icons.person, color: orangeColor, size: 30),
                        ),
                        onTap: () => {Get.to(() => const ProfileScreen())},
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Current Package Info Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Connection Status", //Current Package",
                                style: TextStyle(color: white, fontSize: 14)),
                            SizedBox(height: 5),
                            Text("Active", //"Super 4G Blaster",
                                style: TextStyle(
                                    color: Colors.green.withAlpha(200),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        // Text("LKR 950/mo",
                        //     style: TextStyle(
                        //         color: white,
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Usage Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                color: white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Wallet & Voice Balance",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColorOne)),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildCircularIndicator(
                              title: "Mobile Balance",
                              value:
                                  "${GlobalAuthConfigs.instance.user.walletBalance}",
                              unit: "Rs.",
                              percent: 0.0),
                          buildCircularIndicator(
                              title: "Voice Usage",
                              value: "${GlobalAuthConfigs.instance.user.voice}",
                              unit: "Mins",
                              percent: GlobalAuthConfigs.instance.user.voice == 0 ? 0.0 : 0.4),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Recent Bills Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Recent Bills",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColorOne)),
                      TextButton(
                          onPressed: () => Get.to(() => BillingHistoryScreen()),
                          child: const Text("See All",
                              style: TextStyle(color: orangeColor))),
                    ],
                  ),
                  buildBillTile("Jan 2026", "Paid", "LKR 1,250", true),
                  buildBillTile("Dec 2025", "Overdue", "LKR 1,400", false),
                  buildBillTile("Nov 2025", "Paid", "LKR 1,250", true),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// --- WEB DASHBOARD ---
class WebDashboard extends StatelessWidget {
  const WebDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightYellow,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            // 1. Web Header (Greetings & Package)
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [orangeColor, textLightGreenColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  InkWell(
                    child: const CircleAvatar(
                      radius: 35,
                      backgroundColor: white,
                      child: Icon(Icons.person, color: orangeColor, size: 40),
                    ),
                    onTap: () => {Get.to(() => const ProfileScreen())},
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "greetings, ${GlobalAuthConfigs.instance.user.displayName}", //"Good Morning,",
                          style: TextStyle(color: white, fontSize: 18)),
                      Text("${GlobalAuthConfigs.instance.user.mobileNumber}",
                          style: TextStyle(
                              color: white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Spacer(),
                  // Package Info styled for Web
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    decoration: BoxDecoration(
                      color: white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Connection Status", //"Current Package",
                            style: TextStyle(color: white, fontSize: 14)),
                        Text("Active", //"Super 4G Blaster",
                            style: TextStyle(
                                color: Colors.green.withAlpha(200),
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                        // Text("LKR 950/mo",
                        //     style: TextStyle(
                        //         color: white,
                        //         fontSize: 18,
                        //         fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 2. Usage Section (Two Cards Side-by-Side)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Voice Usage
                Expanded(
                  child: Container(
                    height: 250,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        color: white, borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        const Text("Mobile Balance",
                            style: TextStyle(fontSize: 18, color: greyColor)),
                        const Spacer(),
                        // Using the shared helper with larger dimensions if needed,
                        // but standard size works well centered
                        buildCircularIndicator(
                            title: "",
                            value:
                                "${GlobalAuthConfigs.instance.user.walletBalance}",
                            unit: "Rs.",
                            percent: 0.0,
                            height: 80,
                            width: 80),
                        const Spacer(),
                        Text("Rs. ${GlobalAuthConfigs.instance.user.walletBalance}",
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textColorOne)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                // Data Usage
                Expanded(
                  child: Container(
                    height: 250,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        color: white, borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        const Text("Voice Usage",
                            style: TextStyle(fontSize: 18, color: greyColor)),
                        const Spacer(),
                        buildCircularIndicator(
                            title: "",
                            value: "${GlobalAuthConfigs.instance.user.voice}",
                            unit: "Mins",
                            percent: GlobalAuthConfigs.instance.user.voice == 0 ? 0.0 : 0.4,
                            width: 80,
                            height: 80),
                        const Spacer(),
                        Text("${GlobalAuthConfigs.instance.user.voice} Mins Left",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textColorOne)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 3. Recent Bills Section (Expanded for Web)
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                  color: white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Recent Bills",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: textColorOne)),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: orangeColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () => Get.to(() => BillingHistoryScreen()),
                          child: const Text("View All History",
                              style: TextStyle(color: white))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // List of bills using shared helper
                  buildBillTile("Jan 2026", "Paid", "LKR 1,250", true),
                  buildBillTile("Dec 2025", "Overdue", "LKR 1,400", false),
                  buildBillTile("Nov 2025", "Paid", "LKR 1,250", true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
