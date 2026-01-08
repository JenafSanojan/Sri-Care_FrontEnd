import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/custom_orangefill_button_widget.dart';

import '../../providers/catgory_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  final String title = 'Sri-Care';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void clearCache() {
    // final _categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    // _categoryProvider.clearCache();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: Container(),
      ),
      floatingActionButton: FloatingActionButton( // can be used to show a quick action popup
        onPressed: clearCache,
        tooltip: 'Mukut na',
        child: const Icon(Icons.clear),
      ),
    );
  }
}
