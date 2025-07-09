import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showFavourites = false;

  final List<Map<String, dynamic>> allJobs = [
    {
      'title': 'BAKER',
      'description':
      'Prepare Fresh Bread, Pastries, And Other Baked Goods. Creativity And Precision Make Every Product Special.',
      'type': 'Full-Time Or Shifts',
      'salary': '1000–1500€',
      'image': 'assets/images/baker.png',
      'isFavourite': true,
    },
    {
      'title': 'TAXI DRIVER',
      'description': 'Transport Passengers Comfortably To Their Destinations.',
      'type': 'Self-Managed',
      'salary': '1000–1300€',
      'image': 'assets/images/taxi.png',
      'isFavourite': false,
    },
    {
      'title': 'KITCHEN ASSISTANT',
      'description':
      'Support The Kitchen Team With Prep Work And Maintaining A Clean Workspace. Assist With Basic Cooking Tasks.',
      'type': 'Shift-Based',
      'salary': '700–1350€',
      'image': 'assets/images/assistant.png',
      'isFavourite': true,
    },
  ];

  final List<Map<String, dynamic>> favouriteJobs = [];

  void toggleFavourite(Map<String, dynamic> job) {
    setState(() {
      job['isFavourite'] = !(job['isFavourite'] ?? false);

      if (job['isFavourite']) {
        if (!favouriteJobs.contains(job)) {
          favouriteJobs.add(job);
        }
      } else {
        favouriteJobs.remove(job);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final jobs = showFavourites ? favouriteJobs : allJobs;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        color: const Color(0xFF001730),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _NavItem(icon: Icons.home, label: 'Home'),
            _NavItem(icon: Icons.info, label: 'About Us'),
            _NavItem(icon: Icons.call, label: 'Contact'),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Image.asset('assets/images/headerLogo.png', height: 40),
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.menu),
                      color: Color(0xFF545D68),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'VACANCY LIST',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 100),
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
                      fontWeight: FontWeight.w500,
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
                      fontWeight: FontWeight.w500,
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
                    child: _JobCard(
                      job: job,
                      onToggleFavourite: () => toggleFavourite(job),
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
  final VoidCallback onToggleFavourite;

  const _JobCard({required this.job, required this.onToggleFavourite});

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
                  job['image'],
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
                    color: job['isFavourite'] ? Colors.amber : Colors.white,
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
                Text(
                  job['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  job['description'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'Roboto',
                    height: 1.3,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  job['type'],
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                    fontSize: 13,
                    fontFamily: 'Roboto',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  job['salary'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    color: Colors.white,
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

  const _NavItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}