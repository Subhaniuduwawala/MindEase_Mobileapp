class MoodEntry {
  int moodLevel;
  String emoji;
  DateTime date;
  MoodEntry({required this.moodLevel, required this.emoji, DateTime? date}) : date = date ?? DateTime.now();
  @override
  String toString() => 'MoodEntry(level: $moodLevel, emoji: $emoji, date: $date)';
}