import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../entities/provisioning/telco_package.dart';
import '../../utils/colors.dart';

class PackageSection extends StatelessWidget {
  final String title;
  final List<TelcoPackage> packages;

  const PackageSection({
    super.key,
    required this.title,
    required this.packages,
  });

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
              color: textColorOne, // Black
            ),
          ),
        ),
        // Horizontal Scrollable List
        SizedBox(
          height: 140, // Height of the image cards
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20),
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final package = packages[index];
              return GestureDetector(
                onTap: () => _showPackageDetails(context, package),
                child: Container(
                  width: 220, // Width of each card
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    color: package.demoColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    // Use DecorationImage here if you have real assets:
                    // image: DecorationImage(image: AssetImage(package.imagePath), fit: BoxFit.cover),
                  ),
                  // Temporary child to show text since we don't have real images yet
                  child: Center(
                    child: Text(
                      package.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        shadows: [Shadow(blurRadius: 5, color: Colors.black)],
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

  // The Popup (Dialog) Logic
  void _showPackageDetails(BuildContext context, TelcoPackage package) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: lightYellow, // Cream background
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Image Area
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: package.demoColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Center(
                  child: Icon(Icons.wifi_tethering, size: 50, color: white.withValues(alpha: 0.5)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      package.name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColorOne),
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
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: orangeColor),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: orangeColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          // TODO: Handle Activation Logic Here
                          Navigator.pop(context); // Close dialog
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Package Activated Successfully!")),
                          );
                        },
                        child: const Text("Activate Now", style: TextStyle(color: white, fontSize: 16)),
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

