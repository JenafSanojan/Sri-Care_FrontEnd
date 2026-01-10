import 'package:flutter/material.dart';
import 'package:sri_tel_flutter_web_mob/Global/global_configs.dart';
import 'package:sri_tel_flutter_web_mob/entities/user.dart';
import 'package:sri_tel_flutter_web_mob/views/profile/wallet_screen.dart';
import '../../utils/colors.dart';
import '../../widget_common/responsive-layout.dart';
import 'edit_profile_screen.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Get user from global state
  // Note: In a real app, you might wrap this in a Consumer/GetX builder to listen for updates
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    try {
      _currentUser = GlobalAuthData.instance.user;
    } catch (e) {
      // Fallback for UI testing if GlobalAuthData isn't initialized
      _currentUser = User(
        uid: "test_123",
        email: "guest@sritel.com",
        displayName: "Sritel User",
        mobileNumber: "077 000 0000",
        isProfileComplete: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: _buildContent(isWeb: false),
      webBody: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: _buildContent(isWeb: true),
        ),
      ),
    );
  }

  Widget _buildContent({required bool isWeb}) {
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        backgroundColor: orangeColor,
        elevation: 0,
        title: const Text("My Profile",
            style: TextStyle(color: white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: white),
            onPressed: () {
              Get.to(() => const EditProfileScreen());
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER SECTION ---
            Container(
              padding: const EdgeInsets.only(bottom: 30),
              decoration: const BoxDecoration(
                color: orangeColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // Profile Image
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: white,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: lightYellow,
                            backgroundImage: _currentUser.photoURL != null
                                ? NetworkImage(_currentUser.photoURL!)
                                : null,
                            child: _currentUser.photoURL == null
                                ? const Icon(Icons.person,
                                    size: 60, color: orangeColor)
                                : null,
                          ),
                        ),
                        // Status Indicator
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                                color: white, shape: BoxShape.circle),
                            child: Icon(
                              Icons.circle,
                              size: 20,
                              color: _currentUser.isActive
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      _currentUser.displayName ?? "No Name",
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: white),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _currentUser.email,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // --- PROFILE COMPLETENESS WARNING ---
            if (_currentUser.isProfileComplete == false)
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.red),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Text(
                        "Your profile is incomplete. Please update your details.",
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        size: 14, color: Colors.red.withValues(alpha: 0.5)),
                  ],
                ),
              ),

            // --- INFO TILES ---
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildProfileTile(
                    icon: Icons.phone_android,
                    title: "Mobile Number",
                    value: _currentUser.mobileNumber ?? "Not Set",
                  ),
                  _buildProfileTile(
                    icon: Icons.calendar_today,
                    title: "Member Since",
                    value: _currentUser.createdAt != null
                        ? "${_currentUser.createdAt!.toDate().year}" // Simple formatting
                        : "Unknown",
                  ),
                  _buildProfileTile(
                    icon: Icons.verified_user_outlined,
                    title: "Account Status",
                    value: _currentUser.isActive ? "Active" : "Inactive",
                    valueColor:
                        _currentUser.isActive ? Colors.green : Colors.red,
                  ),
                  _buildProfileTile(
                      icon: Icons.wallet,
                      title: "Wallet Balance",
                      value: "LKR 1,250.00",
                      // Placeholder until Wallet logic is connected
                      valueColor: orangeColor,
                      showArrow: true,
                      onTap:  () {
                        Get.to(() => const WalletScreen());
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required String value,
    Color valueColor = greyColor,
    bool showArrow = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: lightYellow,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: orangeColor),
        ),
        title:
            Text(title, style: const TextStyle(fontSize: 14, color: greyColor)),
        subtitle: Text(
          value,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: valueColor),
        ),
        trailing: showArrow
            ? const Icon(Icons.arrow_forward_ios, size: 16, color: greyColor)
            : null,
      ),
    );
  }
}
