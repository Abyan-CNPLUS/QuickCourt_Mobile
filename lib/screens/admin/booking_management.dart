import 'package:flutter/material.dart';

class AdminBookingScreen extends StatelessWidget {
  const AdminBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kelola Booking")),
      body: const Center(child: Text("Ini halaman khusus admin.")),
    );
  }
}