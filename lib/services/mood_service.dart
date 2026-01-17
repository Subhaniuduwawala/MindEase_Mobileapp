import '../models/mood_entry.dart';
class MoodService {
  final List<MoodEntry> _moods = [];
  void saveMood(MoodEntry mood) {
    _moods.add(mood);
    print('Saved mood: ${mood.moodLevel} ${mood.emoji}');
  }
  List<MoodEntry> loadAll() => List.unmodifiable(_moods);
}