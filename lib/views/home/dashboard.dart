import 'package:flutter/material.dart';
import 'package:sri_tel_flutter_web_mob/Global/global_configs.dart';
import 'package:sri_tel_flutter_web_mob/views/actions/billing_history_screen.dart';
import 'package:sri_tel_flutter_web_mob/views/actions/notification_screen.dart';
import 'package:sri_tel_flutter_web_mob/views/billing/pending_bills_screen.dart';
import 'package:sri_tel_flutter_web_mob/views/profile/profile_screen.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/responsive-layout.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/snack_bar.dart';
import '../../entities/packageBilling/bill.dart';
import '../../services/billing_service.dart';
import '../../utils/colors.dart';
import '../../widget_common/special/bill_tile.dart';
import '../../widget_common/special/circular_usage_indicator.dart';
import 'package:get/get.dart';

import '../billing/payment_screen.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback? drawerCallback;

  const DashboardScreen({Key? key, this.drawerCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: MobileDashboard(),
      webBody: WebDashboard(),
    );
  }
}

// --- MOBILE DASHBOARD ---
class MobileDashboard extends StatefulWidget {
  final VoidCallback? openDrawer;

  MobileDashboard({super.key, this.openDrawer});

  @override
  State<MobileDashboard> createState() => _MobileDashboardState();
}

class _MobileDashboardState extends State<MobileDashboard> {
  final BillingService _billingService = BillingService();

  List<Bill> _pendingBills = [];

  bool _isBillsLoading = true;

  double _totalOutstanding = 0.0;

  Future<void> _fetchBills() async {
    setState(() => _isBillsLoading = true);

    final allBills = await _billingService.getUserBills();

    if (mounted) {
      if (allBills != null) {
        // Filter for bills that are NOT paid
        // Adjust status strings based on your actual API response (e.g., "PENDING", "Overdue")
        final unpaid = allBills.where((bill) {
          final status = bill.status.toUpperCase();
          return status != 'PAID' && status != 'COMPLETED';
        }).toList();

        // Sort: Overdue/Oldest first
        unpaid.sort((a, b) => (a.createdAt ?? DateTime.now())
            .compareTo(b.createdAt ?? DateTime.now()));

        setState(() {
          _pendingBills = unpaid;
          _totalOutstanding = unpaid.fold(0, (sum, item) => sum + item.amount);
          _isBillsLoading = false;
        });
      } else {
        setState(() => _isBillsLoading = false);
      }
    }
  }

