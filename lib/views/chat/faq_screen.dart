import 'package:flutter/material.dart';
import '../../utils/colors.dart'; // Your brand colors
import '../../widget_common/responsive-layout.dart';

class FaqItem {
  final String question;
  final String answer;
  final String category;

  FaqItem({required this.question, required this.answer, required this.category});
}

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // --- 1. THE 30+ QUESTIONS DATABASE ---
  final List<FaqItem> _allFaqs = [
    // --- RELOADS & BILLING ---
    FaqItem(
      category: "Reloads & Billing",
      question: "Cash deducted from bank but reload not received?",
      answer: "This happens rarely due to banking network delays. Please wait for 3 working days; the system will automatically refund the amount to your bank account. If you still haven't received it after 3 days, please contact an agent via the Support Chat with your Transaction ID.",
    ),
    FaqItem(
      category: "Reloads & Billing",
      question: "How do I check my prepaid balance?",
      answer: "You can check your balance on the Dashboard of this app, or by dialing #123# from your phone.",
    ),
    FaqItem(
      category: "Reloads & Billing",
      question: "What is the minimum reload amount?",
      answer: "The minimum reload amount is LKR 50.00 via the app.",
    ),
    FaqItem(
      category: "Reloads & Billing",
      question: "Can I pay someone else's bill?",
      answer: "Yes! Go to the 'Reload' section, and simply change the phone number to the person you wish to pay for.",
    ),
    FaqItem(
      category: "Reloads & Billing",
      question: "How can I view my past usage history?",
      answer: "Navigate to the 'Billing History' tab on the dashboard to see your last 3 months of transactions.",
    ),
    FaqItem(
      category: "Reloads & Billing",
      question: "Why is my bill higher than usual?",
      answer: "This usually happens if you have exceeded your data quota or used IDD services. Check your 'Recent Transactions' to see a breakdown.",
    ),

    // --- DATA & PACKAGES ---
    FaqItem(
      category: "Data & Internet",
      question: "What is Night Time Data?",
      answer: "Night Time Data is a special bonus quota that is valid only from 12:00 AM (Midnight) to 08:00 AM daily.",
    ),
    FaqItem(
      category: "Data & Internet",
      question: "How do I activate a new data package?",
      answer: "Go to the 'Services' tab, select 'Discover', and browse our available data add-ons. Click 'Activate' on the one you want.",
    ),
    FaqItem(
      category: "Data & Internet",
      question: "What is the 'Anytime Data' quota?",
      answer: "Anytime Data can be used 24 hours a day, 7 days a week, with no time restrictions.",
    ),
    FaqItem(
      category: "Data & Internet",
      question: "Why is my internet slow?",
      answer: "Please check if you have exhausted your 4G data quota. If your quota is finished, speeds may be throttled. Try restarting your device or activating a speed booster pack.",
    ),
    FaqItem(
      category: "Data & Internet",
      question: "Does Social Media data cover external links?",
      answer: "No. The Social Media (Unlimited) package covers usage within the apps (FB, WhatsApp, Insta). Clicking external links (like YouTube videos inside FB) consumes your normal data.",
    ),
    FaqItem(
      category: "Data & Internet",
      question: "How do I share data with a friend?",
      answer: "Use the 'Data Gift' option in the Services menu. You can send up to 1GB per day to another Sri Tel number.",
    ),
    FaqItem(
      category: "Data & Internet",
      question: "Is 5G available in my area?",
      answer: "5G is currently available in Colombo, Kandy, and Galle city limits. We are expanding rapidly!",
    ),

    // --- ACCOUNT & SIM ---
    FaqItem(
      category: "Account & SIM",
      question: "My SIM is lost. What should I do?",
      answer: "Please call our hotline 1777 immediately to block your SIM. You can visit the nearest arcade to get a replacement SIM with the same number.",
    ),
    FaqItem(
      category: "Account & SIM",
      question: "How do I find my PUK code?",
      answer: "Your PUK code is printed on the back of your SIM card holder. If you lost it, contact our chat support for assistance.",
    ),
    FaqItem(
      category: "Account & SIM",
      question: "Can I change my ownership details?",
      answer: "Ownership transfer requires both parties to visit a customized arcade with valid NICs.",
    ),
    FaqItem(
      category: "Account & SIM",
      question: "How do I switch from Prepaid to Postpaid?",
      answer: "You can request a package conversion via the 'Support' chat. A deposit may be required.",
    ),

    // --- ROAMING & IDD ---
    FaqItem(
      category: "Roaming & IDD",
      question: "How do I activate Roaming?",
      answer: "Go to 'Services' > 'Discover' and toggle the 'International Roaming' switch. Ensure you have a minimum credit balance of LKR 1,000.",
    ),
    FaqItem(
      category: "Roaming & IDD",
      question: "What are the rates for calling India?",
      answer: "Calls to India are charged at LKR 15.00 per minute + taxes. Activate the 'Asian Call Blaster' pack for lower rates.",
    ),
    FaqItem(
      category: "Roaming & IDD",
      question: "Will my data work overseas?",
      answer: "Only if you activate a 'Data Roaming' pass. Standard pay-as-you-go data rates overseas are very high, so we recommend a package.",
    ),

    // --- VALUE ADDED SERVICES ---
    FaqItem(
      category: "Value Added Services",
      question: "How do I stop ring-in tones (CRBT)?",
      answer: "Go to 'My Services' and toggle off the 'Ring-in Tone' service.",
    ),
    FaqItem(
      category: "Value Added Services",
      question: "I am getting too many promotional SMS.",
      answer: "You can enable 'DND' (Do Not Disturb) mode in the Settings menu to block promotional messages.",
    ),
    FaqItem(
      category: "Value Added Services",
      question: "How to subscribe to Star Points?",
      answer: "You are automatically enrolled! You earn 1 point for every LKR 100 spent.",
    ),

    // --- TECHNICAL SUPPORT ---
    FaqItem(
      category: "Technical Support",
      question: "The app is crashing on my phone.",
      answer: "Please ensure you have the latest version installed from the Play Store/App Store. Clear the app cache and try again.",
    ),
    FaqItem(
      category: "Technical Support",
      question: "I cannot login to my account.",
      answer: "Use the 'Forgot Password' link on the login screen. If you don't receive the OTP, check if your SMS inbox is full.",
    ),
    FaqItem(
      category: "Technical Support",
      question: "How do I contact a human agent?",
      answer: "Open the 'Support' page and click 'Start New Chat'. Type 'Agent' to be transferred to a human.",
    ),
    FaqItem(
      category: "Technical Support",
      question: "Where is the nearest Sri Tel arcade?",
      answer: "We have branches in every major city. Use Google Maps to find the 'Sri Tel' nearest to you.",
    ),
    FaqItem(
      category: "Technical Support",
      question: "Is this app free to use?",
      answer: "Yes, browsing the Sri Tel Self Care app does not consume your data quota.",
    ),
    FaqItem(
      category: "Technical Support",
      question: "Can I use this app abroad?",
      answer: "Yes, the app works via Wi-Fi or Roaming data anywhere in the world.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: _buildContent(isWeb: false),
      webBody: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: _buildContent(isWeb: true),
        ),
      ),
    );
  }

  Widget _buildContent({required bool isWeb}) {
    // Filter logic
    final filteredFaqs = _allFaqs.where((item) {
      final query = _searchQuery.toLowerCase();
      return item.question.toLowerCase().contains(query) ||
          item.answer.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        backgroundColor: orangeColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Frequently Asked Questions", style: TextStyle(color: white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // --- SEARCH BAR ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: orangeColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: "Search for help...",
                hintStyle: TextStyle(color: textColorOne.withValues(alpha: 0.5)),
                prefixIcon: const Icon(Icons.search, color: orangeColor),
                filled: true,
                fillColor: white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ),

          // --- FAQ LIST ---
          Expanded(
            child: filteredFaqs.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.search_off, size: 50, color: greyColor),
                  SizedBox(height: 10),
                  Text("No results found", style: TextStyle(color: greyColor)),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filteredFaqs.length,
              itemBuilder: (context, index) {
                final item = filteredFaqs[index];

                // Grouping Logic: Show Header if it's the first item of a category or the list is filtered
                bool showHeader = false;
                if (_searchQuery.isEmpty) {
                  if (index == 0 || filteredFaqs[index - 1].category != item.category) {
                    showHeader = true;
                  }
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showHeader)
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 10, left: 5),
                        child: Text(
                          item.category.toUpperCase(),
                          style: const TextStyle(
                            color: greyColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),

                    // The Expandable Card
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          iconColor: orangeColor,
                          collapsedIconColor: greyColor,
                          title: Text(
                            item.question,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: textColorOne,
                              fontSize: 15,
                            ),
                          ),
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: Text(
                                item.answer,
                                style: const TextStyle(color: Colors.black87, height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}