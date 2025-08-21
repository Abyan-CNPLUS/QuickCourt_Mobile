import 'package:flutter/material.dart';

class AddVenueScreen extends StatelessWidget {
  const AddVenueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Venue")),
      body: const Center(child: Text("Ini halaman khusus admin.")),
    );
  }
}