  void _handlePayBill(Bill bill) {
    Get.to(() => PaymentScreen(bill: bill));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchBills();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        title: const Text("Sri Care",
            style: TextStyle(color: white, fontWeight: FontWeight.w700)),
        backgroundColor: orangeColor,
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.menu, color: white),
            onPressed: () => {
                  widget.openDrawer != null
                      ? widget.openDrawer!()
                      : Scaffold.of(context).openDrawer(),
                }),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationScreen()));
              },
              icon: const Icon(Icons.mail, color: white)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Header Section with Gradient
            Container(
              padding: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [orangeColor, textLightGreenColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Greetings, ${GlobalAuthConfigs.instance.user.displayName}",
                              style:
                                  const TextStyle(color: white, fontSize: 16)),
                          const SizedBox(height: 5),
                          Text(
                              "${GlobalAuthConfigs.instance.user.mobileNumber}",
                              style: TextStyle(
                                  color: white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      InkWell(
                        child: const CircleAvatar(
                          radius: 25,
                          backgroundColor: white,
                          child:
                              Icon(Icons.person, color: orangeColor, size: 30),
                        ),
                        onTap: () => {Get.to(() => const ProfileScreen())},
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Current Package Info Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Connection Status", //Current Package",
                                style: TextStyle(color: white, fontSize: 14)),
                            SizedBox(height: 5),
                            Text("Active", //"Super 4G Blaster",
                                style: TextStyle(
                                    color: Colors.green.withAlpha(200),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        // Text("LKR 950/mo",
                        //     style: TextStyle(
                        //         color: white,
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Usage Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                color: white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Wallet & Voice Balance",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColorOne)),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildCircularIndicator(
                              title: "Mobile Balance",
                              value:
                                  "${GlobalAuthConfigs.instance.user.walletBalance}",
                              unit: "Rs.",
                              percent: 0.0),
                          buildCircularIndicator(
                              title: "Voice Usage",
                              value: "${GlobalAuthConfigs.instance.user.voice}",
                              unit: "Mins",
                              percent:
                                  GlobalAuthConfigs.instance.user.voice == 0
                                      ? 0.0
                                      : 0.4),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Recent Bills Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Recent Bills",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColorOne)),
                      TextButton(
                          onPressed: () => Get.to(() => PendingBillsScreen()),
                          child: const Text("See All",
                              style: TextStyle(color: orangeColor))),
                    ],
                  ),
                  Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.05),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: _buildContent(isWeb: false)),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildContent({required bool isWeb}) {
    return _isBillsLoading
          ? const Center(child: CircularProgressIndicator(color: orangeColor))
          : Expanded(
              child: _pendingBills.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      itemCount: _pendingBills.length,
                      itemBuilder: (context, index) {
                        return _buildBillCard(_pendingBills[index]);
                      },
                    ),
            );
  }

  Widget _buildBillCard(Bill bill) {
    bool isOverdue = bill.status.toUpperCase() == 'OVERDUE';
    Color statusColor = isOverdue ? Colors.red : orangeColor;

    // Formatting date (Using basic string splitting if intl not available, or simpler logic)
    String dateStr = bill.createdAt != null
        ? "${bill.createdAt!.year}-${bill.createdAt!.month.toString().padLeft(2, '0')}-${bill.createdAt!.day.toString().padLeft(2, '0')}"
        : "Unknown Date";

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: isOverdue
            ? Border.all(color: Colors.red.withValues(alpha: 0.3), width: 1)
            : null,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Month & ID
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bill.billingMonth.toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: textColorOne),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Bill #${bill.id.substring(bill.id.length - 6)}",
                    // Show last 6 chars of ID
                    style: const TextStyle(color: greyColor, fontSize: 12),
                  ),
                ],
              ),
              // Right: Status Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  bill.status.toUpperCase(),
                  style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Amount Details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Due Amount",
                      style: TextStyle(fontSize: 12, color: greyColor)),
                  const SizedBox(height: 5),
                  Text(
                    "LKR ${bill.amount.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColorOne),
                  ),
                  const SizedBox(height: 5),
                  Text("Generated: $dateStr",
                      style: const TextStyle(fontSize: 11, color: greyColor)),
                ],
              ),
              // Pay Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: statusColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  elevation: 2,
                ),
                onPressed: () => _handlePayBill(bill),
                child: const Text("Pay Now",
                    style:
                        TextStyle(color: white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: 400,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
            SizedBox(height: 20),
            Text("No Pending Payments!",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColorOne)),
            SizedBox(height: 10),
            Text("You are all caught up.", style: TextStyle(color: greyColor)),
          ],
        ),
      ),
    );
  }
}

// --- WEB DASHBOARD ---
class WebDashboard extends StatefulWidget {
  WebDashboard({super.key});

  @override
  State<WebDashboard> createState() => _WebDashboardState();
}

class _WebDashboardState extends State<WebDashboard> {
  final BillingService _billingService = BillingService();

  List<Bill> _pendingBills = [];

  bool _isBillsLoading = true;

  double _totalOutstanding = 0.0;

  Future<void> _fetchBills() async {
    setState(() => _isBillsLoading = true);

    final allBills = await _billingService.getUserBills();
    // CommonLoaders.successSnackBar(title: "title");

    if (mounted) {
      if (allBills != null) {
        // Filter for bills that are NOT paid
        // Adjust status strings based on your actual API response (e.g., "PENDING", "Overdue")
        final unpaid = allBills.where((bill) {
          final status = bill.status.toUpperCase();
          return status != 'PAID' && status != 'COMPLETED';
        }).toList();

        // Sort: Overdue/Oldest first
        unpaid.sort((a, b) => (a.createdAt ?? DateTime.now())
            .compareTo(b.createdAt ?? DateTime.now()));

        setState(() {
          _pendingBills = unpaid;
          _totalOutstanding = unpaid.fold(0, (sum, item) => sum + item.amount);
          _isBillsLoading = false;
        });
      } else {
        setState(() => _isBillsLoading = false);
      }
    }
  }

