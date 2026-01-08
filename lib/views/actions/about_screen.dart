import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widget_common/responsive-layout.dart';
import '../../widget_common/special/feature_item.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: const AboutContent(isWeb: false),
      webBody: const AboutContent(isWeb: true),
    );
  }
}

class AboutContent extends StatelessWidget {
  final bool isWeb;

  const AboutContent({super.key, required this.isWeb});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightYellow, // Brand Cream Background
      appBar: AppBar(
        backgroundColor: orangeColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("About Sri-Care", style: TextStyle(color: white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          // Constrain width on web for better readability
          constraints: BoxConstraints(maxWidth: isWeb ? 800 : double.infinity),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // --- 1. BRAND HEADER ---
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [orangeColor, textLightGreenColor], // Brand Gradient
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: orangeColor.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Placeholder for Logo - using Icon for now
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(
                          color: white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.cell_wifi, size: 50, color: orangeColor),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Sri-Care",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "To Connect Sri-Lanka Like Never Before.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: white,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // --- 2. OUR MISSION CARD ---
                _buildInfoCard(
                  title: "Our Mission",
                  content: "We aim to provide a seamless, state-of-the-art digital experience for all Sri Tel customers. Manage your connection, pay bills, and activate services without the hassle of manual intervention.",
                  icon: Icons.lightbulb_outline,
                ),

                const SizedBox(height: 20),

                // --- 3. FEATURES GRID ---
                const Text(
                  "What You Can Do",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColorOne),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    buildFeatureItem(Icons.receipt_long, "Pay Bills"),
                    const SizedBox(width: 15),
                    buildFeatureItem(Icons.swap_vert, "Reload"),
                    const SizedBox(width: 15),
                    buildFeatureItem(Icons.settings_input_antenna, "Services"),
                  ],
                ),

                const SizedBox(height: 30),

                // --- 4. DEVELOPER / TEAM INFO ---
                // Great for your university assignment submission
                _buildInfoCard(
                  title: "Development Team",
                  content: "Developed by Group 42\nUniversity of Ruhuna\n\n• Student A (ID: 1234)\n• Student B (ID: 5678)\n• Student C (ID: 9012)",
                  icon: Icons.code,
                ),

                const SizedBox(height: 40),

                // --- 5. FOOTER ---
                const Text(
                  "Version 1.0.0 Beta",
                  style: TextStyle(color: greyColor, fontSize: 12),
                ),
                const SizedBox(height: 5),
                const Text(
                  "© 2026 Sri Tel PLC. All rights reserved.",
                  style: TextStyle(color: greyColor, fontSize: 12),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildInfoCard({required String title, required String content, required IconData icon}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: orangeColor),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColorOne),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: greyColor, height: 1.5),
          ),
        ],
      ),
    );
  }

}
