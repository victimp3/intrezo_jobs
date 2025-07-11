import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Image.asset('assets/images/headerLogo.png', height: 40),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Text(
                'Contact',
                style: TextStyle(
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
                    const Center(
                      child: Text(
                        'Intrezo OÜ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Address',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const Text(
                      'Lelle Tn 24\nTallinn, Harjumaa 11318',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Phone',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const Text(
                      '+372 56836668\n+372 6773091',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _launchEmail,
                      child: const Text(
                        'Email',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    GestureDetector(
                      onTap: _launchEmail,
                      child: const Text(
                        'info@intrezo.ee',
                        style: TextStyle(color: Colors.white70, fontSize: 14, decoration: TextDecoration.underline),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Registry code',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
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
                          icon: Image.asset('assets/images/whatsapp.png', height: 20),
                          label: const Text("WhatsApp\nContact Us", textAlign: TextAlign.left),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _launchMessenger("viber://chat?number=+3725294917"),
                          icon: Image.asset('assets/images/viber.png', height: 20),
                          label: const Text("Viber\nContact Us", textAlign: TextAlign.left),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7360F2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () => _launchMessenger("https://t.me/+3725294917"),
                        icon: Image.asset('assets/images/telegram.png', height: 20),
                        label: const Text("Telegram\nContact Us", textAlign: TextAlign.left),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0088cc),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Image.asset('assets/images/facebook.png', width: 40, height: 40),
                    const SizedBox(width: 16),
                    Image.asset('assets/images/linkedin.png', width: 40, height: 40),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFF001730),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home,
              label: 'Home',
              onTap: () => Navigator.pushNamed(context, '/home'),
            ),
            _NavItem(
              icon: Icons.info,
              label: 'About Us',
              onTap: () => Navigator.pushNamed(context, '/how-it-works'),
            ),
            const _NavItem(
              icon: Icons.call,
              label: 'Contact',
              isActive: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isActive ? const Color(0xFF001730) : Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}