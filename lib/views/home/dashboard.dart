import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widget_common/responsive-layout.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: const MobileDashboard(),
      webBody: const WebDashboard(),
    );
  }
}

class MobileDashboard extends StatelessWidget {
  const MobileDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sri-Care")),
      drawer: const Drawer(), // Side menu for mobile
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Bill Summary Card
          Card(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: const [
                  Text("Total Due", style: TextStyle(color: Colors.white)),
                  Text("LKR 1,250.00", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Active Services", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          // Service Toggles
          SwitchListTile(title: const Text("Roaming"), value: false, onChanged: (val) {}),
          SwitchListTile(title: const Text("Data 4G"), value: true, onChanged: (val) {}),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: "Bills"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Support"),
        ],
      ),
    );
  }
}

class WebDashboard extends StatelessWidget {
  const WebDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sri-Care Self Care Portal")),
      body: Row(
        children: [
          // Web Sidebar
          NavigationRail(
            selectedIndex: 0,
            onDestinationSelected: (int index) {},
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Overview')),
              NavigationRailDestination(icon: Icon(Icons.receipt_long), label: Text('Billing')),
              NavigationRailDestination(icon: Icon(Icons.room_service), label: Text('Services')),
              NavigationRailDestination(icon: Icon(Icons.support_agent), label: Text('Support')),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Main Content Area
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.all(20),
              children: [
                _buildStatCard("Current Bill", "LKR 1,250.00", Colors.orange),
                _buildStatCard("Data Balance", "12.5 GB", Colors.green),
                _buildStatCard("Voice Min", "450 Mins", Colors.blue),
                // Add a large table for bill history here if needed
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}