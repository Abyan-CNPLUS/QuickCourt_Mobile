import 'package:flutter/material.dart';

IconData getFacilityIcon(String name) {
  switch (name.toLowerCase()) {
    case 'parkir luas':
      return Icons.local_parking;
    case 'toilet':
      return Icons.wc;
    case 'ruang ganti':
      return Icons.chair_alt;
    case 'mushola':
      return Icons.mosque;
    case 'warung makan':
      return Icons.restaurant;
    case 'wifi gratis':
      return Icons.wifi;
    case 'penerangan malam':
      return Icons.lightbulb;
    case 'tribun penonton':
      return Icons.event_seat;
    case 'loker penyimpanan':
      return Icons.lock;
    case 'air minum gratis':
      return Icons.local_drink;
    default:
      return Icons.help_outline;
  }
}
