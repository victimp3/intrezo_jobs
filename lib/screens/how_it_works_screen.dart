import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'main_screen.dart';

class HowItWorksScreen extends StatefulWidget {
  const HowItWorksScreen({super.key});

  @override
  State<HowItWorksScreen> createState() => _HowItWorksScreenState();
}

class _HowItWorksScreenState extends State<HowItWorksScreen> {
  int _currentStep = 1;

  List<Map<String, String>> get steps => [
    {
      'title': 'how_step1_title'.tr(),
      'subtitle': 'how_step1_sub'.tr(),
    },
    {
      'title': 'how_step2_title'.tr(),
      'subtitle': 'how_step2_sub'.tr(),
    },
    {
      'title': 'how_step3_title'.tr(),
      'subtitle': 'how_step3_sub'.tr(),
    },
    {
      'title': 'how_step4_title'.tr(),
      'subtitle': 'how_step4_sub'.tr(),
    },
  ];

  void _nextStep() {
    setState(() {
      if (_currentStep < steps.length) {
        _currentStep++;
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    });
  }

  void _skip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentSteps = steps;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Text(
                'how_it_works_title'.tr(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                  color: Color(0xFF001730),
                ),
              ),
              const SizedBox(height: 80),
              Expanded(
                child: ListView.builder(
                  itemCount: _currentStep,
                  itemBuilder: (context, index) => Column(
                    children: [
                      _StepTile(
                        number: index + 1,
                        title: currentSteps[index]['title']!,
                        subtitle: currentSteps[index]['subtitle']!,
                        showLine: index < _currentStep - 1,
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_currentStep < steps.length)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        ),
                        onPressed: _skip,
                        child: Text(
                          'how_skip'.tr(),
                          style: const TextStyle(fontSize: 16, fontFamily: 'Roboto'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF001730),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        ),
                        onPressed: _nextStep,
                        child: Text(
                          'how_next'.tr(),
                          style: const TextStyle(fontSize: 16, fontFamily: 'Roboto'),
                        ),
                      ),
                    )
                  ],
                )
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF001730),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                  ),
                  onPressed: _nextStep,
                  child: Text(
                    'how_start'.tr(),
                    style: const TextStyle(fontSize: 16, fontFamily: 'Roboto'),
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final int number;
  final String title;
  final String subtitle;
  final bool showLine;

  const _StepTile({
    required this.number,
    required this.title,
    required this.subtitle,
    this.showLine = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFF001730),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '$number',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            if (showLine)
              Container(
                width: 2,
                height: 40,
                color: Color(0xFF001730),
              )
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF001730),
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'RobotoMono',
                  color: Color(0xFF001730),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}