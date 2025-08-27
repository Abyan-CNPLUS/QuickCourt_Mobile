import 'dart:convert';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quick_court_booking/helper/category_icon_helper.dart';
import 'package:quick_court_booking/helper/facility_icon_helper.dart';
import 'package:quick_court_booking/models/venue_detail_model.dart';
// import 'package:quick_court_booking/screens/booking/views/booking_time_screen.dart';
import 'package:quick_court_booking/screens/booking/views/select_date_screen.dart';
// import 'package:quick_court_booking/screens/booking/views/select_date_screen.dart';
import 'package:quick_court_booking/screens/venue/views/components/appbar.dart';
import 'package:quick_court_booking/screens/venue/views/components/venue_carousel.dart';
import 'package:quick_court_booking/screens/venue/views/components/venue_detail_bottom_sheets.dart';

class DetailVenueScreen extends StatefulWidget {
  final int venueId;

  const DetailVenueScreen({super.key, required this.venueId});

  @override
  State<DetailVenueScreen> createState() => _DetailVenueScreenState();
}

class _DetailVenueScreenState extends State<DetailVenueScreen> {
  Map<String, dynamic>? venue;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVenue();
  }

  Future<void> fetchVenue() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.12:8000/api/venues/${widget.venueId}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          venue = data['venue'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load venue');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String _formatCurrency(dynamic price) {
    if (price == null) return 'Harga tidak tersedia';

    try {
      final intValue = int.tryParse(price.toString()) ?? 0;
      return 'Rp ${intValue.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]}.',
          )}';
    } catch (e) {
      return 'Rp -';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VenueCarousel(
                        imageUrls: venue?['images'] != null
                            ? List<String>.from(
                                venue!['images'].map(
                                    (img) => getFullImageUrl(img['image_url'])),
                              )
                            : [],
                      ),

                      // const SizedBox(height: 250),

                      Transform.translate(
                        offset: const Offset(0, -30),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    venue?['name'] ?? 'No name',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(0, 0, 0, 1)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              240, 240, 240, 1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              getCategoryIcon(venue?['category']
                                                      ?['name'] ??
                                                  ''),
                                              size: 16,
                                              color: Colors.black54,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              venue?['category']?['name'] ??
                                                  'Unknown Category',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(
                                        Icons.brightness_1,
                                        size: 8,
                                        color: Color.fromRGBO(0, 0, 0, 0.4),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        venue?['city']?['name'] ??
                                            'Unknown City',
                                        style: const TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  const DottedLine(
                                    direction: Axis.horizontal,
                                    lineLength: double.infinity,
                                    lineThickness: 1.0,
                                    dashLength: 4.0,
                                    dashColor: Colors.grey,
                                  ),
                                  const SizedBox(height: 12),
                                  const Text("Deskripsi",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  const SizedBox(height: 0),
                                  Text(
                                    venue?['deskripsi'] ??
                                        'Tidak ada deskripsi.',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 12),
                                  const Text("Rules",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  const SizedBox(height: 0),
                                  Text(
                                    venue?['rules'] ?? 'Tidak ada rules.',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        enableDrag: false,
                                        isDismissible: false,
                                        backgroundColor: Colors.transparent,
                                        builder: (_) => VenueDetailBottomSheet(
                                            venue: venue!),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(0, 0),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: const Text(
                                      'Selengkapnya',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: 16.0, vertical: 8),
                      //   child: Text(
                      //     venue?['description'] ?? 'Tidak ada deskripsi.',
                      //     style: const TextStyle(fontSize: 16),
                      //   ),
                      // ),

                      if (venue?['facilities'] != null &&
                          venue!['facilities'].isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8),
                          child: Material(
                            elevation: 1,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        List<Widget> chips = [];
                                        double totalWidth = 0;
                                        const chipSpacing = 6.0;

                                        for (var fasilitas
                                            in venue!['facilities']) {
                                          final chip = Chip(
                                            avatar: Icon(
                                              getFacilityIcon(
                                                  fasilitas['name']),
                                              size: 16,
                                              color: Colors.blue,
                                            ),
                                            label: Text(fasilitas['name']),
                                          );

                                          final estWidth =
                                              (fasilitas['name'] as String)
                                                          .length *
                                                      8 +
                                                  48;
                                          totalWidth += estWidth + chipSpacing;

                                          if (totalWidth >
                                              constraints.maxWidth - 0) {
                                            chips.add(const Text("...",
                                                style:
                                                    TextStyle(fontSize: 16)));
                                            break;
                                          }

                                          chips.add(Padding(
                                            padding: const EdgeInsets.only(
                                                right: chipSpacing),
                                            child: chip,
                                          ));
                                        }

                                        return Row(
                                          children: chips,
                                        );
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (_) => VenueDetailBottomSheet(
                                            venue: venue!),
                                      );
                                    },
                                    icon: const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 15),
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
                const Positioned(
                  top: 0,
                  left: 10,
                  right: 0,
                  child: SafeArea(child: VenueAppBar()),
                ),
              ],
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        height: 65,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatCurrency(venue?['price']),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  if (venue != null) {
                    final venueModel = VenueDetail.fromJson(venue!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectDateScreen(
                          venue: venueModel,
                          venueId: widget.venueId,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Data venue belum tersedia')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Pilih Lapangan',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
