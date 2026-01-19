import '../models/affirmation.dart';

class AffirmationService {
  final List<Affirmation> _affirmations = [
    Affirmation(
      text: 'Good things come with great patience.',
      category: 'Patience',
      author: 'MindEase',
      image: 'assets/image8.jpg',
      date: DateTime.now(),
    ),
    Affirmation(
      text: 'Breathe in calm, breathe out stress.',
      category: 'Mindfulness',
      author: 'MindEase',
      image: 'assets/image9.jpg',
      date: DateTime.now(),
    ),
    Affirmation(
      text: 'You are stronger than your struggles.',
      category: 'Strength',
      author: 'MindEase',
      image: 'assets/image10.jpg',
      date: DateTime.now(),
    ),
    Affirmation(
      text: 'Small steps every day lead to big changes.',
      category: 'Growth',
      author: 'MindEase',
      image: 'assets/image16.jpg',
      date: DateTime.now(),
    ),
  ];

  final List<Affirmation> _savedAffirmations = [];

  Affirmation getDailyAffirmation() {
    final index = DateTime.now().day % _affirmations.length;
    return _affirmations[index];
  }

  Affirmation getRandomAffirmation() {
    _affirmations.shuffle();
    return _affirmations.first;
  }

  Affirmation getAffirmationByMood(String mood) {
    final matches = _affirmations.where((a) => a.category == mood).toList();
    matches.shuffle();
    return matches.isNotEmpty ? matches.first : getRandomAffirmation();
  }

  void saveAffirmation(Affirmation affirmation) {
    if (!_savedAffirmations.contains(affirmation)) {
      _savedAffirmations.add(affirmation);
    }
  }

  List<Affirmation> getSavedAffirmations() {
    return _savedAffirmations;
  }
}
