import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';

import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/how_it_works_screen.dart';
import 'screens/home_screen.dart';
import 'screens/about_us_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/documents_screen.dart';
import 'screens/faq_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/webview_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
        Locale('uk'),
      ],
      path: 'assets/lang',
      fallbackLocale: const Locale('en'),
      saveLocale: true, // сохраняет язык между перезапусками
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'),
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/how-it-works': (context) => const HowItWorksScreen(),
        '/contact': (context) => const ContactScreen(),
        '/about-us': (context) => const AboutUsScreen(),
        '/documents': (context) => const DocumentsScreen(),
        '/faq': (context) => const FAQScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/webview': (context) => const WebViewScreen(url: 'https://intrezo.ee/en/homepage/')
      },
    );
  }
}