import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sri_tel_flutter_web_mob/services/package_service.dart';
import '../../entities/provisioning/telco_package.dart';
import '../../utils/colors.dart';
import 'package:get/get.dart';

class PackageSection extends StatelessWidget {
  final String title;
  final List<TelcoPackage> packages;
  final random = Random();
  // final Function(TelcoPackage package) activatePackageCallback;

  PackageSection({
    super.key,
    required this.title,
    required this.packages,
    // required this.activatePackageCallback,
  });

  void _activatePackage(TelcoPackage package) {
    PackageService packageService = PackageService();
    // if(package.isData){
    //   packageService.activateDataPackage(phoneNumber: GlobalAuthData.instance.user.mobileNumber ?? '', packageId: package.id, balance: balance)
    // } else if(package.isVoice){
    //   packageService.activateVoicePackage(phoneNumber: GlobalAuthData.instance.user.mobileNumber ?? '', packageId: package.id, balance: balance)
    // } else if(package.isVAS){
    //   packageService.activateVASPackage(phoneNumber: GlobalAuthData.instance.user.mobileNumber ?? '', packageId: package.id, balance: balance)
    // } else {
    //   CommonLoaders.errorSnackBar(
    //       title: "Activation Error",
    //       duration: 3,
    //       message: "Unknown package type");
    //   return;
    // }
  }

  // --- 1. Define Random/Suitable Colors ---
  static final List<Color> _cardColors = [
    const Color(0xFF1B5E20), // Dark Green
    const Color(0xFF0D47A1), // Dark Blue
    const Color(0xFFB71C1C), // Dark Red
    const Color(0xFFE65100), // Dark Orange
    const Color(0xFF4A148C), // Dark Purple
    const Color(0xFF006064), // Dark Cyan
    const Color(0xFF263238), // Dark Blue Grey
    const Color(0xFF212121), // Dark Grey
    const Color(0xFF3E2723), // Dark Brown
    const Color(0xFF880E4F), // Dark Pink
    const Color(0xFF1A237E), // Deep Indigo
    const Color(0xFF004D40), // Deep Teal
    const Color(0xFF33691E), // Light Olive/Dark Green
    const Color(0xFF827717), // Dark Lime
    const Color(0xFFF57F17), // Dark Amber
    const Color(0xFFBF360C), // Deep Deep Orange
    const Color(0xFF311B92), // Deep Deep Purple
    const Color(0xFF01579B), // Light Navy
    const Color(0xFF000000), // Black (The darkest)
    const Color(0xFF424242), // Charcoal Grey
  ];

  // Helper to get a stable color based on index
  Color _getCardColor(int index) {
    return _cardColors[random.nextInt(100) % _cardColors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColorOne,
            ),
          ),
        ),
        // --- 2. Grid Layout (Multiline) ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            // Important: These two properties allow the Grid to exist inside a Scrollable Parent
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),

            itemCount: packages.length,
            // Responsive Grid: Tiles will be max 200px wide, fitting as many as possible per row
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              childAspectRatio: 1.4, // Adjust this to change card height ratio
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemBuilder: (context, index) {
              final package = packages[index];
              final color = _getCardColor(index); // Get random color

              return GestureDetector(
                onTap: () => _showPackageDetails(context, package, color),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            package.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18, // Slightly smaller font for grid
                              shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            "Rs. ${package.cost}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // --- 3. Updated Popup to accept Color ---
  void _showPackageDetails(BuildContext context, TelcoPackage package, Color cardColor) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: lightYellow,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Image Area
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: cardColor, // Use the passed color
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Center(
                  child: Icon(Icons.wifi_tethering,
                      size: 50, color: white.withValues(alpha: 0.5)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      package.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColorOne),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      package.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: greyColor),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Rs. ${package.cost}",
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: orangeColor),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Validity: ${package.validity} days",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: greyColor),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: orangeColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          _activatePackage(package);
                        },
                        child: const Text("Activate Now",
                            style: TextStyle(color: white, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}