import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'home_screen.dart';
import 'about_us_screen.dart';
import 'contact_screen.dart';
import '../widgets/bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    AboutUsScreen(),
    ContactScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Ключевое изменение для фиксации футера
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        activeIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}