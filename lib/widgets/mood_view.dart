import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../services/mood_service.dart';

class MoodView extends StatefulWidget {
  final MoodService moodService;
  const MoodView({super.key, required this.moodService});
  @override
  State<MoodView> createState() => _MoodViewState();
}

class _MoodViewState extends State<MoodView> {
  double _level = 5;
  final _emojiMap = [
    '😞',
    '😕',
    '😐',
    '🙂',
    '😊',
    '😄',
    '🥳',
    '🤩',
    '❤️',
    '🌟',
  ];

  @override
  Widget build(BuildContext context) {
    final moods = widget.moodService.loadAll();
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          const Text(
            'How are you feeling today?',
            style: TextStyle(fontSize: 18),
          ),
          Slider(
            value: _level,
            min: 0,
            max: 10,
            divisions: 10,
            label: _level.round().toString(),
            onChanged: (v) => setState(() => _level = v),
          ),
          Text(
            _emojiMap[_level.clamp(0, 9).round()],
            style: const TextStyle(fontSize: 48),
          ),
          ElevatedButton(
            onPressed: () {
              final idx = _level.clamp(0, 9).round();
              final emoji = _emojiMap[idx];
              widget.moodService.saveMood(
                MoodEntry(moodLevel: _level.round(), emoji: emoji),
              );
              setState(() {});
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Mood saved!')));
            },
            child: const Text('Save Mood'),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: moods.length,
              itemBuilder: (c, i) {
                final m = moods[i];
                return ListTile(
                  title: Text('${m.moodLevel} ${m.emoji}'),
                  subtitle: Text('${m.date}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
