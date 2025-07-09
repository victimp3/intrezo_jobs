import 'package:flutter/material.dart';

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

    // Ждём нажатия
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigate() async {
    await _controller.forward(); // запускаем анимацию
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/how-it-works');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _navigate,
      child: FadeTransition(
        opacity: ReverseAnimation(_animation),
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