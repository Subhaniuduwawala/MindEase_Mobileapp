import 'package:audioplayers/audioplayers.dart';
import '../models/music_track.dart';

class MusicService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  MusicTrack? _currentTrack;
  bool _isPlaying = false;

  final List<MusicTrack> _tracks = [
    MusicTrack(
      title: 'Calm Waves 🌊',
      duration: Duration(minutes: 3, seconds: 20),
      assetPath: 'audio/audio1.mp3',
      imagePath: 'assets/image17.jpg',
      mood: 'Calm',
    ),
    MusicTrack(
      title: 'Gentle Breeze 🍃',
      duration: Duration(minutes: 4),
      assetPath: 'audio/audio2.mp3',
      imagePath: 'assets/image18.jpg',
      mood: 'Nature',
    ),
    MusicTrack(
      title: 'Deep Focus 🎧',
      duration: Duration(minutes: 5),
      assetPath: 'audio/audio3.mp3',
      imagePath: 'assets/image19.jpg',
      mood: 'Focus',
    ),
    MusicTrack(
      title: 'Calming 🌙',
      duration: Duration(minutes: 5),
      assetPath: 'audio/audio4.mp3',
      imagePath: 'assets/image20.jpg',
      mood: 'Focus',
    ),
    MusicTrack(
      title: 'Freedom ✨',
      duration: Duration(minutes: 5),
      assetPath: 'audio/audio5.mp3',
      imagePath: 'assets/image21.jpg',
      mood: 'Nature',
    ),
  ];

  List<MusicTrack> getAvailableTracks() => List.unmodifiable(_tracks);

  MusicTrack? get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;

  Future<void> playTrack(MusicTrack track) async {
    if (_currentTrack == track && _isPlaying) {
      await pause();
    } else {
      await _audioPlayer.play(AssetSource(track.assetPath));
      _currentTrack = track;
      _isPlaying = true;
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    _currentTrack = null;
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
