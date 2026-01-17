class JournalEntry {
  String title;
  String content;
  DateTime date;
  JournalEntry({required this.title, required this.content, DateTime? date}) : date = date ?? DateTime.now();
  @override
  String toString() => 'JournalEntry(title: $title, date: $date)';
}