import 'package:shared_preferences/shared_preferences.dart';

class SavedAffirmationService {
  static const String _key = 'saved_affirmations';

  Future<void> saveAffirmation(String text) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_key) ?? [];

    if (!saved.contains(text)) {
      saved.add(text);
      await prefs.setStringList(_key, saved);
    }
  }

  Future<List<String>> getSavedAffirmations() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }
}
