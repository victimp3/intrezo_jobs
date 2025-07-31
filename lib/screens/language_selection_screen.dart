import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'how_it_works_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  Locale? _selectedLocale;

  Future<void> _confirmLanguage() async {
    if (_selectedLocale == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('language_selected', true);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HowItWorksScreen()),
    );
  }

  void _onLangTap(Locale locale) async {
    _selectedLocale = locale;

    await context.setLocale(locale); // ✅ применяем язык сразу
    setState(() {}); // 🔁 перестраиваем интерфейс
  }

  @override
  Widget build(BuildContext context) {
    final current = _selectedLocale ?? context.locale;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tr('choose_language'),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF001730),
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 32),
                _buildLangButton('English', const Locale('en'), current),
                const SizedBox(height: 16),
                _buildLangButton('Русский', const Locale('ru'), current),
                const SizedBox(height: 16),
                _buildLangButton('Українська', const Locale('uk'), current),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _confirmLanguage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF001730),
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    tr('continue'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLangButton(String label, Locale locale, Locale currentLocale) {
    final isActive = currentLocale == locale;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _onLangTap(locale),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: isActive ? const Color(0xFF001730) : Colors.white,
          side: BorderSide(
            color: isActive ? const Color(0xFF001730) : Colors.grey,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            color: isActive ? Colors.white : const Color(0xFF001730),
          ),
        ),
      ),
    );
  }
}