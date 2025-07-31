import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'vacancy_detail_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showFavourites = false;
  bool sortNewestFirst = true;
  List<Map<String, dynamic>> allJobs = [];
  List<Map<String, dynamic>> favouriteJobs = [];

  @override
  void initState() {
    super.initState();
    loadJobs();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.locale; // доступ к locale заставляет rebuild при смене языка
  }

  Future<void> loadJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('favouriteJobs') ?? [];

    final query = await FirebaseFirestore.instance.collection('vacancies').get();

    final jobs = query.docs.map((doc) {
      final data = doc.data();
      return {
        'title': data['title'],
        'description': data['description'],
        'salary': data['salary'],
        'location': data['location'],
        'posted_at': data['posted_at'],
        'image': data['image'],
        'type': data['type'],
        'language_requirement': data['language_requirement'],
        'housing': data['housing'],
        'job_description': data['job_description'],
        'requirements': data['requirements'],
        'benefits': data['benefits'],
      };
    }).toList();

    setState(() {
      allJobs = jobs;
      favouriteJobs = jobs.where((job) => saved.contains(job['title'])).toList();
    });
  }

  Future<void> saveFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final favTitles = favouriteJobs.map((job) => job['title'] as String).toList();
    await prefs.setStringList('favouriteJobs', favTitles);
  }

  void toggleFavourite(Map<String, dynamic> job) {
    setState(() {
      if (isFavourite(job)) {
        favouriteJobs.removeWhere((item) => item['title'] == job['title']);
      } else {
        favouriteJobs.add(job);
      }
      saveFavourites();
    });
  }

  bool isFavourite(Map<String, dynamic> job) {
    return favouriteJobs.any((item) => item['title'] == job['title']);
  }

  List<Map<String, dynamic>> getSortedJobs() {
    List<Map<String, dynamic>> jobs = showFavourites ? [...favouriteJobs] : [...allJobs];

    jobs.sort((a, b) {
      final aDate = DateTime.tryParse(a['posted_at'] ?? '') ?? DateTime(2000);
      final bDate = DateTime.tryParse(b['posted_at'] ?? '') ?? DateTime(2000);
      return sortNewestFirst ? bDate.compareTo(aDate) : aDate.compareTo(bDate);
    });

    return jobs;
  }

  @override
  Widget build(BuildContext context) {
    final jobs = getSortedJobs();
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      endDrawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 150),
              _drawerItem(Icons.description, 'documents', '/documents'),
              _drawerItem(Icons.help_outline, 'faq', '/faq'),
              _drawerItem(Icons.settings, 'settings', '/settings'),
              ListTile(
                leading: const Icon(Icons.language, color: Color(0xFF001730)),
                title: Text(
                  'our_website'.tr(),
                  style: const TextStyle(color: Color(0xFF001730), fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  final lang = context.locale.languageCode;
                  String url = lang == 'ru' || lang == 'uk'
                      ? 'https://intrezo.ee/ru/%D0%B3%D0%BB%D0%B0%D0%B2%D0%BD%D0%B0%D1%8F/'
                      : 'https://intrezo.ee/en/homepage/';
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not launch website.')),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: _buildLanguageSelector(context),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Color(0xFF545D68)),
        title: Image.network(
          'https://firebasestorage.googleapis.com/v0/b/intrezo-jobs.firebasestorage.app/o/headerLogo.png?alt=media&token=7a42e732-ea3d-42c3-bb2a-ae5e6cd1a295',
          height: 40,
          errorBuilder: (context, error, stackTrace) {
            return const Text('INTREZO', style: TextStyle(color: Color(0xFF001730)));
          },
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: const SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: Text(
              'vacancy_list'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
                color: Color(0xFF001730),
              ),
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 30)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => sortNewestFirst = !sortNewestFirst),
                  icon: Icon(sortNewestFirst ? Icons.arrow_downward : Icons.arrow_upward),
                  label: Text(sortNewestFirst ? 'newest_first'.tr() : 'oldest_first'.tr()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF001730),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _toggleTab('available_positions'.tr(), !showFavourites, () => setState(() => showFavourites = false)),
                const SizedBox(width: 32),
                _toggleTab('favourites'.tr(), showFavourites, () => setState(() => showFavourites = true)),
              ],
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 330,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VacancyDetailScreen(vacancy: job),
                        ),
                      );
                    },
                    child: _JobCard(
                      job: job,
                      isFavourite: isFavourite(job),
                      onToggleFavourite: () => toggleFavourite(job),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 16),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            fillOverscroll: true,
            child: SizedBox(height: bottomPadding),
          ),
        ],
      ),
    );
  }

  Widget _toggleTab(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold,
          color: isActive ? const Color(0xFF001730) : Colors.black.withOpacity(0.4),
        ),
      ),
    );
  }

  ListTile _drawerItem(IconData icon, String key, String route) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF001730)),
      title: Text(key.tr(), style: const TextStyle(color: Color(0xFF001730), fontWeight: FontWeight.bold)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    final locales = [
      {'label': 'Русский', 'locale': const Locale('ru')},
      {'label': 'English', 'locale': const Locale('en')},
      {'label': 'Українська', 'locale': const Locale('uk')},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: locales.map((lang) {
        final isActive = context.locale == lang['locale'];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 4),
          child: Container(
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF001730) : Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton(
              style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16)),
              onPressed: () {
                context.setLocale(lang['locale'] as Locale);
                Navigator.pop(context);
              },
              child: Text(
                lang['label'] as String,
                style: TextStyle(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _JobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final bool isFavourite;
  final VoidCallback onToggleFavourite;

  const _JobCard({
    required this.job,
    required this.isFavourite,
    required this.onToggleFavourite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: const Color(0xFF001730),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: job['image'].toString().startsWith('http')
                    ? Image.network(
                  job['image'],
                  height: 130,
                  width: 250,
                  fit: BoxFit.cover,
                )
                    : Image.asset(
                  'assets/images/${job['image']}',
                  height: 130,
                  width: 250,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onToggleFavourite,
                  child: Icon(
                    Icons.bookmark,
                    color: isFavourite ? Colors.amber : Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    job['title'].toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  job['description'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'RobotoMono',
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  job['salary'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RobotoMono',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  job['location'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'RobotoMono',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  job['type'] ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'RobotoMono',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    job['posted_at'],
                    style: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'RobotoMono',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}