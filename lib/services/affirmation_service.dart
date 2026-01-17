import '../models/affirmation.dart';
class AffirmationService {
  final List<Affirmation> _affirmations = [
    Affirmation(text: 'You are capable of amazing things.'),
    Affirmation(text: 'Breathe in calm, breathe out stress.'),
    Affirmation(text: 'Small steps every day.'),
  ];
  Affirmation getDailyAffirmation() {
    final idx = DateTime.now().day % _affirmations.length;
    return _affirmations[idx];
  }
}