import 'package:flutter/material.dart';

class QuickActionsScreen extends StatelessWidget {
  const QuickActionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => {},
              child: const Text('Do Nothing'),
            ),
          ],
        ),
      ),
    );
  }
}


void showQuickActionsPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Quick Actions'),
        content: SizedBox(
          width: 200,
            height: 400,
            child: const QuickActionsScreen()),
        alignment: Alignment.bottomRight,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}