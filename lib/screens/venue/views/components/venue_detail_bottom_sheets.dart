import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quick_court_booking/helper/facility_icon_helper.dart';

class VenueDetailBottomSheet extends StatefulWidget {
  final Map<String, dynamic> venue;

  const VenueDetailBottomSheet({super.key, required this.venue});

  @override
  State<VenueDetailBottomSheet> createState() => _VenueDetailBottomSheetState();
}

class _VenueDetailBottomSheetState extends State<VenueDetailBottomSheet>
    with SingleTickerProviderStateMixin {
  List<bool> _visibleList = [false, false, false, false]; // deskripsi, rules, fasilitas-title, fasilitas-wrap

  @override
  void initState() {
    super.initState();
    _triggerAnimations();
  }

  void _triggerAnimations() async {
    for (int i = 0; i < _visibleList.length; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (mounted) {
        setState(() {
          _visibleList[i] = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              
              AnimatedOpacity(
                opacity: _visibleList[0] ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Deskripsi', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(widget.venue['deskripsi'] ?? 'Tidak ada deskripsi.'),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              AnimatedOpacity(
                opacity: _visibleList[1] ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Aturan Venue', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(widget.venue['rules'] ?? 'Tidak ada aturan.'),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              AnimatedOpacity(
                opacity: _visibleList[2] ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: Text('Fasilitas', style: Theme.of(context).textTheme.titleMedium),
              ),

              const SizedBox(height: 8),

              AnimatedOpacity(
                opacity: _visibleList[3] ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List<Widget>.from(
                    widget.venue['facilities']?.map<Widget>((fasilitas) {
                          return Chip(
                            avatar: Icon(
                              getFacilityIcon(fasilitas['name']),
                              size: 16,
                              color: Colors.blue,
                            ),
                            label: Text(fasilitas['name']),
                          );
                        }) ??
                        [],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
