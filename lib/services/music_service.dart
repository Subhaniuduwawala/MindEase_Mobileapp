import 'package:audioplayers/audioplayers.dart';
import '../models/music_track.dart';

class MusicService {
  MusicTrack? _currentlyPlayingTrack;

  final List<MusicTrack> _tracks = [
    MusicTrack(
      title: 'Relaxing Meditation',
      duration: Duration(minutes: 3, seconds: 20),
      audioPath: 'audio1.mp3',
    ),
    MusicTrack(
      title: 'Peaceful Sleep',
      duration: Duration(minutes: 4),
      audioPath: 'audio2.mp3',
    ),
  ];

  List<MusicTrack> getAvailableTracks() => List.unmodifiable(_tracks);

  Future<void> playTrack(MusicTrack track) async {
    try {
      // If a different track is currently playing, pause it first
      if (_currentlyPlayingTrack != null &&
          _currentlyPlayingTrack?.title != track.title) {
        await _currentlyPlayingTrack?.audioPlayer.pause();
        print('Paused: ${_currentlyPlayingTrack?.title}');
      }

      final state = await track.audioPlayer.state;
      if (state == PlayerState.playing) {
        // If the track is playing, pause it
        await track.audioPlayer.pause();
        print('Paused: ${track.title}');
        _currentlyPlayingTrack = null;
      } else if (state == PlayerState.paused) {
        // If paused, resume it
        await track.audioPlayer.resume();
        print('Resumed: ${track.title}');
        _currentlyPlayingTrack = track;
      } else {
        // Play new track
        await track.audioPlayer.play(AssetSource('audio/${track.audioPath}'));
        print('Playing: ${track.title}');
        _currentlyPlayingTrack = track;
      }
    } catch (e) {
      print('Error playing track: $e');
    }
  }

  Future<void> stopTrack(MusicTrack track) async {
    try {
      await track.audioPlayer.stop();
      if (_currentlyPlayingTrack?.title == track.title) {
        _currentlyPlayingTrack = null;
      }
      print('Music stopped');
    } catch (e) {
      print('Error stopping track: $e');
    }
  }

  Future<void> seek(MusicTrack track, Duration duration) async {
    try {
      await track.audioPlayer.seek(duration);
    } catch (e) {
      print('Error seeking: $e');
    }
  }

  MusicTrack? get currentlyPlayingTrack => _currentlyPlayingTrack;

  void dispose() {
    for (var track in _tracks) {
      track.audioPlayer.dispose();
    }
  }
}
