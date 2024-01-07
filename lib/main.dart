import 'package:flutter/material.dart';
import 'package:garden_mate/screens/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Garden Mate',
      home: OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
