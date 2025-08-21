import 'package:flutter/material.dart';

class SimpleBanner extends StatelessWidget {
  final String imagePath;
  const SimpleBanner({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(3, 6),
            ),
          ],
        ),
      ),
    );
  }
}
