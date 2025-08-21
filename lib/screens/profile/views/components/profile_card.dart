import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:quick_court_booking/components/network_image_with_loader.dart';

// import '../../../../constants.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String email;
  final String imageSrc;
  final VoidCallback? press;

  const ProfileCard({
    super.key,
    required this.name,
    required this.email,
    required this.imageSrc,
    this.press,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      leading: CircleAvatar(
        backgroundImage: AssetImage(imageSrc),
        radius: 30,
      ),
      title: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      subtitle: Text(
        email,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}