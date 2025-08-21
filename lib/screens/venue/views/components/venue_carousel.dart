import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class VenueCarousel extends StatefulWidget {
  final List<String> imageUrls;

  const VenueCarousel({super.key, required this.imageUrls});

  @override
  State<VenueCarousel> createState() => _VenueCarouselState();
}

class _VenueCarouselState extends State<VenueCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Jangan setup timer kalau tidak ada gambar
    if (widget.imageUrls.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startAutoSlide();
      });
    }
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (!mounted || !_pageController.hasClients) return;

      if (_currentIndex < widget.imageUrls.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('Belum ada gambar')),
      );
    }

    return SizedBox(
      height: 280,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                widget.imageUrls[index],
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.broken_image));
                },
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              );
            },
          ),
          Positioned(
            bottom: 40,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: widget.imageUrls.length,
              effect: ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                spacing: 8,
                activeDotColor: Colors.white,
                dotColor: Colors.white.withOpacity(0.6),
              ),
            ),
          )
        ],
      ),
    );
  }
}
