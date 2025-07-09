import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/how_it_works_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/how-it-works': (context) => const HowItWorksScreen(),
      },
    );
  }
}