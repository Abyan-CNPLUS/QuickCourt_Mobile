import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quick_court_booking/components/Banner/M/banner_m_style_1.dart';
// import 'package:quick_court_booking/components/Banner/M/banner_m_style_2.dart';
// import 'package:quick_court_booking/components/Banner/M/banner_m_style_3.dart';
// import 'package:quick_court_booking/components/Banner/M/banner_m_style_4.dart';
import 'package:quick_court_booking/components/dot_indicators.dart';

import '../../../../constants.dart';

class OffersCarousel extends StatefulWidget {
  const OffersCarousel({
    super.key,
  });

  @override
  State<OffersCarousel> createState() => _OffersCarouselState();
}

class _OffersCarouselState extends State<OffersCarousel> {
  int _selectedIndex = 0;
  late PageController _pageController;
  late Timer _timer;

  
  List offers = const [
    SimpleBanner(imagePath: 'assets/promotion/promo_1.jpg'),
    SimpleBanner(imagePath: 'assets/promotion/promo_2.png'),
    SimpleBanner(imagePath: 'assets/promotion/promo_3.png'),
    SimpleBanner(imagePath: 'assets/promotion/promo_4.jpg'),
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_selectedIndex < offers.length - 1) {
        _selectedIndex++;
      } else {
        _selectedIndex = 0;
      }

      _pageController.animateToPage(
        _selectedIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInExpo,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.87,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: offers.length,
            onPageChanged: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            itemBuilder: (context, index) => offers[index],
          ),
          FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: SizedBox(
                height: 48,
                child: Row(
                  children: List.generate(
                    offers.length,
                    (index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: defaultPadding / 4),
                        child: DotIndicator(
                          isActive: index == _selectedIndex,
                          activeColor: Colors.black38,
                          inActiveColor: Colors.black12,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
