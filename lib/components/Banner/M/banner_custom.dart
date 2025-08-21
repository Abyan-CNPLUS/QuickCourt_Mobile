import 'package:flutter/material.dart';

class CustomBanner extends StatelessWidget {
  final String imagePath;
  final double? height;
  final BoxFit? fit;
  final VoidCallback? onTap;

  const CustomBanner({
    super.key,
    required this.imagePath,
    this.height,
    this.fit = BoxFit.cover,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: fit,
          ),
        ),
      ),
    );
  }
}