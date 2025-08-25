import 'package:flutter/material.dart';
import 'package:quick_court_booking/models/venue_model.dart';
import 'package:quick_court_booking/screens/auth_venue/views/signup_venue_screen.dart';


class OwnerDashboardScreen extends StatelessWidget {
  final List<Venue> venues;

  const OwnerDashboardScreen({super.key, required this.venues});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List Venue')),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[300],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const RegisterVenueScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
