import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../entities/popup_item.dart';
import '../../utils/colors.dart';
import '../../widget_common/pop_up_screens/selection_popup.dart';
import 'package:get/get.dart';

import '../auth/change_password_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final controller = Get.put(AuthController());

  // State variables for toggles
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _currentLanguage = "English";

  // Language Options
  final List<PopupItem> _languages = [
    PopupItem(name: "English", returnCode: 0),
    PopupItem(name: "සිංහල (Sinhala)", returnCode: 1),
    PopupItem(name: "தமிழ் (Tamil)", returnCode: 2),
  ];

  // Logic to handle language change
  void _changeLanguage() async {
    // Call our reusable popup
    final int? result = await showSelectionPopup(context, "Select Language", _languages);

    // Update state based on return code
    if (result != null) {
      setState(() {
        if (result == 0) _currentLanguage = "English";
        if (result == 1) _currentLanguage = "Sinhala";
        if (result == 2) _currentLanguage = "Tamil";
      });
      // Here you would typically call your localization controller update method
    }
  }

  void _logout() {
    controller.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        backgroundColor: orangeColor,
        elevation: 0,
        title: const Text("Settings", style: TextStyle(color: white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- Section 1: App Preferences ---
            _buildSectionHeader("Preferences"),

            // Custom Switch Tile for Theme
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: SwitchListTile(
                activeColor: orangeColor,
                secondary: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: lightYellow, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.dark_mode_outlined, color: orangeColor),
                ),
                title: const Text("Dark Theme", style: TextStyle(fontWeight: FontWeight.bold, color: textColorOne)),
                value: _isDarkMode,
                onChanged: (val) {
                  setState(() => _isDarkMode = val);
                },
              ),
            ),

            // Custom Switch Tile for Notifications
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: SwitchListTile(
                activeColor: orangeColor,
                secondary: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: lightYellow, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.notifications_outlined, color: orangeColor),
                ),
                title: const Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold, color: textColorOne)),
                value: _notificationsEnabled,
                onChanged: (val) {
                  setState(() => _notificationsEnabled = val);
                },
              ),
            ),

            const SizedBox(height: 25),

            // --- Section 2: Account ---
            _buildSectionHeader("General"),
            _buildSettingsTile(
              icon: Icons.person_outline,
              title: "Account Settings",
              subtitle: "Manage profile & security",
              onTap: () {
                // Route to user profile page
                // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Routing to Profile...")));
              },
            ),
            _buildSettingsTile(
              icon: Icons.language,
              title: "Language",
              subtitle: _currentLanguage, // Shows currently selected language
              onTap: _changeLanguage, // Triggers the popup
            ),
            _buildSettingsTile(
              icon: Icons.password,
              title: "Change Password",
              subtitle: "Change your account password",
              onTap: () => Get.to(() => const ChangePasswordScreen()),
              tileColor: orangeColor
            ),
            _buildSettingsTile(
              icon: Icons.logout,
              title: "Logout",
              subtitle: "Logout from this device",
              onTap: _logout,
              tileColor: orangeColor
            ),
          ],
        ),
      ),
    );
  }

  // Helper for Section Headers
  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15, left: 5),
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: greyColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // Helper for Standard Navigation Tiles
  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color tileColor = white,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: lightYellow,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: orangeColor),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: textColorOne),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: greyColor, fontSize: 12),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: greyColor, size: 16),
      ),
    );
  }
}