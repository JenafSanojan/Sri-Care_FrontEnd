import 'package:flutter/material.dart';
import 'package:sri_tel_flutter_web_mob/utils/colors.dart';

class OrderAddressWidget extends StatelessWidget {
  final String orderAddress;
  OrderAddressWidget({required this.orderAddress});

  @override
  Widget build(BuildContext context) {
    // Split the address by the first comma
    List<String> parts = orderAddress.split(',');

    //extracting name
    String firstPart = parts.length > 1 ? parts[0].trim() : '';
    parts.removeAt(0);

    // extract mb no, if it is there.
    // String temp = parts.join(', ');
    // parts = temp.split('\n');
    String secondPart = parts.length > 1 ? parts[0].trim() : '';
    parts.length > 0 ? parts.removeAt(0) : parts[0];

    // Process each part
    parts = parts.map((element) {
      return element.trim().replaceAll('\n', '');
    }).toList();

    // Remove empty elements
    parts.removeWhere((element) => element.isEmpty);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          firstPart,
          style: TextStyle(
            color: darkGreen, // Set the first part to green
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
        // 8.heightBox,
        Text(
          secondPart,
          style: TextStyle(
            color: greyColor, // Set the second part
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
        // 8.heightBox,
        Text(
          parts.join(', '),
          style: TextStyle(
            color: greyColor, // Set the remaining part to grey
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
