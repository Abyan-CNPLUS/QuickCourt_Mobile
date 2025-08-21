import 'package:flutter/material.dart';
import 'package:quick_court_booking/helper/category_icon_helper.dart';
import 'package:quick_court_booking/models/venue_model.dart';
import 'package:quick_court_booking/screens/venue/views/detail_screen.dart';

class VenueCard extends StatelessWidget {
  final Venue venue;
  final bool isHorizontal;
  final VoidCallback? onTap;

  const VenueCard({
    super.key,
    required this.venue,
    this.isHorizontal = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailVenueScreen(venueId: venue.id),
              ),
            );
          },
      borderRadius: BorderRadius.circular(12),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: isHorizontal
            ? SizedBox(
                width: 240,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: venue.thumbnail != null && venue.thumbnail!.isNotEmpty
                          ? Image.network(
                              venue.thumbnail!,
                              height: 95,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                'assets/promotion/promo_1.jpg',
                                height: 95,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              'assets/promotion/promo_2.png',
                              height: 95,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            venue.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(240, 240, 240, 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      getCategoryIcon(
                                          venue.category),
                                      size: 12,
                                      color: Colors.black38,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      venue.category,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        // color: Colors.black87,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
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
                                venue.city,
                                style: const TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 0.6),
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                    child: venue.thumbnail != null && venue.thumbnail!.isNotEmpty
                        ? Image.network(
                            venue.imageUrl,
                            height: 90,
                            width: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              'assets/promotion/promo_1.jpg',
                              height: 90,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            'assets/promotion/promo_2.png',
                            height: 90,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            venue.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(240, 240, 240, 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      getCategoryIcon(
                                          venue.category),
                                      size: 12,
                                      color: Colors.black38,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      venue.category,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        // color: Colors.black87,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
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
                                venue.city,
                                style: const TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 0.6),
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
