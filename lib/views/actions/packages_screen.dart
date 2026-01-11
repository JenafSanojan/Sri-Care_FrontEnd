import 'package:flutter/material.dart';
import 'package:sri_tel_flutter_web_mob/services/package_service.dart';
import 'package:get/get.dart';

import '../../entities/provisioning/telco_package.dart';
import '../../utils/colors.dart';
import '../../widget_common/responsive-layout.dart';
import '../../widget_common/special/package_section.dart';
import 'notification_screen.dart';

class PackagesScreen extends StatefulWidget {
  final VoidCallback? drawerCallback;
  final bool dontShowBackButton;

  PackagesScreen(
      {Key? key, this.drawerCallback, this.dontShowBackButton = false})
      : super(key: key);

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  List<TelcoPackage> voicePackages = [];
  List<TelcoPackage> dataPackages = [];

  void _loadPackages() async {
    final loadedVoicePackages = await PackageService().getVoicePackages() ?? [];
    final loadedDataPackages = await PackageService().getDataPackages() ?? [];

    setState(() {
      voicePackages = loadedVoicePackages;
      dataPackages = loadedDataPackages;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPackages();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: ResponsiveLayout(
        mobileBody: Scaffold(
          backgroundColor: lightYellow,
          appBar: AppBar(
            backgroundColor: orangeColor,
            title: const Text("Packages",
                style: TextStyle(color: white, fontWeight: FontWeight.w700)),
            elevation: 0,
            centerTitle: true,
            leading: widget.dontShowBackButton
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
            // Added TabBar
            bottom: const TabBar(
              indicatorColor: white,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(text: "Internet"),
                Tab(text: "Voice"),
              ],
            ),
          ),
          // Changed to TabBarView
          body: TabBarView(
            children: [
              // Tab 1: Internet Packages
              ListView(
                padding: const EdgeInsets.only(top: 10, bottom: 30),
                children: [
                  PackageSection(
                      title: "Internet Packages", packages: dataPackages),
                ],
              ),
              // Tab 2: Voice Packages
              ListView(
                padding: const EdgeInsets.only(top: 10, bottom: 30),
                children: [
                  PackageSection(
                      title: "Voice Packages", packages: voicePackages),
                ],
              ),
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
              // Added TabBar for Web as well for consistency
              bottom: const TabBar(
                indicatorColor: white,
                labelColor: white,
                unselectedLabelColor: Colors.white70,
                tabs: [
                  Tab(text: "Data"),
                  Tab(text: "Voice"),
                ],
              ),
            ),
            body: Center(
              child: Container(
                width: 800,
                color: white,
                // Changed to TabBarView
                child: TabBarView(
                  children: [
                    ListView(
                      padding: const EdgeInsets.all(40),
                      children: [
                        PackageSection(
                            title: "Data Packages", packages: dataPackages),
                      ],
                    ),
                    ListView(
                      padding: const EdgeInsets.all(40),
                      children: [
                        PackageSection(
                            title: "Voice Packages", packages: voicePackages),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}