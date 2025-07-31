import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Фоновое изображение с логотипом
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    'https://firebasestorage.googleapis.com/v0/b/intrezo-jobs.firebasestorage.app/o/team_photo.png?alt=media&token=e38b9cc5-6566-45c4-8baf-d39cd055a36d',
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: const [
                    Expanded(child: _StatItem(value: '93%', labelKey: 'repeat_orders')),
                    Expanded(child: _StatItem(value: '15+', labelKey: 'years_experience')),
                    Expanded(child: _StatItem(value: '2-3', labelKey: 'candidates_enough')),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/intrezo-jobs.firebasestorage.app/o/mission_image.png?alt=media&token=2b0a77ad-dc1f-408b-847e-ad9c5926ee29',
                      ),
                    ),
                    const SizedBox(height: 40),
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

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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