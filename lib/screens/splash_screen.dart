import 'package:flutter/material.dart';
import 'how_it_works_screen.dart'; // экран с инструкцией

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

    _controller.forward(); // 🔹 ВАЖНО: запуск анимации
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigate() async {
    if (_controller.isAnimating) return; // не давать переходить во время анимации

    await _controller.forward(); // ещё раз на всякий случай
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HowItWorksScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _navigate,
      child: FadeTransition(
        opacity: _animation, // 🔸 без ReverseAnimation
        child: Container(
          color: const Color(0xFF001730),
          alignment: Alignment.center,
          child: Image.asset(
            'assets/images/logo.png',
            width: 250,
            height: 250,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}