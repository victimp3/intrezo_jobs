import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

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
        SnackBar(content: Text('error_privacy'.tr())),
      );
    }
  }

  void _shareApp() {
    Share.share('share_message'.tr());
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
                  Text(
                    'settings'.tr(),
                    style: const TextStyle(
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
                    title: Text('privacy_policy'.tr(), style: const TextStyle(color: Colors.white)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onTap: _openPrivacyPolicy,
                  ),
                  const Divider(color: Colors.white24, thickness: 1),
                  ListTile(
                    leading: const Icon(Icons.description, color: Colors.white),
                    title: Text('terms'.tr(), style: const TextStyle(color: Colors.white)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('page_unavailable'.tr())),
                      );
                    },
                  ),
                  const Divider(color: Colors.white24, thickness: 1),
                  ListTile(
                    leading: const Icon(Icons.share, color: Colors.white),
                    title: Text('share'.tr(), style: const TextStyle(color: Colors.white)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onTap: _shareApp,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}