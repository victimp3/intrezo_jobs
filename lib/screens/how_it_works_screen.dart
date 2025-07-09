import 'package:flutter/material.dart';

class HowItWorksScreen extends StatefulWidget {
  const HowItWorksScreen({super.key});

  @override
  State<HowItWorksScreen> createState() => _HowItWorksScreenState();
}

class _HowItWorksScreenState extends State<HowItWorksScreen> {
  int _currentStep = 0;

  final List<Map<String, String>> _steps = [
    {
      'title': 'Explore job offers!',
      'subtitle': 'Check out the latest jobs',
    },
    {
      'title': 'Select a job!',
      'subtitle': 'Read details like salary, hours, and etc.',
    },
    {
      'title': 'Apply easily!',
      'subtitle': 'Fill in a short form and submit',
    },
    {
      'title': 'Get confirmation!',
      'subtitle': 'You’ll be notified after applying',
    },
  ];

  void _nextStep() {
    setState(() {
      if (_currentStep < _steps.length - 1) {
        _currentStep++;
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  void _skip() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final current = _steps[_currentStep];

    return GestureDetector(
      onTap: _nextStep,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    'HOW IT WORKS',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        for (int i = 0; i <= _currentStep; i++) ...[
                          Align(
                            alignment: Alignment.center,
                            child: _StepCard(
                              title: _steps[i]['title']!,
                              subtitle: _steps[i]['subtitle']!,
                            ),
                          ),
                          if (i < _currentStep)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Icon(Icons.arrow_downward, size: 24),
                            ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_currentStep < _steps.length - 1)
                    TextButton(
                      onPressed: _skip,
                      child: const Text(
                        'SKIP',
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  if (_currentStep == _steps.length - 1)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF001730),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                        ),
                        onPressed: _nextStep,
                        child: const Text(
                          'START',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _StepCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF001730),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }
}