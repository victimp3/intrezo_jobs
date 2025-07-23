import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'question': 'faq_q1',
        'answer': 'faq_a1',
      },
      {
        'question': 'faq_q2',
        'answer': 'faq_a2',
      },
      {
        'question': 'faq_q3',
        'answer': 'faq_a3',
      },
      {
        'question': 'faq_q4',
        'answer': 'faq_a4',
      },
      {
        'question': 'faq_q5',
        'answer': 'faq_a5',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Ink(
            decoration: const ShapeDecoration(
              shape: CircleBorder(),
              color: Color(0xFF001730),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'faq'.tr(),
          style: const TextStyle(fontFamily: 'RobotoMono', color: Colors.black),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final item = faqs[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF001730),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                title: Text(
                  item['question']!.tr(),
                  style: const TextStyle(
                    fontFamily: 'RobotoMono',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    color: Colors.white.withOpacity(0.1),
                    child: Text(
                      item['answer']!.tr(),
                      style: const TextStyle(
                        fontFamily: 'RobotoMono',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}