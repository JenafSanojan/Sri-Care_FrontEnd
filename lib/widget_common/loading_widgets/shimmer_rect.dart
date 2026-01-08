import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerRect extends StatelessWidget {
  final double? height;
  final double? width;
  const ShimmerRect({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: EdgeInsets.all(8.0),
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
