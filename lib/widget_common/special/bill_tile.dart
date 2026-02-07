// import 'package:flutter/material.dart';
//
// import '../../utils/colors.dart';
//
// Widget buildBillTile(String date, String status, String amount, bool isPaid) {
//   return  Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: isPaid ? lighrGreen : popUpRedColor.withValues(alpha: 0.1),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(
//             isPaid ? Icons.check_circle : Icons.warning,
//             color: isPaid ? darkGreen : popUpRedColor,
//           ),
//         ),
//         const SizedBox(width: 15),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColorOne)),
//               const SizedBox(height: 4),
//               Text(status, style: TextStyle(color: isPaid ? darkGreen : popUpRedColor, fontSize: 13)),
//             ],
//           ),
//         ),
//         Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColorOne)),
//       ],
//     ),
//   );
// }
