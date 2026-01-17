import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../services/journal_service.dart';

class JournalView extends StatefulWidget {
  final JournalService journalService;
  const JournalView({super.key, required this.journalService});
  @override
  State<JournalView> createState() => _JournalViewState();
}

class _JournalViewState extends State<JournalView> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entries = widget.journalService.loadAll();
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          TextField(
            controller: _titleCtrl,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TextField(
              controller: _contentCtrl,
              maxLines: null,
              expands: true,
              decoration: const InputDecoration(
                labelText: 'Write your thoughts',
              ),
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  final title = _titleCtrl.text.trim();
                  final content = _contentCtrl.text.trim();
                  if (title.isEmpty && content.isEmpty) return;
                  widget.journalService.saveEntry(
                    JournalEntry(
                      title: title.isEmpty ? 'Untitled' : title,
                      content: content,
                    ),
                  );
                  _titleCtrl.clear();
                  _contentCtrl.clear();
                  setState(() {});
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Saved entry')));
                },
                child: const Text('Save'),
              ),
              const SizedBox(width: 12),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, i) {
                final e = entries[i];
                return ListTile(
                  title: Text(e.title),
                  subtitle: Text('${e.date}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
