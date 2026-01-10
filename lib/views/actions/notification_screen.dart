import 'package:flutter/material.dart';
import 'package:sri_tel_flutter_web_mob/entities/notification_log.dart';
import 'package:sri_tel_flutter_web_mob/services/notification_service.dart';
import 'package:sri_tel_flutter_web_mob/utils/colors.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/responsive-layout.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin {
  final NotificationService _notificationService = NotificationService();

  late TabController _tabController;

  // State variables
  List<NotificationLog> _notifications = [];
  Map<String, int> _stats = {'total': 0, 'sent': 0, 'failed': 0};
  bool _isLoading = true;
  String _currentFilter = 'ALL'; // ALL, EMAIL, SMS

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _loadData();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        switch (_tabController.index) {
          case 0: _currentFilter = 'ALL'; break;
          case 1: _currentFilter = 'EMAIL'; break;
          case 2: _currentFilter = 'SMS'; break;
        }
        _isLoading = true;
      });
      _fetchNotifications();
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await Future.wait([
      _fetchStats(),
      _fetchNotifications(),
    ]);
    setState(() => _isLoading = false);
  }

  Future<void> _fetchStats() async {
    final stats = await _notificationService.getNotificationStats();
    if (stats != null) {
      setState(() => _stats = stats);
    }
  }

  Future<void> _fetchNotifications() async {
    List<NotificationLog>? result;

    if (_currentFilter == 'ALL') {
      result = await _notificationService.getNotificationHistory();
    } else {
      result = await _notificationService.getNotificationHistory(channel: _currentFilter);
    }

    if (mounted) {
      setState(() {
        if (result != null) {
          _notifications = result;
          // Sort by date descending (newest first)
          _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _handleRetry(String notificationId) async {
    final success = await _notificationService.retryNotification(notificationId);
    if (success) {
      // Refresh list to show updated status (e.g. status might change to QUEUED)
      _fetchNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: _buildContent(isWeb: false),
      webBody: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Notifications", style: TextStyle(color: white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Emails"),
            Tab(text: "SMS"),
          ],
        ),
      ),
      body: Column(
        children: [
          // --- 1. STATS DASHBOARD ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: white,
              border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
            ),
            child: Row(
              children: [
                _buildStatCard("Total", _stats['total'] ?? 0, Colors.blue),
                const SizedBox(width: 15),
                _buildStatCard("Sent", _stats['sent'] ?? 0, Colors.green),
                const SizedBox(width: 15),
                _buildStatCard("Failed", _stats['failed'] ?? 0, Colors.red),
              ],
            ),
          ),

          // --- 2. NOTIFICATION LIST ---
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: orangeColor))
                : RefreshIndicator(
              color: orangeColor,
              onRefresh: _loadData,
              child: _notifications.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  return _NotificationTile(
                    log: _notifications[index],
                    onRetry: () => _handleRetry(_notifications[index].id),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
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
            Icon(Icons.notifications_off_outlined, size: 60, color: greyColor),
            SizedBox(height: 15),
            Text("No notifications found", style: TextStyle(color: greyColor, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

// --- HELPER WIDGET: NOTIFICATION TILE ---
class _NotificationTile extends StatelessWidget {
  final NotificationLog log;
  final VoidCallback onRetry;

  const _NotificationTile({required this.log, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    // Determine visual status
    Color statusColor;
    IconData statusIcon;

    if (log.isSent) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (log.isFailed) {
      statusColor = Colors.red;
      statusIcon = Icons.error;
    } else {
      statusColor = Colors.orange;
      statusIcon = Icons.hourglass_top; // Queued
    }

    // Determine Channel Icon (Email vs SMS)
    IconData channelIconData = log.isEmail ? Icons.email_outlined : Icons.sms_outlined;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: lightYellow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(channelIconData, color: orangeColor),
          ),
          title: Text(
            log.message,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColorOne),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Row(
                children: [
                  Icon(statusIcon, size: 12, color: statusColor),
                  const SizedBox(width: 5),
                  Text(
                      log.status,
                      style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _formatDate(log.createdAt),
                    style: const TextStyle(color: greyColor, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          children: [
            // Expanded details view
            Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  _buildDetailRow("To:", log.recipient),
                  _buildDetailRow("Channel:", log.channel),
                  if (log.sentAt != null)
                    _buildDetailRow("Sent At:", _formatDate(log.sentAt!)),
                  const SizedBox(height: 10),
                  const Text("Message Content:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: greyColor)),
                  const SizedBox(height: 5),
                  Text(log.message, style: const TextStyle(fontSize: 13, color: textColorOne)),

                  // Retry Button if Failed
                  if (log.isFailed) ...[
                    const SizedBox(height: 15),
                    if (log.error != null)
                      Text("Error: ${log.error}", style: const TextStyle(color: Colors.red, fontSize: 11, fontStyle: FontStyle.italic)),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text("Retry Sending"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                        onPressed: onRetry,
                      ),
                    )
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 70,
              child: Text(label, style: const TextStyle(fontSize: 12, color: greyColor, fontWeight: FontWeight.w600))
          ),
          Expanded(
              child: Text(value, style: const TextStyle(fontSize: 12, color: textColorOne))
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Simple formatter (YYYY-MM-DD HH:MM)
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} "
        "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}