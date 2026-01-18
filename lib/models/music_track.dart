import 'package:audioplayers/audioplayers.dart';

class MusicTrack {
  String title;
  Duration duration;
  String audioPath;
  late final AudioPlayer audioPlayer = AudioPlayer();

  MusicTrack({
    required this.title,
    required this.duration,
    required this.audioPath,
  });

  @override
  String toString() =>
      'MusicTrack(title: $title, duration: $duration, audioPath: $audioPath)';
}
