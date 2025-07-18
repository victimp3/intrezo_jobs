import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'vacancy_detail_screen.dart';

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

    return Scaffold(
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 110),
            ListTile(
              leading: const Icon(Icons.description, color: Color(0xFF001730)),
              title: const Text(
                'Documents',
                style: TextStyle(
                  color: Color(0xFF001730),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                if (!mounted) return;
                Navigator.pushNamed(context, '/documents');
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Color(0xFF001730)),
              title: const Text(
                'FAQ',
                style: TextStyle(
                  color: Color(0xFF001730),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                if (!mounted) return;
                Navigator.pushNamed(context, '/faq');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xFF001730)),
              title: const Text(
                'Settings',
                style: TextStyle(
                  color: Color(0xFF001730),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                if (!mounted) return;
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Убирает стрелку назад
        iconTheme: const IconThemeData(color: Color(0xFF545D68)),
        title: Image.asset('assets/images/headerLogo.png', height: 40),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        color: const Color(0xFF001730),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home,
              label: 'Home',
              isActive: true,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              },
            ),
            _NavItem(
              icon: Icons.info,
              label: 'About Us',
              onTap: () {
                Navigator.pushNamed(context, '/about-us');
              },
            ),
            _NavItem(
              icon: Icons.call,
              label: 'Contact',
              onTap: () {
                Navigator.pushNamed(context, '/contact');
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'VACANCY LIST',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
                color: Color(0xFF001730),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      sortNewestFirst = !sortNewestFirst;
                    });
                  },
                  icon: Icon(sortNewestFirst ? Icons.arrow_downward : Icons.arrow_upward),
                  label: Text(sortNewestFirst ? 'Newest First' : 'Oldest First'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF001730),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showFavourites = false;
                    });
                  },
                  child: Text(
                    'AVAILABLE POSITIONS',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      color: !showFavourites
                          ? const Color(0xFF001730)
                          : Colors.black.withOpacity(0.4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showFavourites = true;
                    });
                  },
                  child: Text(
                    'FAVOURITES',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      color: showFavourites
                          ? const Color(0xFF001730)
                          : Colors.black.withOpacity(0.4),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 330,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: GestureDetector(
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
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
                child: Image.asset(
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