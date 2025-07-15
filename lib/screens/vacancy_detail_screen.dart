import 'package:flutter/material.dart';
import 'application_form_screen.dart';

class VacancyDetailScreen extends StatelessWidget {
  final Map<String, dynamic> vacancy;

  const VacancyDetailScreen({Key? key, required this.vacancy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final image = vacancy['image'] ?? '';
    final title = vacancy['title'] ?? '';
    final salary = vacancy['salary'] ?? '';
    final location = vacancy['location'] ?? '';
    final type = vacancy['type'] ?? '';
    final language = vacancy['language_requirement'] ?? '';
    final housing = vacancy['housing'] ?? '';
    final jobDescription = vacancy['job_description'] ?? '';
    final requirements = List<String>.from(vacancy['requirements'] ?? []);
    final benefits = List<String>.from(vacancy['benefits'] ?? []);

    return Scaffold(
      backgroundColor: const Color(0xFFf4f5f4),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ВЕРХНЯЯ КАРТИНКА + КНОПКА НАЗАД
            Stack(
              clipBehavior: Clip.none,
              children: [
                image.startsWith('http')
                    ? Image.network(
                  image,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                )
                    : Image.asset(
                  'assets/images/$image',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -40,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF001730),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(salary, style: _infoTextStyle),
                        Text(location, style: _infoTextStyle),
                        Text(type, style: _infoTextStyle),
                        Text(language, style: _infoTextStyle),
                        Text(housing, style: _infoTextStyle),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 56),

            // JOB DESCRIPTION
            _buildSectionTitle('Job Description'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                jobDescription,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  fontFamily: 'RobotoMono',
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),

            // REQUIREMENTS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSectionTitle('Requirements'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: requirements
                    .map((req) => Text(
                  '• $req',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontFamily: 'RobotoMono',
                    fontSize: 14,
                  ),
                ))
                    .toList(),
              ),
            ),

            const SizedBox(height: 16),
            const Divider(),

            // BENEFITS
            _buildSectionTitle('Benefits'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: benefits.map((b) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '• $b',
                      style: const TextStyle(
                        fontFamily: 'RobotoMono',
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 32),

// APPLY BUTTON
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ApplicationFormScreen(),
                    ),
                  );
                },
                child: const Text(
                  'APPLY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }

  TextStyle get _infoTextStyle => const TextStyle(
    color: Colors.white,
    fontFamily: 'RobotoMono',
  );
}