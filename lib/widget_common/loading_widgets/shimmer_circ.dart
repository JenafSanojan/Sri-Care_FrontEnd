import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCirc extends StatelessWidget {
  final double radius;
  const ShimmerCirc({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        height: radius*2,
        width: radius*2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
