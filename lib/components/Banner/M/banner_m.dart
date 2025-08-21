import 'package:flutter/material.dart';

import '../../network_image_with_loader.dart';

class BannerM extends StatelessWidget {
  const BannerM({
    super.key,
    required this.image,
    required this.press,
    required this.children,
  });

  final String image;
  final VoidCallback press;
  final List<Widget> children;

  bool get isNetworkImage => image.startsWith('http');

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.87,
      child: GestureDetector(
        onTap: press,
        child: Stack(
          fit: StackFit.expand,
          children: [
            isNetworkImage
                ? NetworkImageWithLoader(image, radius: 0)
                : Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ),
            Container(color: Colors.black45),
            ...children,
          ],
        ),
      ),
    );
  }
}
