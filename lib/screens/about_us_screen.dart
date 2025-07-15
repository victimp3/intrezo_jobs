import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Фоновое изображение с логотипом
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset('assets/images/team_photo.png'),
                Positioned(
                  top: 60,
                  child: Image.asset(
                    'assets/images/headerLogo.png',
                    height: 40,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Блок с цифрами
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: const [
                  Expanded(
                    child: _StatItem(value: '93%', label: 'Repeat orders rate'),
                  ),
                  Expanded(
                    child: _StatItem(value: '15+', label: 'Years of experience'),
                  ),
                  Expanded(
                    child: _StatItem(value: '2-3', label: 'Candidates are enough'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Блок Our Mission
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/mission_image.png'),
                  const SizedBox(height: 16),
                  const Text(
                    'OUR MISSION',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: Color(0xFF001730),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Our mission is to provide personal and high-quality service by valuing honesty and orderliness. We provide security for our partners as well as opportunities for self-fulfilment for good employees.',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'RobotoMono',
                      color: Colors.black,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Блок Our Vision
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset('assets/images/vision_image.png'),
                  const SizedBox(height: 16),
                  const Text(
                    'OUR VISION',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: Color(0xFF001730),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Our vision is to be the best workforce outsourcing company in the HORECA and food industry sectors in Northern Europe.',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'RobotoMono',
                      color: Colors.black,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),

      // Футер
      bottomNavigationBar: Container(
        color: const Color(0xFF001730),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home,
              label: 'Home',
              onTap: () => Navigator.pushNamed(context, '/home'),
            ),
            _NavItem(
              icon: Icons.info,
              label: 'About Us',
              isActive: true,
            ),
            _NavItem(
              icon: Icons.call,
              label: 'Contact',
              onTap: () => Navigator.pushNamed(context, '/contact'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
            color: Color(0xFF001730),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontFamily: 'RobotoMono',
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isActive ? const Color(0xFF001730) : Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}