  void _handlePayBill(Bill bill) {
    Get.to(() => PaymentScreen(bill: bill));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchBills();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightYellow,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            // 1. Web Header (Greetings & Package)
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [orangeColor, textLightGreenColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  InkWell(
                    child: const CircleAvatar(
                      radius: 35,
                      backgroundColor: white,
                      child: Icon(Icons.person, color: orangeColor, size: 40),
                    ),
                    onTap: () => {Get.to(() => const ProfileScreen())},
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "greetings, ${GlobalAuthConfigs.instance.user.displayName}", //"Good Morning,",
                          style: TextStyle(color: white, fontSize: 18)),
                      Text("${GlobalAuthConfigs.instance.user.mobileNumber}",
                          style: TextStyle(
                              color: white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Spacer(),
                  // Package Info styled for Web
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    decoration: BoxDecoration(
                      color: white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Connection Status", //"Current Package",
                            style: TextStyle(color: white, fontSize: 14)),
                        Text("Active", //"Super 4G Blaster",
                            style: TextStyle(
                                color: Colors.green.withAlpha(200),
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                        // Text("LKR 950/mo",
                        //     style: TextStyle(
                        //         color: white,
                        //         fontSize: 18,
                        //         fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 2. Usage Section (Two Cards Side-by-Side)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Voice Usage
                Expanded(
                  child: Container(
                    height: 250,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        color: white, borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        const Text("Mobile Balance",
                            style: TextStyle(fontSize: 18, color: greyColor)),
                        const Spacer(),
                        // Using the shared helper with larger dimensions if needed,
                        // but standard size works well centered
                        buildCircularIndicator(
                            title: "",
                            value:
                                "${GlobalAuthConfigs.instance.user.walletBalance}",
                            unit: "Rs.",
                            percent: 0.0,
                            height: 80,
                            width: 80),
                        const Spacer(),
                        Text(
                            "Rs. ${GlobalAuthConfigs.instance.user.walletBalance}",
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textColorOne)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                // Data Usage
                Expanded(
                  child: Container(
                    height: 250,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        color: white, borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        const Text("Voice Usage",
                            style: TextStyle(fontSize: 18, color: greyColor)),
                        const Spacer(),
                        buildCircularIndicator(
                            title: "",
                            value: "${GlobalAuthConfigs.instance.user.voice}",
                            unit: "Mins",
                            percent: GlobalAuthConfigs.instance.user.voice == 0
                                ? 0.0
                                : 0.4,
                            width: 80,
                            height: 80),
                        const Spacer(),
                        Text(
                            "${GlobalAuthConfigs.instance.user.voice} Mins Left",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textColorOne)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 3. Recent Bills Section (Expanded for Web)
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                  color: white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Recent Bills",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: textColorOne)),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: orangeColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () => Get.to(() => PendingBillsScreen()),
                          child: const Text("View All History",
                              style: TextStyle(color: white))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // List of bills
                  Container(
                      margin: const EdgeInsets.only(top:50,bottom: 15),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.05),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: _buildContent(isWeb: true)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent({required bool isWeb}) {
    return _isBillsLoading
        ? const Center(child: CircularProgressIndicator(color: orangeColor))
        : Expanded(
      child: _pendingBills.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 10),
        itemCount: _pendingBills.length,
        itemBuilder: (context, index) {
          return _buildBillCard(_pendingBills[index]);
        },
      ),
    );
  }

  Widget _buildBillCard(Bill bill) {
    bool isOverdue = bill.status.toUpperCase() == 'OVERDUE';
    Color statusColor = isOverdue ? Colors.red : orangeColor;

    // Formatting date (Using basic string splitting if intl not available, or simpler logic)
    String dateStr = bill.createdAt != null
        ? "${bill.createdAt!.year}-${bill.createdAt!.month.toString().padLeft(2, '0')}-${bill.createdAt!.day.toString().padLeft(2, '0')}"
        : "Unknown Date";

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: isOverdue
            ? Border.all(color: Colors.red.withValues(alpha: 0.3), width: 1)
            : null,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Month & ID
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bill.billingMonth.toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: textColorOne),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Bill #${bill.id.substring(bill.id.length - 6)}",
                    // Show last 6 chars of ID
                    style: const TextStyle(color: greyColor, fontSize: 12),
                  ),
                ],
              ),
              // Right: Status Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  bill.status.toUpperCase(),
                  style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Amount Details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Due Amount",
                      style: TextStyle(fontSize: 12, color: greyColor)),
                  const SizedBox(height: 5),
                  Text(
                    "LKR ${bill.amount.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColorOne),
                  ),
                  const SizedBox(height: 5),
                  Text("Generated: $dateStr",
                      style: const TextStyle(fontSize: 11, color: greyColor)),
                ],
              ),
              // Pay Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: statusColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  elevation: 2,
                ),
                onPressed: () => _handlePayBill(bill),
                child: const Text("Pay Now",
                    style:
                        TextStyle(color: white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: 400,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
            SizedBox(height: 20),
            Text("No Pending Payments!",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColorOne)),
            SizedBox(height: 10),
            Text("You are all caught up.", style: TextStyle(color: greyColor)),
          ],
        ),
      ),
    );
  }
}
