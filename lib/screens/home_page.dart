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

  final _affirmationService = AffirmationService();
  final _musicService = MusicService();
  final _journalService = JournalService();
  final _moodService = MoodService();

  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab;
  }

  void _onTab(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: ThemeData(
        useMaterial3: true,
        brightness: _isDark ? Brightness.dark : Brightness.light,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: _isDark
            ? const Color(0xFF121212)
            : const Color(0xFFF6F7FB),
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'MindEase',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          actions: [
            IconButton(
              icon: Icon(_isDark ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => setState(() => _isDark = !_isDark),
            ),
          ],
        ),
        drawer: _buildDrawer(theme),
        body: _buildBody(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTab,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.format_quote_rounded),
              label: 'Affirm',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note_rounded),
              label: 'Music',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: 'Journal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sentiment_satisfied_alt),
              label: 'Mood',
            ),
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer(ThemeData theme) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.spa, size: 32),
                ),
                SizedBox(height: 12),
                Text(
                  'Welcome to MindEase',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Your mental wellness companion',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          _drawerItem(Icons.person, 'Profile', const ProfilePage()),
          _drawerItem(Icons.bar_chart, 'Stats & Analytics', const StatsPage()),
          _drawerItem(
            Icons.emoji_events,
            'Achievements',
            const AchievementsPage(),
          ),
          _drawerItem(Icons.settings, 'Settings', const SettingsPage()),
        ],
      ),
    );
  }

  ListTile _drawerItem(IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        final a = _affirmationService.getDailyAffirmation();
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.spa, size: 48, color: Colors.teal),
                    const SizedBox(height: 24),
                    Text(
                      a.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${a.date.toLocal()}'.split(' ')[0],
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => setState(() {}),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

      case 1:
        final tracks = _musicService.getAvailableTracks();
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: tracks.length,
          itemBuilder: (context, i) {
            final t = tracks[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const Icon(Icons.headphones),
                title: Text(t.title),
                subtitle: Text(t.duration.toString()),
                trailing: IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () => _musicService.playTrack(t),
                ),
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
