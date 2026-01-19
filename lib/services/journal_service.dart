import '../models/journal_entry.dart';

class JournalService {
  final List<JournalEntry> _entries = [];

  void saveEntry(JournalEntry entry) {
    _entries.add(entry);
  }

  List<JournalEntry> loadAll() {
    return List.unmodifiable(_entries);
  }

  int get totalEntries => _entries.length;

  double get averageMood {
    if (_entries.isEmpty) return 0;
    final sum = _entries.map((e) => e.intensity).reduce((a, b) => a + b);
    return sum / _entries.length;
  }
}
