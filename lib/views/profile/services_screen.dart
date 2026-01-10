import 'package:flutter/material.dart';
import '../../entities/packageBilling/service_model.dart';
import '../../utils/colors.dart'; // Your brand colors
import '../../widget_common/responsive-layout.dart';
import 'package:get/get.dart';

class ServicesScreen extends StatefulWidget {
  // final VoidCallback? drawerCallback;
  final bool dontShowBackButton;

  const ServicesScreen(
      {Key? key, this.dontShowBackButton = false})
      : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: _buildContent(context, isWeb: false),
      webBody: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800), // Wider for web
          child: _buildContent(context, isWeb: true),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, {required bool isWeb}) {
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        backgroundColor: orangeColor,
        elevation: 0,
        leading: widget.dontShowBackButton
            ? SizedBox()
            : IconButton(
            icon: const Icon(Icons.arrow_back, color: white),
            onPressed: Get.back),
        title: const Text("Service Management",
            style: TextStyle(color: white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: white,
          indicatorWeight: 4,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          tabs: const [
            Tab(text: "My Services"),
            Tab(text: "Discover"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ActiveServicesTab(),
          DiscoverServicesTab(),
        ],
      ),
    );
  }
}

// --- 3. TAB 1: ACTIVE SERVICES (Toggle to Deactivate) ---
class ActiveServicesTab extends StatefulWidget {
  const ActiveServicesTab({super.key});

  @override
  State<ActiveServicesTab> createState() => _ActiveServicesTabState();
}

class _ActiveServicesTabState extends State<ActiveServicesTab> {
  // Mock Data: Services the user already has
  final List<ServiceModel> _myServices = [
    ServiceModel(
        id: "1",
        title: "4G Data",
        description: "High speed internet access",
        icon: Icons.wifi,
        price: 950,
        isActive: true),
    ServiceModel(
        id: "2",
        title: "Ring-in Tone",
        description: "Personalized caller tunes",
        icon: Icons.music_note,
        price: 150,
        isActive: true),
    ServiceModel(
        id: "3",
        title: "Missed Call Alert",
        description: "SMS notifications for missed calls",
        icon: Icons.phone_missed,
        price: 50,
        isActive: true),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _myServices.length,
      itemBuilder: (context, index) {
        final service = _myServices[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ],
          ),
          child: SwitchListTile(
            contentPadding: const EdgeInsets.all(15),
            activeColor: orangeColor,
            secondary: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: lightYellow, borderRadius: BorderRadius.circular(10)),
              child: Icon(service.icon, color: orangeColor),
            ),
            title: Text(service.title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: textColorOne)),
            subtitle: Text(service.description,
                style: const TextStyle(fontSize: 12, color: greyColor)),
            value: service.isActive,
            onChanged: (val) {
              // Show confirmation dialog before deactivating
              if (!val) {
                _showDeactivateDialog(context, service, index);
              } else {
                setState(() => service.isActive = true);
              }
            },
          ),
        );
      },
    );
  }

  void _showDeactivateDialog(
      BuildContext context, ServiceModel service, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Deactivate Service?"),
        content: Text(
            "Are you sure you want to remove ${service.title}? You will lose access immediately."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                _myServices.removeAt(index); // Remove from list
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${service.title} Deactivated")));
            },
            child: const Text("Deactivate"),
          ),
        ],
      ),
    );
  }
}

// --- 4. TAB 2: DISCOVER SERVICES (Catalog) ---
class DiscoverServicesTab extends StatelessWidget {
  const DiscoverServicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data: New services to buy
    final List<ServiceModel> _availableServices = [
      ServiceModel(
          id: "4",
          title: "Int'l Roaming",
          description: "Use your number abroad",
          icon: Icons.public,
          price: 1500,
          isActive: false),
      ServiceModel(
          id: "5",
          title: "News Alerts",
          description: "Daily breaking news SMS",
          icon: Icons.newspaper,
          price: 30,
          isActive: false),
      ServiceModel(
          id: "6",
          title: "Sports Pack",
          description: "Live cricket score updates",
          icon: Icons.sports_cricket,
          price: 100,
          isActive: false),
      ServiceModel(
          id: "7",
          title: "Streaming Pass",
          description: "Unlimited Netflix Data",
          icon: Icons.movie,
          price: 450,
          isActive: false),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _availableServices.length,
      itemBuilder: (context, index) {
        final service = _availableServices[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: orangeColor.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(service.icon, color: greyColor, size: 28),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(service.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: textColorOne)),
                    const SizedBox(height: 5),
                    Text(service.description,
                        style: const TextStyle(fontSize: 12, color: greyColor)),
                    const SizedBox(height: 5),
                    Text("LKR ${service.price.toStringAsFixed(0)} /mo",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: orangeColor)),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: orangeColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () {
                  // TODO: Implement Activation API call
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Service Activated Successfully - chc!")));
                },
                child: const Text("Activate", style: TextStyle(color: white)),
              )
            ],
          ),
        );
      },
    );
  }
}
