class Affirmation {
  String text;
  DateTime date;
  Affirmation({required this.text, DateTime? date}) : date = date ?? DateTime.now();
  @override
  String toString() => 'Affirmation(text: $text, date: $date)';
}