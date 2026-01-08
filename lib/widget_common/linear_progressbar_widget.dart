// import 'package:flutter/material.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
//
// import '../models/rating.dart';
// import '../utils/colors.dart';
//
// Widget LineraProgressBar(BuildContext context , int star, List<Rating>? rating) {
//   return Center(
//     child: SizedBox(
//       width: MediaQuery.of(context).size.width*0.85,
//     child: rating == null
//           ?
//       LinearPercentIndicator(
//         // width: MediaQuery.of(context).size.width - 120,
//         lineHeight: 20.0,
//         backgroundColor: prgressBarBackColot,
//         percent: 0.0,
//         // center: Text("80.0%"),
//         leading:  Text('${star.toString()} star'),
//         trailing: const Text("(0)"),
//         barRadius: Radius.circular(13),
//
//         /// linearStrokeCap: .roundAll,
//         progressColor: darkGreen,
//       )
//           :
//       rating.isEmpty
//           ?
//       LinearPercentIndicator(
//         // width: MediaQuery.of(context).size.width - 120,
//         animation: true,
//         lineHeight: 20.0,
//         animationDuration: 2500,
//         backgroundColor: prgressBarBackColot,
//         percent: 0,
//         //center: Text("80.0%"),
//         leading:  Text('${star.toString()} star'),
//         trailing: const Text(
//           "0"
//         ),
//         barRadius: const Radius.circular(13),
//         /// linearStrokeCap: .roundAll,
//         progressColor: darkGreen,
//       )
//           :
//       LinearPercentIndicator(
//         // width: MediaQuery.of(context).size.width - 120,
//         animation: true,
//         lineHeight: 20.0,
//         animationDuration: 2500,
//         backgroundColor: prgressBarBackColot,
//         percent: star == 1
//             ?
//         (rating[0].oneStarCount.toDouble() / rating[0].totalRatings.toDouble())
//             :
//         star == 2
//             ?
//         (rating[0].twoStarCount.toDouble() / rating[0].totalRatings.toDouble())
//             :
//         star == 3
//             ?
//         (rating[0].threeStarCount.toDouble() / rating[0].totalRatings.toDouble())
//             :
//         star == 4
//             ?
//         (rating[0].fourStarCount.toDouble() / rating[0].totalRatings.toDouble())
//             :
//         (rating[0].fiveStarCount.toDouble() / rating[0].totalRatings.toDouble()),
//         //center: Text("80.0%"),
//         leading:  Text('${star.toString()} star'),
//         trailing: Text(
//             star == 1
//                 ?
//             rating[0].oneStarCount.toString()
//                 :
//             star == 2
//                 ?
//             rating[0].twoStarCount.toString()
//                 :
//             star == 3
//                 ?
//             rating[0].threeStarCount.toString()
//                 :
//             star == 4
//                 ?
//             rating[0].fourStarCount.toString()
//                 :
//             rating[0].fiveStarCount.toString()
//
//         ),
//         barRadius: Radius.circular(13),
//         /// linearStrokeCap: .roundAll,
//         progressColor: darkGreen,
//       ),
//     ),
//   );
// }
