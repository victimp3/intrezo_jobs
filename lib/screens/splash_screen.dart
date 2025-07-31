import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'how_it_works_screen.dart';
import 'language_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward(); // 🔹 запуск анимации
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigate() async {
    if (_controller.isAnimating) return;

    await _controller.forward();
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final languageSelected = false;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => languageSelected
            ? const HowItWorksScreen()
            : const LanguageSelectionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _navigate,
      child: FadeTransition(
        opacity: _animation,
        child: Container(
          color: const Color(0xFF001730),
          alignment: Alignment.center,
          child: Image.network(
            'https://firebasestorage.googleapis.com/v0/b/intrezo-jobs.firebasestorage.app/o/logo.png?alt=media&token=10283c4c-5e21-458f-83d3-1a876c2c5e86',
            width: 250,
            height: 250,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}