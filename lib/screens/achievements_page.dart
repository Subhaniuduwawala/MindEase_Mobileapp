import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int requirement;
  bool isUnlocked;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.requirement,
    this.isUnlocked = false,
  });
}

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  late List<Achievement> _achievements;
  int _unlockedCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeAchievements();
    _loadAchievements();
  }

  void _initializeAchievements() {
    _achievements = [
      Achievement(
        id: 'first_day',
        title: 'First Step',
        description: 'Complete your first day',
        icon: Icons.star,
        color: Colors.amber,
        requirement: 1,
      ),
      Achievement(
        id: 'week_streak',
        title: 'Week Warrior',
        description: '7 day streak',
        icon: Icons.local_fire_department,
        color: Colors.orange,
        requirement: 7,
      ),
      Achievement(
        id: 'month_streak',
        title: 'Monthly Master',
        description: '30 day streak',
        icon: Icons.emoji_events,
        color: Colors.deepOrange,
        requirement: 30,
      ),
      Achievement(
        id: 'first_journal',
        title: 'Writer\'s Beginning',
        description: 'Write your first journal entry',
        icon: Icons.book,
        color: Colors.blue,
        requirement: 1,
      ),
      Achievement(
        id: 'ten_journals',
        title: 'Prolific Writer',
        description: 'Write 10 journal entries',
        icon: Icons.menu_book,
        color: Colors.indigo,
        requirement: 10,
      ),
      Achievement(
        id: 'first_mood',
        title: 'Mood Tracker',
        description: 'Track your first mood',
        icon: Icons.mood,
        color: Colors.pink,
        requirement: 1,
      ),
      Achievement(
        id: 'mood_week',
        title: 'Consistent Tracker',
        description: 'Track mood for 7 days straight',
        icon: Icons.sentiment_satisfied_alt,
        color: Colors.purple,
        requirement: 7,
      ),
      Achievement(
        id: 'music_listener',
        title: 'Music Lover',
        description: 'Listen to 5 relaxation tracks',
        icon: Icons.headphones,
        color: Colors.teal,
        requirement: 5,
      ),
      Achievement(
        id: 'affirmation_reader',
        title: 'Positivity Seeker',
        description: 'Read 10 affirmations',
        icon: Icons.format_quote,
        color: Colors.green,
        requirement: 10,
      ),
      Achievement(
        id: 'early_bird',
        title: 'Early Bird',
        description: 'Use app before 7 AM',
        icon: Icons.wb_sunny,
        color: Colors.yellow,
        requirement: 1,
      ),
      Achievement(
        id: 'night_owl',
        title: 'Night Owl',
        description: 'Use app after 10 PM',
        icon: Icons.nightlight,
        color: Colors.blueGrey,
        requirement: 1,
      ),
      Achievement(
        id: 'perfectionist',
        title: 'Perfectionist',
        description: 'Use all 4 features in one day',
        icon: Icons.check_circle,
        color: Colors.red,
        requirement: 1,
      ),
    ];
  }

  Future<void> _loadAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var achievement in _achievements) {
        achievement.isUnlocked =
            prefs.getBool('achievement_${achievement.id}') ?? false;
      }
      _unlockedCount = _achievements.where((a) => a.isUnlocked).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Achievements'), centerTitle: true),
      body: Column(
        children: [
          // Progress Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.tealAccent.withOpacity(0.1)
                  : Colors.teal.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Achievements Unlocked',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  '$_unlockedCount / ${_achievements.length}',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.tealAccent : Colors.teal,
                  ),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: _unlockedCount / _achievements.length,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation(
                    isDark ? Colors.tealAccent : Colors.teal,
                  ),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),

          // Achievements Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: _achievements.length,
              itemBuilder: (context, index) {
                final achievement = _achievements[index];
                return _buildAchievementCard(achievement);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    return Card(
      elevation: achievement.isUnlocked ? 4 : 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showAchievementDialog(achievement),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: achievement.isUnlocked
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      achievement.color.withOpacity(0.2),
                      achievement.color.withOpacity(0.1),
                    ],
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: achievement.isUnlocked
                      ? achievement.color.withOpacity(0.2)
                      : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  achievement.icon,
                  size: 40,
                  color: achievement.isUnlocked
                      ? achievement.color
                      : Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                achievement.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: achievement.isUnlocked ? null : Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                achievement.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: achievement.isUnlocked
                      ? Colors.grey[600]
                      : Colors.grey[400],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (!achievement.isUnlocked) ...[
                const SizedBox(height: 8),
                const Icon(Icons.lock, size: 16, color: Colors.grey),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showAchievementDialog(Achievement achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: achievement.color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(achievement.icon, size: 60, color: achievement.color),
            ),
            const SizedBox(height: 16),
            Text(
              achievement.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              achievement.description,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (achievement.isUnlocked)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Unlocked!',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock, color: Colors.grey, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Locked',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
