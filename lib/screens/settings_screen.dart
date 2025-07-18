import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _openPrivacyPolicy() async {
    final uri = Uri.parse('https://intrezo.ee/est/andmekaitsetingimused/');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Privacy Policy link.')),
      );
    }
  }

  void _shareApp() {
    Share.share('Check out Intrezo: https://intrezo.ee/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001730),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Назад + Settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 105),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),

            // Секция настроек
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  const Divider(color: Colors.white24, thickness: 1),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip, color: Colors.white),
                    title: const Text('Privacy Policy', style: TextStyle(color: Colors.white)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onTap: _openPrivacyPolicy,
                  ),
                  const Divider(color: Colors.white24, thickness: 1),
                  ListTile(
                    leading: const Icon(Icons.description, color: Colors.white),
                    title: const Text('Terms and Conditions', style: TextStyle(color: Colors.white)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Page not available yet.')),
                      );
                    },
                  ),
                  const Divider(color: Colors.white24, thickness: 1),
                  ListTile(
                    leading: const Icon(Icons.share, color: Colors.white),
                    title: const Text('Share', style: TextStyle(color: Colors.white)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onTap: _shareApp,
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Переключение языков
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Русский', style: TextStyle(color: Colors.white.withOpacity(0.7))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'English',
                      style: TextStyle(color: Color(0xFF001730), fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text('Українська', style: TextStyle(color: Colors.white.withOpacity(0.7))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}