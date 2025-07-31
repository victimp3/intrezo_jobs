import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  void _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'info@intrezo.ee',
    );
    await launchUrl(emailLaunchUri);
  }

  void _launchMessenger(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Center(
                          child: Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/intrezo-jobs.firebasestorage.app/o/headerLogo.png?alt=media&token=7a42e732-ea3d-42c3-bb2a-ae5e6cd1a295',
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'nav.contact'.tr(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                          color: Color(0xFF001730),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF001730),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'company_name'.tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text('address'.tr(), style: const TextStyle(color: Colors.white, fontSize: 16)),
                            const Text(
                              'Lelle Tn 24\nTallinn, Harjumaa 11318',
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                            const SizedBox(height: 16),
                            Text('phone'.tr(), style: const TextStyle(color: Colors.white, fontSize: 16)),
                            const Text(
                              '+372 56836668\n+372 6773091',
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: _launchEmail,
                              child: Text('email'.tr(), style: const TextStyle(color: Colors.white, fontSize: 16)),
                            ),
                            GestureDetector(
                              onTap: _launchEmail,
                              child: const Text(
                                'info@intrezo.ee',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text('registry_code'.tr(), style: const TextStyle(color: Colors.white, fontSize: 16)),
                            const Text(
                              '16440043',
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => _launchMessenger("https://wa.me/3725294917"),
                                  icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 30),
                                  label: Text("whatsapp_contact".tr(), textAlign: TextAlign.left),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF25D366),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => _launchMessenger("viber://chat?number=%2B3725294917"),
                                  icon: const FaIcon(FontAwesomeIcons.viber, color: Colors.white, size: 30),
                                  label: Text("viber_contact".tr(), textAlign: TextAlign.left),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF7360F2),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: () => _launchMessenger("https://t.me/+3725294917"),
                                icon: const FaIcon(FontAwesomeIcons.telegram, color: Colors.white, size: 30),
                                label: Text("telegram_contact".tr(), textAlign: TextAlign.left),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0088cc),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => _launchMessenger("https://www.facebook.com/people/Intrezo-HR/61570892398634/#"),
                              child: const FaIcon(FontAwesomeIcons.facebook, size: 30, color: Color(0xFF001730)),
                            ),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: () => _launchMessenger("https://ee.linkedin.com/company/intrezo-o%C3%BC"),
                              child: const FaIcon(FontAwesomeIcons.linkedin, size: 32, color: Color(0xFF001730)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}