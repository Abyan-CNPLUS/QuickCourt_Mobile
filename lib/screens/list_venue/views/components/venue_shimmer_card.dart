import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VenueShimmerCard extends StatelessWidget {
  const VenueShimmerCard({super.key, this.isHorizontal = false});

  final bool isHorizontal;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: isHorizontal ? 240 : double.infinity,
        height: isHorizontal ? 160 : 100,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
