

import 'package:flutter/material.dart';
import 'package:quick_court_booking/models/venue_model.dart';

class OwnerDashboardScreen extends StatelessWidget {
  final List<Venue> venues;

  const OwnerDashboardScreen({super.key, required this.venues});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Owner Dashboard')),
      body: venues.isEmpty
      ? const Center(child: Text('Tidak ada venue'))
      : ListView.builder(
          itemCount: venues.length,
          itemBuilder: (context, index) {
            final venue = venues[index];
            return ListTile(
              title: Text(venue.name),
              subtitle: Text(venue.city),
            );
          },
        ),
    );
  }
}
