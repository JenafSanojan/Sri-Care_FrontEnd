import 'package:flutter/material.dart';
import 'package:sri_tel_flutter_web_mob/utils/colors.dart';
import 'package:sri_tel_flutter_web_mob/views/actions/about_screen.dart';
import 'package:sri_tel_flutter_web_mob/views/actions/billing_history_screen.dart';
import 'package:sri_tel_flutter_web_mob/views/actions/settings.dart';
import 'package:sri_tel_flutter_web_mob/views/home/dashboard.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/responsive-layout.dart';

import '../../entities/common.dart';
import '../actions/packages_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  final String title = 'Sri-Care';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Tracks the currently selected menu item
  bool _isSidebarHovered = false; // New state to track sidebar hover
  bool _isSidebarOpen = false; // New state to track sidebar open/close

  // final authController = Get.put(AuthController());

  // List of destinations/pages for the menu
  static final List<Widget> _webWidgetOptions = <Widget>[
    Center(child: DashboardScreen()),
    Center(child: PackagesScreen()),
    Center(child: BillingHistoryScreen()),
    Center(child: SettingsScreen()),
    Center(child: Text('Profile Page', style: TextStyle(fontSize: 24))),
    Center(child: AboutScreen()),
  ];
  static final List<Widget> _mobWidgetOptions = <Widget>[
    Center(child: DashboardScreen()),
    Center(child: PackagesScreen()),
    Center(child: BillingHistoryScreen()),
    Center(child: Text('Profile Page', style: TextStyle(fontSize: 24))),
  ];

  // List of menu items with their icons and titles
  final List<MenuItem> _webMenuItems = [
    MenuItem(icon: Icons.home, title: 'Home'),
    MenuItem(icon: Icons.production_quantity_limits, title: 'Packages'),
    MenuItem(icon: Icons.scale, title: 'Usage History'),
    MenuItem(icon: Icons.settings, title: 'Settings'),
    MenuItem(icon: Icons.person, title: 'Profile'),
    MenuItem(icon: Icons.info, title: 'About'),
  ];
  final List<MenuItem> _mobMenuItems = [
    MenuItem(icon: Icons.home, title: 'Home'),
    MenuItem(icon: Icons.production_quantity_limits, title: 'Packages'),
    MenuItem(icon: Icons.scale, title: 'Usage'),
    MenuItem(icon: Icons.person, title: 'Profile'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder helps us respond to the parent widget's size
    return ResponsiveLayout(
      mobileBody: Scaffold(
        body: _mobWidgetOptions
            .elementAt(_selectedIndex), // Main content area
        bottomNavigationBar: BottomNavigationBar(
          items: _mobMenuItems.map((item) {
            return BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: '',
            );
          }).toList(),
          currentIndex: _selectedIndex, // Current selected item
          backgroundColor:
          Colors.blueGrey[900], // Background color for the bar
          selectedItemColor: darkGreen, // Color for selected icon
          unselectedItemColor: Colors.grey, // Color for unselected icons
          onTap: _onItemTapped, // Callback when an item is tapped
          type: BottomNavigationBarType
              .fixed, // Ensures all items are visible
          // Hide labels for both selected and unselected items
          showSelectedLabels: false,
          showUnselectedLabels: false,
          // show a circle around the selected icon
          selectedIconTheme: IconThemeData(
            size: 30, // Size of the selected icon
            color: darkGreen, // Color of the selected icon
          ),
        ),
      ),
      webBody:  Scaffold(
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
                        color: _selectedIndex == index
                            ? darkGreen
                            : Colors.grey, // Icon color based on selection
                      ),
                      title: _isSidebarOpen
                          ? Text(
                              item.title,
                              style: TextStyle(
                                color: _selectedIndex == index
                                    ? darkGreen
                                    : Colors
                                        .grey, // Text color based on selection
                                overflow: TextOverflow
                                    .fade, // Prevent text overflow
                              ),
                              maxLines: 1,
                            )
                          : null,
                      selected: _selectedIndex ==
                          index, // Highlight selected item
                      selectedTileColor: Colors.blueGrey[
                          700], // Background color for selected item
                      onTap: () => _onItemTapped(index),
                    );
                  },
                ),
              ),
            ),
            // Main content area, takes remaining space
            Expanded(
              child: _webWidgetOptions.elementAt(_selectedIndex),
            ),
          ],
        ),
      ),
    );
  }
}
