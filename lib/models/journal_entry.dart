class JournalEntry {
  String title;
  String content;
  DateTime date;

  // Added for journal features
  String mood;
  int intensity;

  JournalEntry({
    required this.title,
    required this.content,
    this.mood = '😌 Calm',
    this.intensity = 3,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  @override
  String toString() {
    return 'JournalEntry(title: $title, mood: $mood, intensity: $intensity, date: $date)';
  }
}
