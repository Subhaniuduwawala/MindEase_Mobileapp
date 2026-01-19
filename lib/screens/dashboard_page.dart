import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/settings_page.dart';
import '../screens/user_settings_page.dart';
import '../screens/stats_page.dart';
import '../screens/achievements_page.dart';
import '../screens/home_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _userName = 'User';
  int _currentStreak = 7;
  String _dailyAffirmation = 'You are capable of amazing things';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'User';
      _currentStreak = prefs.getInt('current_streak') ?? 7;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildHeroAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStreakCard(),
                  const SizedBox(height: 30),

                  _sectionTitle("How MindWell Works"),
                  _buildHowItWorks(),

                  const SizedBox(height: 30),
                  _sectionTitle("Daily Affirmation"),
                  _buildAffirmationCard(),

                  const SizedBox(height: 30),
                  _sectionTitle("Quick Actions"),
                  _buildQuickActionsWithImages(),

                  const SizedBox(height: 30),
                  _sectionTitle("Your Wellness"),
                  _buildWellnessRow(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 HERO APP BAR
  Widget _buildHeroAppBar() {
    return SliverAppBar(
      expandedHeight: 380,
      pinned: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.person_outline),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UserSettingsPage()),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettingsPage()),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/image9.jpg', fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.teal.withOpacity(0.8),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Feel Heard, Heal Better",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Welcome back, $_userName",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 SECTION TITLE
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  // 🔹 HOW IT WORKS (LIKE YOUR IMAGE)
  Widget _buildHowItWorks() {
    return Column(
      children: [
        _infoStep(
          "Step 1: Check in Yourself",
          "Understand your emotions",
          'assets/image11.jpg',
        ),
        _infoStep(
          "Step 2: Chat with Support",
          "Get guided help anytime",
          'assets/image12.jpg',
        ),
        _infoStep(
          "Step 3: Track Your Growth",
          "See progress over time",
          'assets/image13.jpg',
        ),
      ],
    );
  }

  Widget _infoStep(String title, String subtitle, String image) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                image,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 STREAK CARD
  Widget _buildStreakCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.orange, Colors.deepOrange],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_fire_department,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(width: 16),
          Text(
            "$_currentStreak Day Streak",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 AFFIRMATION
  Widget _buildAffirmationCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(
              'assets/image10.jpg',
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _dailyAffirmation,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 QUICK ACTIONS
  Widget _buildQuickActionsWithImages() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1,
      children: [
        _imageActionCard(
          title: "Affirmations",
          icon: Icons.format_quote,
          image: "assets/image1.jpg",
          onTap: () => _navigateToTab(0),
        ),
        _imageActionCard(
          title: "Relax Music",
          icon: Icons.headphones,
          image: "assets/image2.jpg",
          onTap: () => _navigateToTab(1),
        ),
        _imageActionCard(
          title: "Journal",
          icon: Icons.menu_book,
          image: "assets/image3.jpg",
          onTap: () => _navigateToTab(2),
        ),
        _imageActionCard(
          title: "Track Mood",
          icon: Icons.mood,
          image: "assets/image4.jpg",
          onTap: () => _navigateToTab(3),
        ),
      ],
    );
  }

  Widget _imageActionCard({
    required String title,
    required IconData icon,
    required String image,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(image, fit: BoxFit.cover),

            // Dark overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.25),
                    Colors.black.withOpacity(0.65),
                  ],
                ),
              ),
            ),

            // Content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 36, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 WELLNESS
  Widget _buildWellnessRow() {
    return Row(
      children: [
        Expanded(
          child: _wellnessTile("Stats", Icons.bar_chart, const StatsPage()),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _wellnessTile(
            "Achievements",
            Icons.emoji_events,
            const AchievementsPage(),
          ),
        ),
      ],
    );
  }

  Widget _wellnessTile(String title, IconData icon, Widget page) {
    return InkWell(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icon, size: 36, color: Colors.teal),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToTab(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomePage(initialTab: index)),
    );
  }
}
