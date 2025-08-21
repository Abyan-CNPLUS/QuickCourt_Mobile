import 'package:flutter/material.dart';

IconData getCategoryIcon(String name) {
  switch (name.toLowerCase()) {
    case 'mini soccer':
      return Icons.sports_soccer;
    case 'futsal':
      return Icons.sports_soccer;
    case 'badminton':
      return Icons.sports_tennis;
    case 'cricket':
      return Icons.sports_cricket_outlined;
    case 'hockey':
      return Icons.sports_hockey;
    default:
      return Icons.help_outline;
  }
}
