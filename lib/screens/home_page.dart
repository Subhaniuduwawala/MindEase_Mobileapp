import 'package:flutter/material.dart';
import '../services/affirmation_service.dart';
import '../services/music_service.dart';
import '../services/journal_service.dart';
import '../services/mood_service.dart';
import '../widgets/mood_view.dart';
import '../screens/profile_page.dart';
import '../screens/settings_page.dart';
import '../screens/stats_page.dart';
import '../screens/achievements_page.dart';
import '../screens/dashboard_page.dart';
import '../models/affirmation.dart';
import '../models/journal_entry.dart';

class HomePage extends StatefulWidget {
  final int initialTab;
  const HomePage({super.key, this.initialTab = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isDark = false;
  String _musicMood = 'All';

  final AffirmationService _affirmationService = AffirmationService();
  final MusicService _musicService = MusicService();
  final JournalService _journalService = JournalService();
  final MoodService _moodService = MoodService();

  late int _selectedIndex;
  late Affirmation _currentAffirmation;
  String _selectedMood = 'All';

  //  Background animation
  int _bgIndex = 0;
  final List<String> _bgImages = [
    'assets/image21.jpg',
    'assets/image20.jpg',
    'assets/image19.jpg',
  ];

  // ================= JOURNAL STATE =================
  final TextEditingController _journalCtrl = TextEditingController();
  String _journalMood = '😌 Calm';
  double _journalIntensity = 3;

  final List<String> _journalMoods = [
    '😄 Happy',
    '😌 Calm',
    '😔 Sad',
    '😡 Angry',
    '😴 Tired',
  ];
  // =================================================

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab;
    _currentAffirmation = _affirmationService.getDailyAffirmation();

    // Loop background every 6 seconds
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 6));
      if (!mounted) return false;
      setState(() {
        _bgIndex = (_bgIndex + 1) % _bgImages.length;
      });
      return true;
    });
  }

  void _onTab(int index) => setState(() => _selectedIndex = index);

  void _getNewAffirmation() {
    setState(() {
      if (_selectedMood == 'All') {
        _currentAffirmation = _affirmationService.getRandomAffirmation();
      } else {
        _currentAffirmation = _affirmationService.getAffirmationByMood(
          _selectedMood,
        );
      }
    });
  }

  void _saveAffirmation() {
    _affirmationService.saveAffirmation(_currentAffirmation);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Affirmation saved to your profile')),
    );
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
          leading: IconButton(
            icon: const Icon(Icons.dashboard_rounded),
            tooltip: 'Dashboard',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DashboardPage()),
              );
            },
          ),
          title: const Text(
            'MindEase',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_rounded),
              tooltip: 'Profile',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
            ),
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

  // ================= BODY =================

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _affirmationPage(); // ORIGINAL
      case 1:
        return _musicPage(); // ENHANCED
      case 2:
        return _journalPage();
      case 3:
        return MoodView(moodService: _moodService);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _journalPage() {
    final entries = _journalService.loadAll().reversed.toList();

    return Stack(
      children: [
        // 🌄 Animated Background
        AnimatedSwitcher(
          duration: const Duration(seconds: 2),
          child: Container(
            key: ValueKey(_bgIndex),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(_bgImages[_bgIndex]),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        // Dark overlay for readability
        Container(color: Colors.black.withOpacity(0.35)),

        // 🌿 Journal Content
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Your Journal',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Mood Chips
              Wrap(
                spacing: 8,
                children: _journalMoods.map((m) {
                  return ChoiceChip(
                    label: Text(m),
                    selected: _journalMood == m,
                    selectedColor: Colors.teal,
                    onSelected: (_) => setState(() => _journalMood = m),
                  );
                }).toList(),
              ),

              const SizedBox(height: 12),
              Text(
                'Intensity: ${_journalIntensity.toInt()}',
                style: const TextStyle(color: Colors.white),
              ),

              Slider(
                value: _journalIntensity,
                min: 0,
                max: 5,
                divisions: 5,
                onChanged: (v) => setState(() => _journalIntensity = v),
              ),

              // ✨ Glass Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _journalCtrl,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Write your thoughts peacefully...',
                        border: InputBorder.none,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: _saveJournalEntry,
                        icon: const Icon(Icons.check),
                        label: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Previous Entries',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              ...entries.map(
                (e) => Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.book),
                    title: Text(e.title),
                    subtitle: Text(
                      e.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      '${e.date.day}/${e.date.month}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _saveJournalEntry() {
    if (_journalCtrl.text.trim().isEmpty) return;

    _journalService.saveEntry(
      JournalEntry(title: _journalMood, content: _journalCtrl.text),
    );

    _journalCtrl.clear();
    setState(() {});
  }

  // ================= ORIGINAL AFFIRMATION PAGE (UNCHANGED) =================

  Widget _affirmationPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              _currentAffirmation.image,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _currentAffirmation.text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              '${_currentAffirmation.category} • ${_currentAffirmation.author}',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _getNewAffirmation,
                icon: const Icon(Icons.refresh),
                label: const Text('New'),
              ),
              ElevatedButton.icon(
                onPressed: _saveAffirmation,
                icon: const Icon(Icons.favorite_border),
                label: const Text('Save'),
              ),
            ],
          ),
          const SizedBox(height: 35),
          const Text(
            'How are you feeling today?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            children: [
              _moodChip('All'),
              _moodChip('Mindfulness'),
              _moodChip('Strength'),
              _moodChip('Growth'),
              _moodChip('Patience'),
            ],
          ),
          const SizedBox(height: 35),
          const Text(
            'Daily Motivation',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _motivationTile(
            Icons.self_improvement,
            'Take 3 deep breaths and relax',
          ),
          _motivationTile(Icons.nature_people, 'Spend 5 minutes outside'),
          _motivationTile(Icons.edit_note, 'Write one positive thought'),
        ],
      ),
    );
  }

  // ================= MUSIC PAGE =================

  Widget _musicPage() {
    final allTracks = _musicService.getAvailableTracks();
    final tracks = _musicMood == 'All'
        ? allTracks
        : allTracks.where((t) => t.mood == _musicMood).toList();

    return Stack(
      children: [
        Column(
          children: [
            _musicMoodChips(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: tracks.length,
                itemBuilder: (context, i) {
                  final t = tracks[i];
                  final isPlaying =
                      _musicService.currentTrack == t &&
                      _musicService.isPlaying;

                  return Container(
                    height: 160,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(t.imagePath),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        t.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${t.mood} • ${t.duration.inMinutes} min',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: IconButton(
                        iconSize: 42,
                        icon: Icon(
                          isPlaying ? Icons.pause_circle : Icons.play_circle,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          await _musicService.playTrack(t);
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        if (_musicService.currentTrack != null) _miniMusicPlayer(),
      ],
    );
  }

  Widget _musicMoodChips() {
    final moods = ['All', 'Calm', 'Focus', 'Nature'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: moods.map((mood) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(mood),
              selected: _musicMood == mood,
              onSelected: (_) => setState(() => _musicMood = mood),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _miniMusicPlayer() {
    final track = _musicService.currentTrack!;
    final isPlaying = _musicService.isPlaying;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                track.imagePath,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                track.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () async {
                await _musicService.playTrack(track);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _moodChip(String mood) {
    return ChoiceChip(
      label: Text(mood),
      selected: _selectedMood == mood,
      onSelected: (_) {
        setState(() {
          _selectedMood = mood;
          _getNewAffirmation();
        });
      },
    );
  }

  Widget _motivationTile(IconData icon, String text) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(leading: Icon(icon, size: 30), title: Text(text)),
    );
  }
}
