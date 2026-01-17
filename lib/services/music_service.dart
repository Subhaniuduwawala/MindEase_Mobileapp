import '../models/music_track.dart';
class MusicService {
  final List<MusicTrack> _tracks = [
    MusicTrack(title: 'Calm Waves', duration: Duration(minutes: 3, seconds: 20)),
    MusicTrack(title: 'Gentle Breeze', duration: Duration(minutes: 4)),
  ];
  List<MusicTrack> getAvailableTracks() => List.unmodifiable(_tracks);
  void playTrack(MusicTrack track) {
    print('Playing: ${track.title}');
  }
}