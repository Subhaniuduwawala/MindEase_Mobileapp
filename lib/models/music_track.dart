class MusicTrack {
  String title;
  Duration duration;
  MusicTrack({required this.title, required this.duration});
  @override
  String toString() => 'MusicTrack(title: $title, duration: $duration)';
}