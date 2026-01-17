import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _dailyReminders = true;
  bool _soundEffects = true;
  bool _vibration = false;
  String _reminderTime = '9:00 AM';
  String _theme = 'System';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _dailyReminders = prefs.getBool('daily_reminders') ?? true;
      _soundEffects = prefs.getBool('sound_effects') ?? true;
      _vibration = prefs.getBool('vibration') ?? false;
      _reminderTime = prefs.getString('reminder_time') ?? '9:00 AM';
      _theme = prefs.getString('theme') ?? 'System';
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
        children: [
          // Notifications Section
          _buildSectionHeader('Notifications'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text('Enable Notifications'),
            subtitle: const Text('Receive wellness reminders'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
              _saveSetting('notifications', value);
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.alarm),
            title: const Text('Daily Reminders'),
            subtitle: const Text('Get reminded to check in'),
            value: _dailyReminders,
            onChanged: _notificationsEnabled
                ? (value) {
                    setState(() => _dailyReminders = value);
                    _saveSetting('daily_reminders', value);
                  }
                : null,
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Reminder Time'),
            subtitle: Text(_reminderTime),
            trailing: const Icon(Icons.chevron_right),
            enabled: _notificationsEnabled && _dailyReminders,
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time != null) {
                setState(() {
                  _reminderTime = time.format(context);
                });
                _saveSetting('reminder_time', _reminderTime);
              }
            },
          ),
          const Divider(),

          // Appearance Section
          _buildSectionHeader('Appearance'),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Theme'),
            subtitle: Text(_theme),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Choose Theme'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile<String>(
                        title: const Text('System Default'),
                        value: 'System',
                        groupValue: _theme,
                        onChanged: (value) {
                          setState(() => _theme = value!);
                          _saveSetting('theme', value!);
                          Navigator.pop(context);
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Light'),
                        value: 'Light',
                        groupValue: _theme,
                        onChanged: (value) {
                          setState(() => _theme = value!);
                          _saveSetting('theme', value!);
                          Navigator.pop(context);
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Dark'),
                        value: 'Dark',
                        groupValue: _theme,
                        onChanged: (value) {
                          setState(() => _theme = value!);
                          _saveSetting('theme', value!);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const Divider(),

          // Sound & Haptics Section
          _buildSectionHeader('Sound & Haptics'),
          SwitchListTile(
            secondary: const Icon(Icons.volume_up),
            title: const Text('Sound Effects'),
            subtitle: const Text('Play sounds for interactions'),
            value: _soundEffects,
            onChanged: (value) {
              setState(() => _soundEffects = value);
              _saveSetting('sound_effects', value);
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.vibration),
            title: const Text('Vibration'),
            subtitle: const Text('Haptic feedback'),
            value: _vibration,
            onChanged: (value) {
              setState(() => _vibration = value);
              _saveSetting('vibration', value);
            },
          ),
          const Divider(),

          // Data & Privacy Section
          _buildSectionHeader('Data & Privacy'),
          ListTile(
            leading: const Icon(Icons.cloud_upload),
            title: const Text('Backup Data'),
            subtitle: const Text('Save your data to the cloud'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Backup feature coming soon!')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text('Clear All Data'),
            subtitle: const Text('Delete all journals and moods'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear All Data'),
                  content: const Text(
                    'Are you sure? This will permanently delete all your journals, moods, and settings. This action cannot be undone.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Delete All'),
                    ),
                  ],
                ),
              );

              if (confirmed == true && mounted) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All data cleared')),
                  );
                }
              }
            },
          ),
          const Divider(),

          // About Section
          _buildSectionHeader('About'),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Version'),
            subtitle: const Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Terms of Service coming soon!')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy Policy coming soon!')),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
