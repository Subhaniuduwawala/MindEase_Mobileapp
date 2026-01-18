import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
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
import '../screens/dashboard_page.dart';

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

  @override
  void dispose() {
    _musicService.dispose();
    super.dispose();
  }

  void _onTab(int index) {
    if (index == 0) {
      // Home tab - navigate to DashboardPage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } else {
      setState(() => _selectedIndex = index - 1);
    }
  }

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
          currentIndex: _selectedIndex + 1,
          onTap: _onTab,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.headphones,
                          size: 28,
                          color: Colors.teal,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                t.duration.toString().split('.').first,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        StreamBuilder<PlayerState>(
                          stream: t.audioPlayer.onPlayerStateChanged,
                          builder: (context, snapshot) {
                            final isPlaying =
                                snapshot.data == PlayerState.playing;
                            return IconButton(
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.teal,
                              ),
                              onPressed: () async {
                                await _musicService.playTrack(t);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    StreamBuilder<PlayerState>(
                      stream: t.audioPlayer.onPlayerStateChanged,
                      builder: (context, stateSnapshot) {
                        final isPlaying =
                            stateSnapshot.data == PlayerState.playing ||
                            stateSnapshot.data == PlayerState.paused;
                        if (!isPlaying) return const SizedBox.shrink();
                        return Column(
                          children: [
                            const SizedBox(height: 12),
                            StreamBuilder<Duration>(
                              stream: t.audioPlayer.onPositionChanged,
                              builder: (context, posSnapshot) {
                                final position =
                                    posSnapshot.data ?? Duration.zero;
                                return Column(
                                  children: [
                                    Slider(
                                      value: position.inSeconds.toDouble(),
                                      max: t.duration.inSeconds.toDouble(),
                                      onChanged: (value) async {
                                        await _musicService.seek(
                                          t,
                                          Duration(seconds: value.toInt()),
                                        );
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            position
                                                .toString()
                                                .split('.')
                                                .first,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            t.duration
                                                .toString()
                                                .split('.')
                                                .first,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
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
