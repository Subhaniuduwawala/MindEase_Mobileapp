class MusicTrack {
  String title;
  Duration duration;
  String assetPath;
  String imagePath;
  String mood;

  MusicTrack({
    required this.title,
    required this.duration,
    required this.assetPath,
    required this.imagePath,
    required this.mood,
  });

  @override
  String toString() => 'MusicTrack(title: $title, duration: $duration)';
}
