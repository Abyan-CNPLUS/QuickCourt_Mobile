import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_court_booking/entry_point.dart';
import 'package:quick_court_booking/route/route_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnAuth();
  }

  void _navigateBasedOnAuth() async {
    await Future.delayed(const Duration(seconds: 7)); 

    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const EntryPoint()),
      );
    } else {
     
      Navigator.pushReplacementNamed(context, onbordingScreenRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/animation/Rocket_Launch.json',
        ),
      ),
    );
  }
}
