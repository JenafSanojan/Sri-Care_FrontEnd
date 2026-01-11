import 'package:flutter/material.dart';
import 'package:sri_tel_flutter_web_mob/entities/provisioning/telco_Package.dart';
import 'package:sri_tel_flutter_web_mob/services/package_service.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/special/confirmation_dialog.dart';
import '../../utils/colors.dart';
import '../../widget_common/responsive-layout.dart';
import 'package:get/get.dart';

class ServicesScreen extends StatefulWidget {
  // final VoidCallback? drawerCallback;
  final bool dontShowBackButton;

  const ServicesScreen({Key? key, this.dontShowBackButton = false})
      : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<TelcoPackage> myServices = [];
  late List<TelcoPackage> availableServices = [];
  final PackageService _packageService = PackageService();

 void  _loadAvailableServices()async {
    final services = await _packageService.getVASPackages() ?? [];
   if(mounted) {
     setState(() {
       availableServices = services;
     });
   }
  }
  void _loadMyServices() async {
   final services = await _packageService.getMyActivePackages() ?? [];
    // if(mounted) {
    //   setState(() {
    //     myServices = services.where((s) => s.isVAS).toList();
    //   });
    // }
  }

  void activateService(TelcoPackage service) async {
    bool? res = await ConfirmationDialog.show(
      title: "Activate Service",
      message: "Do you want to activate ${service.name} for LKR ${service.cost.toStringAsFixed(0)}?",
    );
    if(res != true) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${service.name} Activated")));
  }

  void deactivateService(TelcoPackage service) async {
   bool? res = await ConfirmationDialog.show(
      title: "Deactivate Service",
      message: "Are you sure you want to deactivate ${service.name}?",
    );
    if(res != true) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${service.name} Deactivated")));
  }

  @override
  void initState() {
    super.initState();
    _loadMyServices();
    _loadAvailableServices();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: _buildContent(context, isWeb: false),
      webBody: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000), // Wider for web
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
        children: [
          ActiveServicesTab(myServices: myServices, onDeactivate: deactivateService,),
          DiscoverServicesTab(availableServices: availableServices, onActivate: activateService,),
        ],
      ),
    );
  }
}

// --- 3. TAB 1: ACTIVE SERVICES (Toggle to Deactivate) ---
class ActiveServicesTab extends StatefulWidget {
  final List<TelcoPackage> myServices;
  final Function(TelcoPackage) onDeactivate;
  const ActiveServicesTab({super.key, required this.myServices, required this.onDeactivate});

  @override
  State<ActiveServicesTab> createState() => _ActiveServicesTabState();
}

class _ActiveServicesTabState extends State<ActiveServicesTab> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: widget.myServices.length,
      itemBuilder: (context, index) {
        final service = widget.myServices[index];
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
              child: Icon(Icons.miscellaneous_services, color: orangeColor),
            ),
            title: Text(service.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: textColorOne)),
            subtitle: Text(service.description,
                style: const TextStyle(fontSize: 12, color: greyColor)),
            value: true,
            onChanged: (val) {
              if(val == false) {
                widget.onDeactivate(service);
              } else {
                // Activation not handled here
              }
            },
          ),
        );
      },
    );
  }
}

// --- 4. TAB 2: DISCOVER SERVICES (Catalog) ---
class DiscoverServicesTab extends StatelessWidget {
  final List<TelcoPackage> availableServices;
  final Function(TelcoPackage) onActivate;
  const DiscoverServicesTab({super.key, required this.availableServices, required this.onActivate});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: availableServices.length,
      itemBuilder: (context, index) {
        final service = availableServices[index];
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
                child: Icon(Icons.miscellaneous_services, color: greyColor, size: 28),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(service.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: textColorOne)),
                    const SizedBox(height: 5),
                    Text(service.description,
                        style: const TextStyle(fontSize: 12, color: greyColor)),
                    const SizedBox(height: 5),
                    Text("LKR ${service.cost.toStringAsFixed(0)} /mo",
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
                  onActivate(service);
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

