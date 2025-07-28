import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

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
                    child: _StatItem(value: '93%', labelKey: 'repeat_orders'),
                  ),
                  Expanded(
                    child: _StatItem(value: '15+', labelKey: 'years_experience'),
                  ),
                  Expanded(
                    child: _StatItem(value: '2-3', labelKey: 'candidates_enough'),
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
                  Text(
                    'our_mission_title'.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: Color(0xFF001730),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'our_mission_text'.tr(),
                    style: const TextStyle(
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
                  Text(
                    'our_vision_title'.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: Color(0xFF001730),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'our_vision_text'.tr(),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
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
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String labelKey;

  const _StatItem({required this.value, required this.labelKey});

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
          labelKey.tr(),
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