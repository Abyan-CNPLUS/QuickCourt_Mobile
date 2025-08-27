import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quick_court_booking/models/booking_owner_model.dart';

class BookingListScreen extends StatefulWidget {
  final int venueId;

  const BookingListScreen({Key? key, required this.venueId}) : super(key: key);

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  bool isLoading = true;
  List<BookingOwner> bookings = [];
  String? error;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('laravel_token');
  }

  Future<void> fetchBookings() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token tidak ditemukan");

      final url = Uri.parse(
          "http://192.168.1.12:8000/api/owner/venues/${widget.venueId}/bookings");
      final response = await http.get(url, headers: {
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rawBookings = data['bookings'] as List<dynamic>;

        setState(() {
          bookings =
              rawBookings.map((json) => BookingOwner.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception("Gagal ambil data: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> updateStatus(int bookingId, String newStatus) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token tidak ditemukan");

      final url = Uri.parse(
          "http://192.168.1.12:8000/api/owner/bookings/$bookingId/status");
      final response = await http.put(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode({"status": newStatus}),
      );

      if (response.statusCode == 200) {
        setState(() {
          final idx = bookings.indexWhere((b) => b.id == bookingId);
          if (idx != -1) {
            bookings[idx] = bookings[idx].copyWith(status: newStatus);
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Status booking diperbarui ke $newStatus")),
        );
      } else {
        throw Exception("Gagal update status: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error update status: $e")),
      );
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green.shade600;
      case 'pending':
        return Colors.orange.shade600;
      case 'cancelled':
        return Colors.red.shade600;
      case 'rejected':
        return Colors.red.shade900;
      case 'completed':
        return Colors.blue.shade600;
      default:
        return Colors.grey;
    }
  }

  String formatRupiah(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  Widget statusBadge(String status) {
    final color = getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style:
            TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text("Error: $error"))
              : bookings.isEmpty
                  ? const Center(child: Text("Tidak ada booking"))
                  : RefreshIndicator(
                      onRefresh: fetchBookings,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: bookings.length,
                        itemBuilder: (context, index) {
                          final booking = bookings[index];
                          final statusColor = getStatusColor(booking.status);

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Tanggal + Status Badge
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                              Icons.calendar_today_outlined,
                                              size: 20,
                                              color: Colors.black87),
                                          const SizedBox(width: 6),
                                          Text(
                                            booking.date,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      statusBadge(booking.status),
                                    ],
                                  ),
                                ),

                                const Divider(height: 1),

                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: booking.userPhotoUrl != null &&
                                                booking.userPhotoUrl!.isNotEmpty
                                            ? Image.network(
                                                booking.userPhotoUrl!,
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) =>
                                                    Container(
                                                  width: 60,
                                                  height: 60,
                                                  color: Colors.grey[300],
                                                  child: const Icon(
                                                      Icons.broken_image,
                                                      color: Colors.grey),
                                                ),
                                              )
                                            : Container(
                                                width: 60,
                                                height: 60,
                                                color: Colors.grey[300],
                                                child: const Icon(Icons.person,
                                                    color: Colors.grey),
                                              ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              booking.venueName,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              booking.time,
                                              style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const Divider(height: 1),

                                // Total Harga + User + Action
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "User: ${booking.userName}",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Total Harga: ${formatRupiah(booking.totalPrice)}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert),
                                        onSelected: (value) =>
                                            updateStatus(booking.id, value),
                                        itemBuilder: (context) => const [
                                          PopupMenuItem(
                                              value: 'pending',
                                              child: Text('Pending')),
                                          PopupMenuItem(
                                              value: 'confirmed',
                                              child: Text('Confirmed')),
                                          PopupMenuItem(
                                              value: 'cancelled',
                                              child: Text('Cancelled')),
                                          PopupMenuItem(
                                              value: 'rejected',
                                              child: Text('Rejected')),
                                          PopupMenuItem(
                                              value: 'completed',
                                              child: Text('Completed')),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
