import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quick_court_booking/models/venue_detail_model.dart';


class BookingTimeScreen extends StatelessWidget {
  final VenueDetail venue;
  final List<String> selectedSlots;

  const BookingTimeScreen({
    Key? key,
    required this.venue,
    required this.selectedSlots,
  }) : super(key: key);

  String _formatCurrency(String priceString) {
    try {
      final price = int.tryParse(priceString) ?? 0;
      return NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      ).format(price);
    } catch (e) {
      return 'Rp 0';
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedSlots = List<String>.from(selectedSlots)..sort();
    final totalPrice = (int.tryParse(venue.price) ?? 0) * sortedSlots.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Pemesanan'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              venue.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('${venue.city} • ${venue.category}'),
            const SizedBox(height: 16),
            
            const Text(
              'Jam yang dipilih:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: sortedSlots.map((slot) {
                return Chip(label: Text(slot));
              }).toList(),
            ),
            const SizedBox(height: 24),
            
            _buildDetailRow('Lokasi', venue.address),
            _buildDetailRow('Buka', '${venue.openTime} - ${venue.closeTime}'),
            const SizedBox(height: 8),
            
            const Divider(),
            _buildDetailRow('Harga per jam', _formatCurrency(venue.price)),
            _buildDetailRow('Durasi', '${sortedSlots.length} jam'),
            const Divider(),
            _buildDetailRow(
              'Total Harga',
              _formatCurrency(totalPrice.toString()),
              isBold: true,
            ),
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Booking dikonfirmasi!")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text(
                  'Konfirmasi Booking',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}