import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quick_court_booking/components/Banner/M/banner_custom.dart';
// import 'package:quick_court_booking/components/Banner/M/banner_m_style_2.dart';
// import 'package:quick_court_booking/components/Banner/M/banner_m_style_3.dart';
// import 'package:quick_court_booking/components/Banner/M/banner_m_style_4.dart';
import 'package:quick_court_booking/components/dot_indicators.dart';

import '../../../../constants.dart';

class FnbOfferCarousel extends StatefulWidget {
  const FnbOfferCarousel({
    super.key,
  });

  @override
  State<FnbOfferCarousel> createState() => _FnbOfferCarouselState();
}

class _FnbOfferCarouselState extends State<FnbOfferCarousel> {
  int _selectedIndex = 0;
  late PageController _pageController;
  late Timer _timer;

  
  List offers = const [
    CustomBanner(imagePath: 'assets/promotion/promo_1.jpg'),
    CustomBanner(imagePath: 'assets/promotion/promo_2.png'),
    CustomBanner(imagePath: 'assets/promotion/promo_3.png'),
    CustomBanner(imagePath: 'assets/promotion/promo_4.jpg'),
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
    return SizedBox(
      height: 200,
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
                height: 10,
                child: Row(
                  children: List.generate(
                    offers.length,
                    (index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: defaultPadding / 3),
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
