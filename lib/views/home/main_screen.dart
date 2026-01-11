import 'package:flutter/material.dart';
import 'package:sri_tel_flutter_web_mob/Global/global_configs.dart';
import 'package:sri_tel_flutter_web_mob/utils/colors.dart';
import 'package:sri_tel_flutter_web_mob/views/actions/about_screen.dart';
import 'package:sri_tel_flutter_web_mob/views/actions/billing_history_screen.dart';
import 'package:sri_tel_flutter_web_mob/views/actions/notification_screen.dart';
import 'package:sri_tel_flutter_web_mob/views/actions/settings.dart';
import 'package:sri_tel_flutter_web_mob/views/billing/payment_screen.dart';
import 'package:sri_tel_flutter_web_mob/views/billing/pending_bills_screen.dart';
import 'package:sri_tel_flutter_web_mob/views/chat/support_screen.dart';
import 'package:sri_tel_flutter_web_mob/views/home/dashboard.dart';
import 'package:sri_tel_flutter_web_mob/views/actions/services_screen.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/responsive-layout.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../entities/ui_entities.dart';
import '../actions/packages_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  final String title = 'Sri-Care';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<ScaffoldState> mobileScaffoldKey = GlobalKey<ScaffoldState>();

  void toggleDrawer() {
    print("Toggling drawer");
    if (mobileScaffoldKey.currentState != null) {
      if (mobileScaffoldKey.currentState!.isDrawerOpen) {
        mobileScaffoldKey.currentState!.closeDrawer();
      } else {
        mobileScaffoldKey.currentState!.openDrawer();
      }
    }
  }

  final controller = Get.put(AuthController());

  int _selectedMobIndex = 0; // Tracks the currently selected menu item
  int _selectedWebIndex = 0; // Tracks the currently selected menu item
  bool _isSidebarHovered = false; // New state to track sidebar hover
  bool _isSidebarOpen = false; // New state to track sidebar open/close

  // List of destinations/pages for the menu
  static final List<Widget> _webWidgetOptions = <Widget>[
    Center(child: DashboardScreen()),
    Center(
        child: PackagesScreen(
      dontShowBackButton: true,
    )),
    Center(
        child: ServicesScreen(
      dontShowBackButton: true,
    )),
    Center(
        child: PaymentScreen(
      dontShowBackButton: true,
    )),
    Center(
        child: PendingBillsScreen(
      dontShowBackButton: true,
    )),
    Center(
        child: BillingHistoryScreen(
      dontShowBackButton: true,
    )),
    Center(
        child: SupportListScreen(
      dontShowBackButton: true,
    )),
    Center(
        child: NotificationScreen(
      dontShowBackButton: true,
    )),
    Center(
        child: SettingsScreen(
      dontShowBackButton: true,
    )),
    // Center(child: Text('Profile Page', style: TextStyle(fontSize: 24))),
    Center(
        child: AboutScreen(
      dontShowBackButton: true,
    )),
  ];

  static final List<Widget> _mobDrawerWidgetOptions = <Widget>[
    Center(child: DashboardScreen()),
    Center(child: PackagesScreen()),
    Center(child: ServicesScreen()),
    Center(child: PaymentScreen()),
    Center(child: PendingBillsScreen()),
    Center(child: BillingHistoryScreen()),
    Center(child: SupportListScreen()),
    Center(child: NotificationScreen()),
    Center(child: SettingsScreen()),
    // Center(child: Text('Profile Page', style: TextStyle(fontSize: 24))),
    Center(child: AboutScreen()),
  ];

  List<Widget> _mobWidgetOptions() {
    return [
      Center(
          child: DashboardScreen(
        drawerCallback: toggleDrawer,
      )),
      Center(
          child: PackagesScreen(
        drawerCallback: toggleDrawer,
        dontShowBackButton: true,
      )),
      Center(
          child: BillingHistoryScreen(
        drawerCallback: toggleDrawer,
        dontShowBackButton: true,
      )),
      Center(
          child: SettingsScreen(
        drawerCallback: toggleDrawer,
        dontShowBackButton: true,
      )),
    ];
  }

  // List of menu items with their icons and titles
  final List<MenuItem> _webMenuItems = [
    MenuItem(icon: Icons.home, title: 'Home'),
    MenuItem(icon: Icons.folder, title: 'Packages'),
    MenuItem(icon: Icons.miscellaneous_services, title: 'Services'),
    MenuItem(icon: Icons.payment, title: 'Reload/Pay'),
    MenuItem(icon: Icons.pending, title: 'Pending Bills'),
    MenuItem(icon: Icons.gas_meter, title: 'Usage History'),
    MenuItem(icon: Icons.support, title: 'Get Support'),
    MenuItem(icon: Icons.notifications, title: 'Notifications'),
    MenuItem(icon: Icons.settings, title: 'Settings'),
    // MenuItem(icon: Icons.person, title: 'Profile'),
    MenuItem(icon: Icons.info, title: 'About'),
  ];
  final List<MenuItem> _mobMenuItems = [
    MenuItem(icon: Icons.home, title: 'Home'),
    MenuItem(icon: Icons.folder, title: 'Packages'),
    MenuItem(icon: Icons.gas_meter, title: 'Usage'),
    MenuItem(icon: Icons.settings, title: 'Settings'),
  ];

  void _onItemTapped(int index) {
    print("Tapped index: $index");
    if (mounted) {
      setState(() {
        _selectedMobIndex = index;
      });
    }
  }

  void _onMobileDrawerItemTapped(int index) {
    if (index == 0) {
      // for home, just change index
      _onItemTapped(0);
      return;
    } else {
      Get.to(() => _mobDrawerWidgetOptions[index]);
    }
  }

  void _onWebSidebarItemTapped(int index) {
    if (mounted) {
      setState(() {
        _selectedWebIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (GlobalAuthData.isInitialized == false) { // initializing it in splash for now, but this is a fallback and secure way
      print("global auth not initialized, re verifying login");
      controller.reVerifyLogin();
    } else {
      print("global auth already initialized");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: Scaffold(
        key: mobileScaffoldKey,
        body: _mobWidgetOptions().elementAt(_selectedMobIndex),
        // Main content area
        bottomNavigationBar: BottomNavigationBar(
          items: _mobMenuItems.map((item) {
            return BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: '',
            );
          }).toList(),
          currentIndex: _selectedMobIndex,
          // Current selected item
          backgroundColor: Colors.blueGrey[900],
          // Background color for the bar
          selectedItemColor: darkGreen,
          // Color for selected icon
          unselectedItemColor: Colors.grey,
          // Color for unselected icons
          onTap: _onItemTapped,
          // Callback when an item is tapped
          type: BottomNavigationBarType.fixed,
          // Ensures all items are visible
          // Hide labels for both selected and unselected items
          showSelectedLabels: false,
          showUnselectedLabels: false,
          // show a circle around the selected icon
          selectedIconTheme: IconThemeData(
            size: 30, // Size of the selected icon
            color: darkGreen, // Color of the selected icon
          ),
        ),
        drawer: Drawer(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 20.0),
            itemCount: _webMenuItems.length,
            itemBuilder: (context, index) {
              final item = _webMenuItems[index];
              return ListTile(
                leading: Icon(
                  item.icon,
                  color: _selectedMobIndex == index
                      ? darkGreen
                      : Colors.grey, // Icon color based on selection
                ),
                title: Text(
                  item.title,
                  style: TextStyle(
                    color: _selectedMobIndex == index
                        ? darkGreen
                        : Colors.grey, // Text color based on selection
                  ),
                ),
                selected: _selectedMobIndex == index,
                // Highlight selected item
                selectedTileColor: Colors.blueGrey[700],
                // Background color for selected item
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  _onMobileDrawerItemTapped(index);
                },
              );
            },
          ),
        ),
      ),
      webBody: Scaffold(
        body: Row(
          children: <Widget>[
            // Sidebar Container wrapped in MouseRegion for hover detection
            MouseRegion(
              onEnter: (_) => {
                setState(() => _isSidebarHovered = true),
                Future.delayed(const Duration(seconds: 1), () {
                  if (_isSidebarHovered) {
                    setState(() => _isSidebarOpen = true);
                  }
                })
              }, // Set hovered to true after 1 sec on mouse enter
              onExit: (_) => {
                setState(() {
                  _isSidebarHovered = false;
                  _isSidebarOpen = false;
                }),
              }, // Set hovered to false on mouse exit
              child: AnimatedContainer(
                // Use AnimatedContainer for smooth width transitions
                duration:
                    const Duration(milliseconds: 300), // Animation duration
                width: _isSidebarOpen
                    ? 250
                    : 70, // Expanded width vs. collapsed width
                color: Colors.blueGrey[900], // Dark background for sidebar
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 20.0),
                  itemCount: _webMenuItems.length,
                  itemBuilder: (context, index) {
                    final item = _webMenuItems[index];
                    return ListTile(
                      leading: Icon(
                        item.icon,
                        color: _selectedWebIndex == index
                            ? darkGreen
                            : Colors.grey, // Icon color based on selection
                      ),
                      title: _isSidebarOpen
                          ? Text(
                              item.title,
                              style: TextStyle(
                                color: _selectedWebIndex == index
                                    ? darkGreen
                                    : Colors
                                        .grey, // Text color based on selection
                                overflow:
                                    TextOverflow.fade, // Prevent text overflow
                              ),
                              maxLines: 1,
                            )
                          : null,
                      selected: _selectedWebIndex == index,
                      // Highlight selected item
                      selectedTileColor: Colors.blueGrey[700],
                      // Background color for selected item
                      onTap: () => _onWebSidebarItemTapped(index),
                    );
                  },
                ),
              ),
            ),
            // Main content area, takes remaining space
            Expanded(
              child: _webWidgetOptions.elementAt(_selectedWebIndex),
            ),
          ],
        ),
      ),
    );
  }
}
