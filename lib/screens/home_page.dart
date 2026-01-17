import 'package:flutter/material.dart';
import '../services/affirmation_service.dart';
import '../services/music_service.dart';
import '../services/journal_service.dart';
import '../services/mood_service.dart';
import '../widgets/journal_view.dart';
import '../widgets/mood_view.dart';
import '../screens/profile_page.dart';
import '../screens/settings_page.dart';
import '../screens/stats_page.dart';
import '../screens/achievements_page.dart';

class HomePage extends StatefulWidget {
  final int initialTab;
  const HomePage({super.key, this.initialTab = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isDark = false;

  final AffirmationService _affirmationService = AffirmationService();
  final MusicService _musicService = MusicService();
  final JournalService _journalService = JournalService();
  final MoodService _moodService = MoodService();

  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab;
  }

  void _onTab(int idx) => setState(() => _selectedIndex = idx);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindEase',
      theme: _isDark ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MindEase'),
          actions: [
            IconButton(
              icon: Icon(_isDark ? Icons.wb_sunny : Icons.nightlight_round),
              onPressed: () => setState(() => _isDark = !_isDark),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: _isDark ? Colors.tealAccent : Colors.teal,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 32,
                        color: _isDark ? Colors.tealAccent : Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Welcome to MindEase',
                      style: TextStyle(
                        color: _isDark ? Colors.black : Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.bar_chart),
                title: const Text('Stats & Analytics'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const StatsPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.emoji_events),
                title: const Text('Achievements'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AchievementsPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About'),
                onTap: () {
                  Navigator.pop(context);
                  showAboutDialog(
                    context: context,
                    applicationName: 'MindEase',
                    applicationVersion: '1.0.0',
                    applicationIcon: Icon(
                      Icons.spa,
                      size: 48,
                      color: _isDark ? Colors.tealAccent : Colors.teal,
                    ),
                    children: const [
                      Text('Your Mental Wellness Companion'),
                      SizedBox(height: 8),
                      Text('© 2025 MindEase. All rights reserved.'),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        body: _buildBody(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTab,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.format_quote),
              label: 'Affirm',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              label: 'Music',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
            BottomNavigationBarItem(icon: Icon(Icons.mood), label: 'Mood'),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        final a = _affirmationService.getDailyAffirmation();
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('✨', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 24),
                Text(
                  a.text,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  '${a.date.toLocal()}'.split(' ')[0],
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () => setState(() {}),
                  icon: const Icon(Icons.refresh),
                  label: const Text('New Affirmation'),
                ),
              ],
            ),
          ),
        );

      case 1:
        final tracks = _musicService.getAvailableTracks();
        return ListView.builder(
          itemCount: tracks.length,
          itemBuilder: (context, i) {
            final t = tracks[i];
            return ListTile(
              leading: const Icon(Icons.library_music),
              title: Text(t.title),
              subtitle: Text(t.duration.toString()),
              trailing: IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () {
                  _musicService.playTrack(t);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Playing ${t.title}')));
                },
              ),
            );
          },
        );

      case 2:
        return JournalView(journalService: _journalService);

      case 3:
        return MoodView(moodService: _moodService);

      default:
        return const SizedBox.shrink();
    }
  }
}
