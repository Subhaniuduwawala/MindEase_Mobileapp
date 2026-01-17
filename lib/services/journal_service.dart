import '../models/journal_entry.dart';
class JournalService {
  final List<JournalEntry> _entries = [];
  void saveEntry(JournalEntry entry) {
    _entries.add(entry);
    print('Saved journal entry: ${entry.title}');
  }
  List<JournalEntry> loadAll() => List.unmodifiable(_entries);
}